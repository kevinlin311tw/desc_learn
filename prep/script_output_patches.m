%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).
    
clear;

run('init');

Sets = {'notredame', 'yosemite', 'liberty'};

%% loop over sets
for iSet = 1:numel(Sets)
    
    Set = Sets{iSet};
    txtfile = sprintf('%s_list.txt',Set);
    fid = fopen(txtfile, 'wt');
    %% download and unpack patches
    PatchDir = sprintf('%s/%s/imgs/', DataDir, Set);
    PatchDir2 = sprintf('%s/%s/', DataDir, Set);

    %{
    if exist(PatchesPath, 'file')
        continue;
    end
%}
    %mkdir(PatchDir);


    %% save patches in mat file
    D = dir([PatchDir2 '*.bmp']);

    nFiles = numel(D);

    info = load([PatchDir2 'info.txt']);
    nPatches = size(info, 1);

    k = 0;

    Patches = cell(256 * nFiles, 1);
    
    for iFile = 1:nFiles

        fprintf('%d/%d\n', iFile, nFiles);

        PatchImg = imread([PatchDir2 D(iFile).name]);

        for i = 1:16
            for j = 1:16
                k = k + 1;
                img = PatchImg((i - 1) * 64 + 1 : i * 64, (j - 1) * 64 + 1 : j * 64);
                f = sprintf('%s%d.jpg',PatchDir,k);
                %imwrite(img,f);
                fprintf(fid, '%s\n',f);
            end
        end    
    end
    fclose(fid);
end