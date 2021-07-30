function [coeff,score,latent,tsquared,explained,mu, X_transformed]= ComplexPCA(X, varargin)

% ComplexPCA version 1, July 15 2021
%
% ====== Required inputs =============
%
%  X: Data matrix of observations(m) and features(n), mxn
%
% ===================================================
%
% ====== Optional inputs =============
%
%  SVD: If 1 applied the SVD decomposition of PCA, if 0 applies the EIG
%  decomposition written
%  
%  FOR SVD:
%         Name *AND* Value as explained in the link below
%  FOR EIG:
%         K *OR* EXPLAINED_VARIANCE. Trim the corresponding results either by K components, or trim by 
%         the K components that explain a % of explaine variance
%
% Optional inputs are only required in case the desired complex PCA is
% performed by SVD - https://www.mathworks.com/help/stats/pca.html#bttveib-1
%
% Example:
% Name, Value; additional options for computation and handling of special data types, specified by one or more Name,Value pair arguments.
% K, 2; Trim the corresponding results by K components;
% EXPLAINED_VARIANCE, 0.999; Trim the corresponding results by K components that explain a % of explaine variance;
%
% =================================================== 
%
% ============ Outputs ==============================
%   x = solution of the main algorithm
%
% ===================================================

% test for number of required parametres
if (nargin-length(varargin)) ~= 1
     error('Wrong number of required parameters');
end

% check for svd decomp
if (rem(length(varargin),2)==1)
      error('Optional parameters should always go by pair or empty optional parameters');
else
    switch upper(varargin{1})
        case 'SVD'
            svd_flag = varargin{2};
    end
end
%Initialize outputs by same value
coeff=0;
score=0;
latent=0;
tsquared=0;
explained=0;
mu=0;
%Define wether we want CPCA by SVD or EVD

%CPCA by SVD using matlab PCA
if svd_flag
    % Read the optional parameters if they exist
    if length(varargin) > 3
        Name = varargin{3};
        Value = varargin{4};
    end
    
    %Note: By default, matlab PCA centers the data and uses SVD
    %Useful information on the returns: https://www.mathworks.com/matlabcentral/answers/399340-matlab-svd-pca-which-singular-values-belongs-to-which-variables
    if exist('Name','var') && exist('Value','var')
        [coeff,score,latent,tsquared,explained,mu] = pca(X, Name, Value);
        X_ = X - mu;
    else
        [coeff,score,latent,tsquared,explained,mu] = pca(X);
        X_ = X - mu;
    end
else
    %CPCA by EVD: https://journals.ametsoc.org/view/journals/apme/23/12/1520-0450_1984_023_1660_cpcata_2_0_co_2.xml
    
    %Some interest papers on the use of PCA:
    %https://journals.sagepub.com/doi/full/10.1177/0003702820987847 , https://doi.org/10.1177/0003702820987847
    %https://ieeexplore.ieee.org/document/8518155/references#references , doi: 10.1109/IGARSS.2018.8518155.
    %https://www.sciencedirect.com/science/article/pii/S0169743921000721?dgcid=rss_sd_all&utm_source=researcher_app&utm_medium=referral&utm_campaign=RESR_MRKT_Researcher_inbound
    %, https://doi.org/10.1016/j.chemolab.2021.104304
    
    %Getting number of observations and number of features
    [m, ~] = size(X);
    
    %Centering (and scaling not included since the values of freq should already be at the same scale, possibly include option to automatically decide)
    X_ = (X - mean(X));% ./ std(X);
    
    %Calculate sample covariance matrix
    Cov = (1/m)* X_'*X;
    
    %EVD:diagonal matrix D of eigenvalues and matrix V whose columns are the corresponding right eigenvectors
    % Not included the optional arguments for eig function!
    [V, D] = eig(Cov);
    
    %Sort the vectors/values accoding to the size of eigenvalue
    [V, D] = sortem(V, D);
    
    %Get vector of eigenvalues
    D = diag(D);
    
    %Explained variance & Cumulative sum of explained variance
    Explained_var = D / sum(D);
    Cum_sum_explained_var = cumsum(Explained_var);
    
    %Case we specify number of components or explained variance
    if length(varargin) > 2
        switch upper(varargin{3})
            case 'K'
                trim_k_components = varargin{4};
                coeff = V(:,1:trim_k_components);
                score = abs(D(1:trim_k_components));
                latent = abs(Explained_var(1:trim_k_components));
                tsquared = abs(Cum_sum_explained_var(1:trim_k_components));
            case 'EXPLAINED_VARIANCE'
                trim_ex_var = varargin{4};
                number_k = size(find(Cum_sum_explained_var<trim_ex_var),1);
                coeff = V(:,1:number_k);
                score = abs(D(1:number_k));
                latent = abs(Explained_var(1:number_k));
                tsquared = abs(Cum_sum_explained_var(1:number_k));
        end
    else
        %Just return the desired parameters as if
        coeff = V;
        score = abs(D);
        latent = abs(Explained_var);
        tsquared = abs(Cum_sum_explained_var);
    end
end
    %Transform the data
    X_transformed = X_ * coeff;
end

function [vectors, values] = sortem(vectors, values)
% https://github.com/gpeyre/matlab-toolboxes/blob/master/toolbox_nlmeans/toolbox/pca.m
%this error message is directly from Matthew Dailey's sortem.m
if nargin ~= 2
    error('Must specify vector matrix and diag value matrix')
end

vals = max(values); %create a row vector containing only the eigenvalues
[svals, inds] = sort(vals,'descend'); %sort the row vector and get the indicies
vectors = vectors(:,inds); %sort the vectors according to the indicies from sort
values = max(values(:,inds)); %sort the eigenvalues according to the indicies from sort
values = diag(values); %place the values into a diagonal matrix

end
