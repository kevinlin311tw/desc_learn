%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

clear;

run('init');

Sets = {'notredame', 'yosemite', 'liberty'};

%% loop over sets
for iSet = 1:numel(Sets)
    
    Set = Sets{iSet};

    %% download and unpack patches
    PatchDir = sprintf('%s/%s/patches/', DataDir, Set);
    PatchesPath = [PatchDir '/patches.mat'];
    
    if exist(PatchesPath, 'file')
        continue;
    end

    mkdir(PatchDir);

    PatchURL = sprintf('http://www.cs.ubc.ca/~mbrown/patchdata/%s.zip', Set);
    
    fprintf('Downloading and extracting %s...\n', PatchURL);
    unzip(PatchURL, PatchDir)

    %% save patches in mat file
    D = dir([PatchDir '*.bmp']);

    nFiles = numel(D);

    info = load([PatchDir 'info.txt']);
    nPatches = size(info, 1);

    k = 0;

    Patches = cell(256 * nFiles, 1);

    for iFile = 1:nFiles

        fprintf('%d/%d\n', iFile, nFiles);

        PatchImg = imread([PatchDir D(iFile).name]);

        for i = 1:16
            for j = 1:16
                k = k + 1;
                Patches{k} = PatchImg((i - 1) * 64 + 1 : i * 64, (j - 1) * 64 + 1 : j * 64);
            end
        end    

    end

    Patches = Patches(1:nPatches);

    save(PatchesPath, 'Patches');
end