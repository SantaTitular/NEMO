function [contribution_vec] = FSPCA(V)

% FSPCA version 1, July 15 2021
%
% ====== Required inputs =============
%
%  V: Feature (n) PCs (p) matrix for the data matrix already processed (nxp)
%
% ===================================================
%
% ============ Outputs ==============================
%   contribution_vec: Array containing the total contribution for each feature based on
%   the following paper: https://ieeexplore.ieee.org/document/5640135 , doi: 10.1109/ICSEM.2010.14
% ===================================================
%
% For plotting, consider also using TopK_Index

%Caculate contribution
contribution_vec = sum(abs(V), 2);

end