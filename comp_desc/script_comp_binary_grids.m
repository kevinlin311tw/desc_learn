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
    %PatchPath = sprintf('%s/patches_grids_64.mat', DatasetDir);
    
    %CBFDModelPath = sprintf('%s/%s/cbfd_model_%d.mat', DataDir, TrainSet, bin_size);
    CBFDModelPath = sprintf('%s/%s/cbfd_model_grids64_%d.mat', DataDir, TrainSet, bin_size);
    
    DescDir = sprintf('%s/desc/train_%s/', DatasetDir, TrainSet);
    mkdir(DescDir);

    %DescPath = sprintf('%s/desc_bin%d.mat', DescDir, bin_size);
    DescPath = sprintf('%s/desc_grids64_bin%d.mat', DescDir, bin_size);

    %% load data

    % load patches
    tic
    load(PatchPath, 'Patches');
    disp('Loaded patches !')
    toc
    
    % load model
    tic
    load(CBFDModelPath, 'W');
    disp('Loaded CBFD Models')
    toc
    
    % load pca 
    CBFDModelPath2 = sprintf('%s/%s/cbfd_model_grids64_%d_pca32.mat', DataDir, TrainSet, bin_size);
    load(CBFDModelPath2, 'Wo');
    
    %% compute binary descriptors
    nPatches = numel(Patches);
    tic
    disp('Computing descriptors ...\n')
    
    Desc = single([]);
    load Wo_512to32.mat;
    for iPatch = 1:nPatches
        temp = single([]);
        fprintf('binary codes %d/%d\n',iPatch, nPatches);
        A = Patches{iPatch};
        k = 0;       
        for ii = 1:(32/grid_size)
            for jj = 1:(32/grid_size)
                k = k + 1;        
                B = A((ii-1)*8+1:ii*8,(jj-1)*8+1:jj*8);
                temp = cat(2,temp,single((double(B(:))'*W)>0));
            end		
        end  
        
        
        
        temp = double(temp*Wo>0);
        
        Desc(:, iPatch) = temp;
    end
    toc

    %% save
    save(DescPath, 'Desc');
    
end


