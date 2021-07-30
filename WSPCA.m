function [wS] = WSPCA(V,m, varargin)

% WSPCA version 1, July 15 2021
%
% ====== Required inputs =============
%
%  V: Feature (n) PCs (p) matrix for the data matrix already processed
%  (nxp), or nxk if we chose to follow the formulation adopted in the paper
%
% ===================================================
%
% ====== Optinal inputs =============
%
%  eigvals: Proportion of variance carried by each component, vector came
%  from EIG
%  singlevals: If PCA decomposition came from SVD, singular values still need 
%  to be converted towards eigenvalues (though matlab documentation is the
%  latent variable)
%
%   m: Number of observations, only usefull when singlevals
%
%   Example: ...,'eigvals', eigenvals_array);
%            ...,'singlevals', latent, m);
%
% ===================================================
%
% ============ Outputs ==============================
%   contribution_vec: Array containing the total contribution for each feature based on
%   the following paper: https://ieeexplore.ieee.org/document/7836727 , doi: 10.1109/ICDMW.2016.0096
% ===================================================
%
% For plotting, consider also using TopK_Index
% Note: Notation is paper is switched (n with m)!

%Check if feature matrix was input
if (nargin-length(varargin)) ~= 2
     error('Wrong number of required parameters, V and m');
end

% Read the optional parameters
if (rem(length(varargin),2)==1)
  error('Optional parameters should always go by pair');
else
    switch upper(varargin{1})
     case 'EIGVALS'
       pc_var = varargin{2};
     case 'SINGLEVALS'%Function converting still needs to be written
       pc_var = SingleValsToEigVals(varargin{2},m);
    end
end

%Matrix size
[n, k] = size(V);

%Build the weighted matrix
wV = zeros(n, k);
w_temp = 0;
for j=1:k
    w_temp = pc_var(j)/sum(pc_var);
    wV(:,j) = w_temp * V(:,j);
end

%Weighted score
wS = abs(sum(wV,2));

end