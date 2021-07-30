function [aux_vec] = TopK_Index(V, K)

% TopK_Index version 1, July 15 2021
%
% ====== Required inputs =============
%
%  V: Array vector
%  K: Number of elements desired
%
% ===================================================
%
% ============ Outputs ==============================
%   Largest indexe of K largest elements in the vector noted in a vector of
%   same length, i.e., outcome vector with same length as V, composed of
%   zeros, but with 1 at the positions of the K indexes corresponding to
%   the largest values
% ===================================================
%
% Note: this function was simply created to have an easier time plotting
% specific graphs

%Caculate Indexes
[~,I]=maxk(V,K);

%put those k largest elements in
[p,~] = size(V);
aux_vec = zeros(p, 1);
for j = 1:p
    if ismember(j, I)
        aux_vec(j) = 1;
    end
end

end