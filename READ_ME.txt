*** Description ***

Black-Box for MARES project, where backscatter microwave frequency responses are evaluated. This code divides itself in a three-fold:
	-> Detection of plastic litter in the backscatter signal by classification algorithm;
	-> Estimation of the quantity of plastic litter by regression algorithm;
	-> Evaluation of the optimal feature subset (i.e., optimal frequency interval) through feature selection strategies and other approapriate algorithms;


*** Available Framework ***


## Complex PCA



## L1norm Complex PCA


## SpaRSA 2.0 (Complex LASSO)

This set of MATLAB files contain an implementation of the
algorithms described in the paper "Sparse Reconstruction by
Separable Approximation", by Stephen Wright, Robert Nowak, and
Mario Figueiredo.

Both the paper and the code are available at
http://www.lx.it.pt/~mtf/SpaRSA/

The algorithm itself is in file SpaRSA.m

For usage details, type "help SpaRSA" at the MATLAB prompt.

There are 5 demos included, which illustrate how to use the
algorithm in some of the examples presented in the paper.

This package also includes the following two algorithms by
other authors (to allow running the comparative tests):

The l1_ls algorithm, which is described and can be downloaded
from http://www.stanford.edu/~boyd/l1_ls/

The FPC algorithm, which can be downloaded from
http://www.caam.rice.edu/~optimization/L1/fpc/fpc.zip

This code is in development stage; any comments or bug reports
are very welcome.

Contacts: mario.figueiredo@lx.it.pt
          nowak@ece.wisc.edu
          swright@cs.wisc.edu

---------------------------------------------------------------------------
Copyright (2007): Stephen Wright, Robert Nowak, and Mario
Figueiredo.

SpaRSA is distributed under the terms of the GNU General Public
License 2.0.

Permission to use, copy, modify, and distribute this software
for any purpose without fee is hereby granted, provided that
this entire notice is included in all copies of any software
which is or includes a copy or modification of this software
and in all copies of the supporting documentation for such
software. This software is being provided "as is", without any
express or implied warranty. In particular, the authors do not
make any representation or warranty of any kind concerning the
merchantability of this software or its fitness for any
particular purpose."
---------------------------------------------------------------------------

## Supervised PCA (Complex-LSPCA)

This code accompanies our work:

@article{ritchie2020supervised,   
  title={Supervised PCA: A Multiobjective Approach},   
  author={Ritchie, Alexander and Balzano, Laura and Kessler, Daniel and Sripada, Chandra S and Scott, Clayton},   
  journal={arXiv preprint arXiv:2011.05309},   
  year={2020}   
}

There are several helper files. The callable files are:

1) lspca_sub.m - supervised pca with the least squares loss function; for regression; uses substitution for \beta in place of alternating updates
2) lspca_MLE_sub.m - same as above; uses maximum likelihood updates for tuning parameter \lambda
3) lrpca.m - supervised pca with the logistic loss function; for classification
4) lrpca_MLE.m same as above; uses maximum likelihood updates for tuning parameter \lambda
5) the four files above prepended with 'k' - kernelized versions of those algorithms

*** NAME Discussion ***

MARES-PLEASE
MARES-PLEA
MARES-PLEDGe
MARES-NEMO

SATELLITE-BASED MICROWAVE REMOTE SENSING FOR MARINE LITTER MAPPING (MARES)

PLASTIC LITTER  ESTIMATION AND SUITABLE EVALUATION (PLEASE)
		ESTIMATION thorugh machine learning Algorithms (PLEA)
		ESTIMATION DETECTION GAUGE ocean environment (PLEDGe)