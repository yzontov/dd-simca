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
% correctly, so systematic cross-validation can be applied.
%
% This is a new version of the method which does not require rotations and thus
% faster.
%
% Based on
% Sergey Kucheryavskiy, 2021
% https://github.com/svkucheryavski/pcv
%
% See also: PCVOLD
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
   
  function Xn = norm(X, v)
      if (nargin == 1)
          v = sqrt(sum(X.^2, 2));
      end
      Xn = diag(1./v) * X;    
  end

   % autoscale the calibration set
   X = bsxfun(@minus, X, mX);
   X = bsxfun(@rdivide, X, sX);

   % create a global model
   [~, ~, P] = svd(X, 'econ');
   P = P(:, 1:nComp);
   I = eye(nCols);
   
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

   % prepare empty matrix for pseudo-validation set and vector for
   % distances
   Xpv = zeros(nRows, nCols);
   qk = zeros(nRows, 1);

   % cv-loop
   for k = 1:nSeg

      % split data to calibration and validation
      Xk = X(ind(val_start(k):val_stop(k)), :);
      Xc = X;
      Xc(ind(val_start(k):val_stop(k)), :) = [];

      % get loadings for local model and rotation matrix between global and local models
      [~, ~, Pk] = svd(Xc, 'econ');

      Pk = Pk(:, 1:nComp);
      Ek = Xk * (I - Pk * Pk');
      qk(ind(val_start(k):val_stop(k))) = sum(Ek.^2, 2);

      % correct direction of loadings for local model
      a = acos(sum(P .* Pk)) < pi / 2;
      Pk = Pk * diag(a * 2 - 1);

      % compute the explained part of the PV-set
      Xpv(ind(val_start(k):val_stop(k)), :) = Xk * (Pk * P');
   end      
   
   % compute orthogonal component (residuals)  and add to the PV-set
   if nComp < min(nCols, nRows - 1)
      U = rand(nRows, nRows) * 2 - 1;
      Z = U * X;
      Z = norm(Z);   
      Epv = Z * (I - P * P');
      Epv = norm(Epv, sqrt(sum(Epv.^2, 2)./qk));
      Xpv = Xpv + Epv;
   end
      
   % uscenter and unscale the data
   Xpv = bsxfun(@times, Xpv, sX);
   Xpv = bsxfun(@plus, Xpv, mX);
end

