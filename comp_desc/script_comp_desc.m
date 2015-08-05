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
    'notredame', 'liberty'};

%% train-test combinations
for k = 1:size(TrainTestSet, 1)
    disp(k)
    %% set paths
    TrainSet = TrainTestSet{k, 1};    
    TestSet = TrainTestSet{k, 2};
    
    disp('Loading data !')
    DatasetDir = sprintf('%s/%s/', DataDir, TestSet);

    PatchPath = sprintf('%s/patches/patches.mat', DatasetDir);
    PRFiltersPath = sprintf('%s/common/PRFilters.mat', DataDir);

    PRModelPath = sprintf('%s/common/models/%s_PR.mat', DataDir, TrainSet);

    DescDir = sprintf('%s/desc/train_%s/%s/', DatasetDir, TrainSet, ProjType);
    mkdir(DescDir);

    DescPath = sprintf('%s/desc.mat', DescDir);

    %% load data

    % load patches
    tic
    load(PatchPath, 'Patches');
    disp('Loaded patches !')
    toc
    
    % load PR filters
    tic
    load(PRFiltersPath, 'PRFilters');
    disp('Loaded filters')
    toc
    
    % load model
    tic
    load(PRModelPath, 'w');
    disp('Loaded PR Models')
    toc
    
    % select pooling regions
    tic
    w = repmat(w', 8, 1);
    w = w(:);

    NZIdx = (w > 0) & any(PRFilters, 2);

    w = w(NZIdx);
    PRFilters = PRFilters(NZIdx, :);
    disp('Selected pooling regions')
    toc
        
    %% load projection
    tic
    switch ProjType

        case 'full'

            % low-rank projection learnt using nuclear-norm regularisation            
            ProjModelPath = sprintf('%s/common/models/%s_proj.mat', DataDir, TrainSet);
            load(ProjModelPath, 'Proj');                        

        case 'diag'

            % PR weights learnt together with PR selection
            w = repmat(w', 8, 1);
            Proj = diag(sqrt(w(:)));
    end
    disp('Done with projection')
    toc
    
    %% compute descriptors
    nPatches = numel(Patches);
    tic
    disp('Computing descriptors ...')
    
    Desc = single([]);

    parfor iPatch = 1:nPatches

        Desc(:, iPatch) = get_desc(Patches{iPatch}, PRFilters, Proj);

    end
    toc

    %% save
    save(DescPath, 'Desc');
    
end
