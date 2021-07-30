function [Q, init, S] = L1ComplexPCA(X, K, M, init, tol)

% L1ComplexPCA version 1, July 16 2021
%
% Implementation of https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8328897
%
% ====== Required inputs =============
%  (following paper formulation)
%  X: Data matrix (NxD), N obsersatons and D features
%  K: The dimension of the subspace we are looking for
%  M: Maximum number of iterations
%  init: Option to specify the initial points
%  tol: Converging constant
%
% ===================================================
%
% ============ Outputs ==============================
%  Q: Basis for local optimal subspaces
%  B: Associated optimal unimodular matrices.
%  S: Auxiliary singular values from svd
% ===================================================
%
% Note: this function was simply created to have an easier time plotting
% specific graphs

%Check if data matrix was input
if nargin ~= 5
     error('Wrong number of required parameters');
end

%Get observations and features
[N,D]= size(X);

%Rank of matrix X
rank_X = rank(X);

%Check if the desired subspace is larger than the rank of matrix
if K > rank_X
    error('Desired number of subspaces is larger than rank of matrix, input smaller K');
end

%Centering (and scaling not included since the values of freq should already be at the same scale, possibly include option to automatically decide)
X_ = (X - mean(X));% ./ std(X);

%Transpose to have similar formulation as Alg1 of the paper
X_ = transpose(X_);

%Check M/init/tol values
if ~exist('M','var') || isempty(M),M=100;end
if ~exist('tol','var') || isempty(tol),tol=1e-10;end
if ~exist('init','var') || isempty(init)
    init = ones(N, K);
end
%Initialize alpha
alpha = norm(X_*init, 'fro');

%Iterate
for iter_=1:M
    fprintf('Iteration:%d ; alpha=%f\n', iter_, alpha)
    
    %Auxiliary matrix Q and metric
    [Q,~,~] = unt(X_*init);
    
    %Calculate new B
    init = sign(X_' * Q);
    
    %Terminating Condition
    if (norm(X_*init, 'fro') - alpha) > tol
        alpha = norm(X_*init, 'fro');
    else
        fprintf('Convergency Reached!\n')
        break
    end
    
end

%SVD https://github.com/ktountas/L1-Norm-Algorithms/blob/master/matlab/lib/l1pca_BF.m
[U,S,V] = svd(X_*init);
Q = U(:,1:K)*V(:,1:K)';

end

%https://github.com/adamgann/l1-uwa/blob/master/matlab/complex_l1_pca/ForComplex.m
function [Q, sumS, isFullRank]=unt(A)

[U,S,V]=svd(A);
r=sum(diag(S)>1e-30);
Q=U(:,1:r)*V(:,1:r)';
sumS=sum(diag(S));
isFullRank= r==min(size(A));
end