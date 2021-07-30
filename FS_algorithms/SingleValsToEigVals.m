function [eigenvals_] = SingleValsToEigVals(S,n)

% SingleValsToEigVals version 1, July 15 2021
%
% ====== Required inputs =============
%
%  S: Array of singlevals to transform to eigenvals (latent variable)
%
% ===================================================
%
% ============ Outputs ==============================
%   eigenvals_: Eigenvals, the proportion of variance carried by each
%   component (PC)
% ===================================================
%
% Note: auxiliary function to WSPCA

%Get diag values and size
% s_lambdas = diag(S);
[r,~] = size(S);

%Compute the proportion of variance carried by each component
eigenvals_ = zeros(r,1);
for j=1:r
    eigenvals_(j) = S(r)^2 /(n-1);
end

end