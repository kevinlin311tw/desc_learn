%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

clear;

run('init');

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

    DescPath = sprintf('%s/desc_bin%d.mat', DescDir, bin_size);

    %% load data

    % load patches
    tic
    load(PatchPath);
    disp('Loaded patches !')
    toc

    % load model
    tic
    load(CBFDModelPath, 'W');
    disp('Loaded CBFD Models')
    toc
    
    %% compute binary descriptors
    nPatches = numel(Patches);

    tic
    disp('Computing descriptors ...\n')
    
    Desc = single([]);
    %PDV =pdv_extract(patches_vec',1,1);  
    for iPatch = 1:nPatches
        fprintf('binary codes %d/%d\n',iPatch, nPatches);
        %dataset = double(patches_vec(:,iPatch));
               

        %Desc(:, iPatch) = single(Patches{iPatch}*W > 0);
        Desc(:, iPatch) = single((double(Patches{iPatch}(:))'*W)>0); %ok this one
       
    end
    toc

    %% save
    save(DescPath, 'Desc');
    
end


