function [B] = TopK_Values(V, K)

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
%   Largest K largest elements in the vector
% ===================================================
%
% Note: this function was simply created to have an easier time plotting
% specific graphs

%Caculate Indexes
[B,~]=maxk(V,K);

end