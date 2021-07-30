function [ ] = Plotting_Contributions(V_contribution, f, st, varargin)

% Plotting_Contributions version 1, July 15 2021
%
% ====== Required inputs =============
%
%  V_contribution: Contribution array vector from Feature Selection algorithms
%  f: feature array, x in the plots
%  st: title for the first subplot
%
% ===================================================
% ====== Optional inputs =============
%
%  k: What to call the total number of points, e.g., 'F' or 'N'
%
%  st2: Title for second plot
%  
%  Following arguments: User can decide to plot subplot selecting the highest F points in the
%  V_contribution array by selecting the number of points
%
%  Example: ...,'F', st2, 20, 100); want to plot 2 subplots highlighting the
%  largest 20 and 100 values from the V_contribution, respectively
%
% =================================================== 
%
% ============ Outputs ==============================
%   Plots of contributions from feature selection algorithms
% ===================================================
%

%Check if data matrix was input
if (nargin-length(varargin)) ~= 3
     error('Wrong number of required parameters');
end

%Plot contributions
figure
plot(f, V_contribution)
title(st,'FontName','Arial','FontSize',16)
axis tight
xlabel('Frequency[GHz]','FontSize',16)
ylabel('Contributions','FontSize',16)
grid on

if length(varargin) > 2
    number_subplots = length(varargin)-2;
    figure
    for i=3:length(varargin)
        subplot(number_subplots, 1, i-2)
        plot(f, TopK_Index(V_contribution, varargin{i})); hold on;
        axis tight
        if i == 3
            title(varargin{2},'FontName','Arial','FontSize',16)
        end
        formatspec='%s=%d';
        y_st=sprintf(formatspec,varargin{1},varargin{i});
        ylabel(y_st);
    end
    hold off;
    xlabel('Frequency[GHz]','FontSize',16)
    axis tight
end

end

% figure(5)
% for i = 1:length(select_k_features)
%     %find values and indexes of k largest elements
%     [B, I] = maxk( L_contribution, select_k_features(i));
%     %put those k largest elements in 
%     aux_vec = zeros(p, 1);
%     for j = 1:p
%         if ismember(j, I)
%             aux_vec(j) = 1;
%         end
%     end
%     %draw plot
%     subplot(length(select_k_features),1,i)
%     plot(freq_range/(10^9), aux_vec); hold on;
%     axis tight
%     if i == 1
%         st=sprintf('Optimal frequency intervals (F frequencies) for complex SPCA applied to all data with MSE = %0.3f, lambda = %0.1f', err_train, lambda);
%         title(st,'FontName','Times','FontSize',14)
%     end
%     st=sprintf('F= %d',select_k_features(i));
%     ylabel(st);
% end
% hold off;
% xlabel('Frequency[GHz]')
% axis tight