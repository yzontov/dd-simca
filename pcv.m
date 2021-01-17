% Compute matrix with pseudo-validation set
%
% Arguments
% ---------
% X         matrix with calibration set (IxJ)
% nComp     number of components for PCA decomposition
% nSeg      number of segments for cross-validation
% Center    logical, mean-center columns of X prior to decompositon or not
% Scale     logical, standardize columns of X prior to decompositon or not
%
% The method computes pseudo-validation matrix Xpv, based on PCA decomposition of calibration set X
% and systematic (venetian blinds) cross-validation. It is assumed that data rows are ordered
% correctly, so systematic cross-validation can be applied
%
% Based on
% Sergey Kucheryavskiy, 2020
% https://github.com/svkucheryavski
%
% Cite as:
% Kucheryavskiy, S., Zhilin, S., Rodionova, O., Pomerantsev A., 
% Procrustes Cross-Validation—A Bridge between Cross-Validation and Independent Validation Sets. 
% Analytical Chemistry, 92 (17), 2020. pp.11842–11850. DOI: 10.1021/acs.analchem.0c02175
%
function Xpv = pcv(X, nComp, nSeg, Center, Scale)

   nRows = size(X, 1);
   nCols = size(X, 2);

   if nargin < 5
      Scale = false;
   end
   
   if nargin < 4
      Center = false;
   end

   if nargin < 3
      nSeg = 4;
   end

   if nargin < 2
      nComp = min(round(nRows / nSeg) - 1, nCols);
   end

   % compute and save mean and standard deviation
   if Center
      mX = mean(X);
   else
      mX = zeros(1, nCols);
   end

   if Scale
      sX = std(X);
   else
      sX = ones(1, nCols);
   end

   % autoscale the calibration set
   X = bsxfun(@minus, X, mX);
   X = bsxfun(@rdivide, X, sX);

   % create a global model
   [~, ~, P] = svd(X, 'econ');
   P = P(:, 1:nComp);

   % create matrix with indices for cross-validation, so
   % each column is number of rows to be taken as local validation set
   % in corresponding segment
   cvSeq = 1:nRows;
   segLen = ceil(nRows / nSeg);
   segRes = segLen * nSeg - nRows;
   if (segRes > 0)
      cvSeq = [cvSeq, ones(1,segRes) * (-1)];
   end
   ind = reshape(cvSeq, nSeg, segLen)';
   ind = reshape(ind, 1, segLen * nSeg);
   ind(ind<0) = [];
   [val_start, val_stop] = crossval_indexes(nRows, nSeg );

   % prepare empty matrix for pseudo-validation set
   Xpv = zeros(nRows, nCols);

   % cv-loop
   for k = 1:nSeg

      % split data to calibration and validation
      Xk = X(ind(val_start(k):val_stop(k)), :);
      Xc = X;
      Xc(ind(val_start(k):val_stop(k)), :) = [];

      % get loadings for local model and rotation matrix between global and local models
      [~, ~, Pk] = svd(Xc, 'econ');

      Pk = Pk(:, 1:nComp);

      % correct direction of loadings for local model
      a = acos(sum(P .* Pk)) < pi / 2;
      Pk = Pk * diag(a * 2 - 1);

      % get rotation matrix between the PC spaces
      R = getR(Pk, P);

      % rotate the local validation set and save as a part of Xpv
      Xpv(ind(val_start(k):val_stop(k)), :) = Xk * R';
   end

   % uscenter and unscale the data
   Xpv = bsxfun(@times, Xpv, sX);
   Xpv = bsxfun(@plus, Xpv, mX);
end

% Generates indexes for k-fold cross-validation
% N - number of samples
% fold - number of partitions (i.e. 3, 5, 10)
%
% Yury Zontov, 2019
% https://github.com/yzontov
%
function [val_start, val_stop] = crossval_indexes(N, fold )

            k = N;
            if(mod(k, fold) == 0)
                x = 1:k;
                rows = k / fold;
                y = reshape (x, [rows, fold]);
                start = y(1,:);
                stop = y(end,:);
            else
                rows = fix(k / fold);
                x = 1:rows*fold;
                y = reshape (x, [rows, fold]);
                start = y(1,:);
                stop = y(end,:);
                
                for i = 1:mod(k, fold)
                    stop(i) = stop(i) + 1;
                    start(i+1:end) = start(i+1:end) + 1;
                    stop(i+1:end) = stop(i+1:end) + 1;
                end
            end
            
            val_start = start;
            val_stop = stop;
            
end

% Creates rotation matrix to map a set vectors
%
% Base1 - matrix (JxA) with A orthonormal vectors as columns to be rotated (A <= J)
% Base2 - matrix (JxA) with A orthonormal vectors as columns, Base1 should be aligned with
%
% In both sets vectors should be orthonormal.
%
function R = getR(Base1, Base2)

   R1 = rotationMatrixToX1(Base1(:, 1));
   R2 = rotationMatrixToX1(Base2(:, 1));

   if size(Base1, 2) == 1
      R = R2' * R1;
      return
   end

   % Compute bases rotated to match their first vectors to [1 0 0 ... 0]'
   Base1R = R1 * Base1;
   Base2R = R2 * Base2;

   % Get bases of subspaces of dimension n-1 (forget x1)
   Base1RS = Base1R(2:end, 2:end);
   Base2RS = Base2R(2:end, 2:end);

   % Recursevely compute rotation matrix to map subspaces
   Rs = getR(Base1RS, Base2RS);

   % Construct rotation matrix of the whole space (recall x1)
   M = eye(size(Base1R, 1));
   M(2:end, 2:end) = Rs;

   R = R2' * (M * R1);
end

% Creates a rotation matrix to map a vector x to [1 0 0 ... 0]
%
% x - vector (sequence with J coordinates)
%
function R = rotationMatrixToX1(x)
   N = numel(x);
   R = eye(N);
   step = 1;

   while step < N
      A = eye(N);
      n = 1;
      while n <= N - step
         r2 = x(n)^2 + x(n + step)^2;
         if r2 > 0
            r = sqrt(r2);
            pcos = x(n) / r;
            psin = -x(n + step) / r;
            A(n, n) = pcos;
            A(n, n + step) = -psin;
            A(n + step, n) = psin;
            A(n + step, n + step) = pcos;
         end
         n = n + 2 * step;
      end
      step = 2 * step;
      x = A * x;
      R = A * R;
   end
end

        
   