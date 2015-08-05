=============================================
Descriptor Learning Using Convex Optimisation
=============================================

--------
Overview
--------

This package contains the Matlab source code for feature descriptor computation and evaluation. Algorithm 
details can be found in [1]. The project web page (with links to additional downloads, etc.) is 
http://www.robots.ox.ac.uk/~vgg/research/learn_desc/

The source code is released under the terms of the BSD license. Please cite [1] if you use the code. 
If you have any questions regarding the package, please contact Karen Simonyan <karen@robots.ox.ac.uk>

In a separate archive, we also release the descriptor models learnt on the local patches datasets [2]. This
allows one to reproduce the results reported in [1] (the third columns of Tables 1 and 2 of the paper).

------------
Dependencies
------------

The source code depends on the publicly available VLFeat library, which can be downloaded from
http://www.vlfeat.org/ and should be in the Matlab path.

-----
Usage
-----

1. Initialisation

Run init.m to set-up the paths to the source code and data.

2. Preparation

The descriptor computation code relies on the pre-computed pooling region filters and descriptor models.
Also, the patches should be stored in the Matlab format. These data can be downloaded from our website and 
should be unpacked to the same directory as the source code:
    
    a) filters: 
       http://www.robots.ox.ac.uk/~vgg/software/learn_desc/patches/PR_filters.tar
       
    b) models trained on patches datasets [2]: 
       http://www.robots.ox.ac.uk/~vgg/software/learn_desc/patches/models.tar
       
    c) patches datasets [2] in Matlab format: 
       http://www.robots.ox.ac.uk/~vgg/software/learn_desc/patches/patches.tar

Alternatively, you can compute the pooling region filters by running "script_gen_PR.m". The result will be 
stored  in "data/common/PRFilters.mat". Also, the datasets can be downloaded from the original website
(http://www.cs.ubc.ca/~mbrown/patchdata/patchdata.html) and converted to the required format by running
"script_save_patches.m". The result will be stored in "data/<set_name>/patches/patches.mat".

3. Patch descriptor computation

To compute the descriptors, run "script_comp_desc.m". The result will be stored in 
"data/<set_name>/desc/train_<training_set_name>/"

The results in Table 1 of [1] were obtained using the learnt pooling regions without the discriminative
low-dimensional projection. To reproduce these results, set "ProjType = 'diag';" in "script_comp_desc.m" and
"script_ROC_desc.m". The pooling region models (sparse vectors of pooling region weights) should be stored in 
"data/common/models/<training_set_name>_PR.mat"

The results in Table 2 of [1] were obtained using both learnt pooling regions and discriminative 
low-dimensional projections. To reproduce these results, set "ProjType = 'full';" in "script_comp_desc.m" and 
"script_ROC_desc.m" (it is the default value). The projection models should be stored in 
"data/common/models/<training_set_name>_proj.mat"

Alternatively, the descriptors computed on datasets [2] can be downloaded from our website:
http://www.robots.ox.ac.uk/~vgg/software/learn_desc/patches/desc.tar and unpacked to the same directory as the
source code.

4. Evaluation

Run "script_ROC_desc.m" to evaluate the computed descriptors. The results should exactly match those reported
in [1].

----------
References
----------

[1] K. Simonyan, A. Vedaldi, and A. Zisserman
Descriptor Learning Using Convex Optimisation
In Proceedings of the European Conference of Computer Vision, 2012
http://www.robots.ox.ac.uk/~vgg/publications/2012/Simonyan12/simonyan12.pdf

[2] M. Brown, G. Hua, S. Winder
Discriminative Learning of Local Image Descriptors
IEEE Trans. on Pattern Analysis and Machine Intelligence, 2011 