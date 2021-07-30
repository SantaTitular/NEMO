function [L_lspca, Z_lspca, B_lspca, train_mse, test_mse, mu_, std_] = ComplexSPCA(X, Y, lambda, k, varargin)

% Complex SPCA using LSPCA framework version 1, July 19 2021
%
% ====== Required inputs =============
%
%  X: (raw) Data matrix, consists of m observations and n features (mxn)
%  Y: Labels associated with each observation of the data matrix
%  lambda: tuning parameter (higher lambda -> more empasis on
%          capturing response varable relationship)
%  k: Desired number of dimentions
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
%  L0: (n x k) initial guess at a subspace
%           -default: pass in L0 = 0 and first k principle
%           components will be used
%  
%  Example: ComplexSPCA(X_20210707_no_waves, Y_20210707_no_waves, 0.5, 2, ...
%                                                ,'scaling' 1,...
%                                                ,'split', 0.3,...
%                                                'L0', zeros(n,k));
% =================================================== 
%
% ============ Outputs ==============================
%  L: (n x k) matrix with rowspan equal to the desired subspace
%  Z: (m_train x k) dimension reduced form of X; A = X*L'
%  B: (k x 1) regression coefficients mapping reduced X to Y
%           i.e. Y = X*L'*B
%  train_mse: MSE value of the train data
%  test_mse: MSE value of the test data
%  mu_ : Mean of training data
%  std_ : Standard deviation of training data
% ===================================================
%
% Note: This algorithm uses the LSPCA framework. Any additional
% considerations should be introduced in the code by following the notes of
% the authors in lspca_sub.m

% test for number of required parametres
if (nargin-length(varargin)) ~= 4
     error('Wrong number of required parameters');
end

% start the clock
tic

%default optional parameters
scale_flag = 0;
centering_flag = 1;
split_ratio = 0.2;
mu_ = 0;
std_ = 0;
%Initial guess at subspace
L0 = 0; %Default value 0, it will be used the PCA (SVD) to define initial subset

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
      case 'L0'
       L0 = varargin{i+1};
    end
  end
end

disp('Preparing data...')
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

disp('Applying SPCA...')
% SpaRSA function with pre-defined
[Z_lspca, L_lspca, B_lspca] = lspca_sub(R, Y_Train, lambda, k, L0);

disp('Finished SPCA, calculating MSEs...')
%Estimate MSE's (train and test)
y_train_estimated = R * L_lspca * B_lspca;
train_mse = immse(Y_Train, y_train_estimated);
y_test_estimated = R_test * L_lspca * B_lspca;
test_mse = immse(Y_Test, y_test_estimated);

disp('Finished!')
% Stop the clock
toc
end