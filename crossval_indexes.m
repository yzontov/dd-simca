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

