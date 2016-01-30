function eigenvecs = pca_fun(X, d)

% Implementation of PCA
% input:
%   X - N*D data matrix, each row as a data sample
%   d - target dimensionality, d <= D
% output:
%   eigenvecs: D*d matrix
%
% usage:
%   eigenvecs = pca_fun(X, d);
%   projection = X*eigenvecs;
%
    
    % set to zero-mean
    N = size(X, 1);
    means = mean(X, 1);
    X = X - repmat(means, N, 1);
    
    covar = 1/N * (X' * X);
    [evecs, evals] = eig(covar);
    
    % sort eigenvectors by eigenvalues (descending)
    [~, idx] = sort(diag(evals), 'descend');
    evecs = evecs(:, idx);
    
    eigenvecs = evecs(:, 1:d);

end
