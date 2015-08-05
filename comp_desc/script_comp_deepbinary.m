%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

clear;

run('init');
addpath('/home/kevin/caffe-master');
addpath('/home/kevin/caffe-master/matlab');
addpath('/home/kevin/caffe-master/matlab/demo');
addpath('/home/kevin/caffe-master/matlab/+caffe');


% ProjType = 'diag';
ProjType = 'full';

% training & test set combinations
TrainTestSet = {'yosemite', 'notredame'; ...
    'yosemite', 'liberty'; ...
    'notredame', 'yosemite'; ...
    'notredame', 'liberty'; ...
    'liberty', 'yosemite'; ...
    'liberty', 'notredame'};

%% train-test combinations
for k = 1:size(TrainTestSet, 1)
    disp(k)
    %% set paths
    TrainSet = TrainTestSet{k, 1};    
    TestSet = TrainTestSet{k, 2};
    
    disp('Loading data !')
    DatasetDir = sprintf('%s/%s/', DataDir, TestSet);

    PatchPath = sprintf('%s/patches_1024.mat', DatasetDir);

    CBFDModelPath = sprintf('%s/%s/cbfd_model_%d.mat', DataDir, TrainSet, bin_size);
    
    DescDir = sprintf('%s/desc/train_%s/', DatasetDir, TrainSet);
    mkdir(DescDir);

    DescPath = sprintf('%s/desc_deepbin%d.mat', DescDir, bin_size);

    %% load data

    % load patches
    tic
    %load(PatchPath);
    image_list = sprintf('%s_list.txt',TestSet);
    disp('Loaded patches !')
    toc

    % load model
    tic
    %load(CBFDModelPath, 'W');
    %disp('Loaded CBFD Models')
    toc
    
    %% compute binary descriptors


    tic
    disp('Computing descriptors ...\n')
    
    Desc = single([]);

              
        %Desc(:, iPatch) = single((double(Patches{iPatch}(:))'*W)>0); %ok this one
        
        %img = Patches{iPatch};
        %img_rgb =repmat(img,[1 1 3]);
        [feat, list_im] = patch_demo2(image_list,TrainSet);
        Desc = feat;
        %Desc = single(feat>0);
    toc

    %% save
    save(DescPath, 'Desc','-v7.3');
    
end


