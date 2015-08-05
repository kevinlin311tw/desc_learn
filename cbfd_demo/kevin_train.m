%% CBFD Implementation

    
clc;
close all;
clear variables
run('init');

addpath orth_opt
addpath sp
addpath sup

% Set parameters
%params.ht = 64;
%params.wt = 64;
%params.N = 8;
%params.M = 8; 
params.lambda1 = 0.0001;
params.lambda2 = 0.0001;
params.binsize = bin_size;
params.dictsize = 500;
params.n_iter = 10;
params.coeff = 1000;
dataset_num = 200000;
Sets = {'notredame', 'yosemite', 'liberty'};

%% loop over sets
for iSet = 1:numel(Sets)

    
    Set = Sets{iSet};

    PatchDir = sprintf('./data/%s/', Set);
    Data = [PatchDir 'patches_1024_vec.mat'];% resize image to 32*32(1024)
    %Data = [PatchDir 'patches_grids_64_vec.mat']; %grid_size=8 8*8=64
    
    load(Data);
    PatchesPath = sprintf('%scbfd_model_%d.mat',PatchDir,params.binsize);
    num = sprintf('%d',bin_size);
    %PatchesPath = [PatchDir 'cbfd_model_grids64_' num '.mat'];
    %PatchesPath2 = [PatchDir 'cbfd_model_grids64_' num '_pca32.mat'];

    fprintf('learn CBFD for %s',Set);
    dataset = double(patches_vec(:,1:dataset_num));
    %PDV =pdv_extract(dataset',1,1);
    W = cbfd_learn(dataset',params.binsize, ...
            params.n_iter,params.lambda1,params.lambda2);
    %D = CalculateDictionary(double(dataset'*W >0), ...
    %        params.dictsize); 

    save(PatchesPath,'W','params','-v7.3');
    %{
    Desc = dataset'*W;
    [nSmp, nFea] = size(Desc);
    M = mean(Desc,1);
    data = (Desc-repmat(M,nSmp,1));
    [eigvec eigval]=eig(data'*data);
    [~,I] = sort(diag(eigval),'descend');
    Wo=eigvec(:,I(1:32));
    save(PatchesPath2,'Wo','-v7.3');
%}
end

