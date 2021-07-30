function [x_sparsa, train_mse, test_mse, mu_, std_] = ComplexLasso(X, Y, tau, varargin)

% Complex LASSO using SpaRSA framework version 1, July 19 2021
%
% ====== Required inputs =============
%
%  X: (raw) Data matrix, consists of m observations and n features (mxn)
%  Y: Labels associated with each observation of the data matrix
%  tau: regulation parameter associated with the LASSO model (to be used by the SpaRSA)
%
% ===================================================
%
% ====== Optional inputs =============
%
%  Scaling: Denotes whether the data should be scaled or not (if used in conjunction with centering translates
%            into normalizing the dataset). Default is 0 due to the nature of the MW data;
%  Centering: Denotes whether the data should be centered (if used in conjunction with centering translates
%            into normalizing the dataset). Default is 1 due to the nature of the MW data;
%  Split: Defines the split ratio when dividing the data into train and test data
%  tolA: Convergence parameter to be used by SpaRSA framework, default is 1e-7;
%  
%  Example: ComplexLASSO(X_20210707_no_waves, Y_20210707_no_waves, 0.5,...
%                                                ,'scaling' 1,...
%                                                ,'split', 0.3,...
%                                                'tolA', 1e-8);
% =================================================== 
%
% ============ Outputs ==============================
%  x_sparsa: Solution of the LASSO objective function (||y - Ax||_2 + lambda*||x||_1)
%  train_mse: MSE value of the train data
%  test_mse: MSE value of the test data
%  mu_ : Mean of training data
%  std_ : Standard deviation of training data
% ===================================================
%
% Note: This algorithm uses the SpaRSA framework. Any additional
% considerations should be introduced in the code by following the notes of
% the authors in SpaRSA.m

% test for number of required parametres
if (nargin-length(varargin)) ~= 3
     error('Wrong number of required parameters');
end

%default optional parameters
scale_flag = 0;
centering_flag = 1;
split_ratio = 0.2;
tolA = 1e-7;
mu_ = 0;
std_ = 0;

% Read the optional parameters
if (rem(length(varargin),2)==1)
  error('Optional parameters should always go by pairs');
else
  for i=1:2:(length(varargin)-1)
    switch upper(varargin{i})
     case 'SCALING'
       scale_flag = varargin{i+1};
      case 'CENTERING'
       centering_flag = varargin{i+1};
      case 'SPLIT'
       split_ratio = varargin{i+1};
      case 'TOLA'
       tolA = varargin{i+1};
    end
  end
end

%Split data into train and test data using Cross varidation (default,
%train: 80%, test: 20%): https://www.mathworks.com/matlabcentral/answers/377839-split-training-data-and-testing-data
rng('default');
cv = cvpartition(size(X,1),'HoldOut',split_ratio);
idx = cv.test;
% Separate to training and test data
X_Train = X(~idx,:);
X_Test  = X(idx,:);
% Separate to training and test data
Y_Train = Y(~idx,:);
Y_Test  = Y(idx,:);

%Centering and scaling options, prepare the data
if centering_flag && scale_flag
    mu_ = mean(X_Train);
    std_ = std(X_Train);
    R = (X_Train - mu_) ./ std_;
    R_test = (X_Test - mu_) ./ std_;
elseif centering_flag
    mu_ = mean(X_Train);
    R = (X_Train - mu_);
    R_test = (X_Test - mu_);
elseif scale_flag
    std_ = std(X_Train);
    R = X_Train ./ std_;
    R_test = X_Test ./ std(X_Train);
end

%TwIST handlers
% Linear operator handlers
hR = @(x) R*x;
hRt = @(x) R'*x;
% define the regularizer and the respective denoising function
% TwIST default
Psi = @(x,th) soft(x,th);   % denoising function
Phi = @(x)    sum(abs(x(:)));     % regularizer

% SpaRSA function with pre-defined
[x_sparsa,x_debias_sparsa,obj_sparsa,...
    times_sparsa,debias_start_sparsa,mse_sparsa]= ...
        SpaRSA(Y_Train,R,tau,...
        'Debias',0,...
        'AT', hRt, ... 
        'Phi',Phi,...
        'Psi',Psi,...
        'Monotone',1,...
        'Initialization',0,...
        'StopCriterion',1,...
        'ToleranceA',tolA,...
        'Verbose', 1);
       
%Estimate MSE's (train and test)
y_train_estimated = R*x_sparsa;
train_mse = immse(Y_Train, y_train_estimated);
y_test_estimated = R_test*x_sparsa;
test_mse = immse(Y_Test, y_test_estimated);

end