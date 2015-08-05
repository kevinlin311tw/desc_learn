%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

clear;

run('init');
grid_size = 8;
Sets = {'notredame', 'yosemite', 'liberty'};

%% loop over sets
for iSet = 1:numel(Sets)
    
    Set = Sets{iSet};

    %% download and unpack patches
    PatchDir = sprintf('%s/%s/', DataDir, Set);
    PatchesPath1 = [PatchDir 'patches_grids_64.mat'];
    PatchesPath2 = [PatchDir 'patches_grids_64_vec.mat'];
    %{
    if exist(PatchesPath, 'file')
        continue;
    end
%}
    %mkdir(PatchDir);

    %PatchURL = sprintf('http://www.cs.ubc.ca/~mbrown/patchdata/%s.zip', Set);
    
    %fprintf('Downloading and extracting %s...\n', PatchURL);
    %unzip(PatchURL, PatchDir)

    %% save patches in mat file
    D = dir([PatchDir '*.bmp']);

    nFiles = numel(D);

    info = load([PatchDir 'info.txt']);
    nPatches = size(info, 1);

    k = 0;
    %grids_num = (((32/grid_size)-1)*grid_size)*((32/grid_size)-1)*grid_size;
    grids_num = (32/grid_size)*(32/grid_size);
    Patches = cell(256 * grids_num * nFiles, 1);
    
    for iFile = 1:nFiles

        fprintf('%d/%d\n', iFile, nFiles);

        PatchImg = imread([PatchDir D(iFile).name]);
        PatchImg = imresize(PatchImg, 0.5);
        for i = 1:16
            for j = 1:16
            A = PatchImg((i - 1) * 32 + 1 : i * 32, (j - 1) * 32 + 1 : j * 32);
        
                for ii = 1:(32/grid_size)
                    for jj = 1:(32/grid_size)
                        k = k + 1;
                        Patches{k} = A((ii-1)*8+1:ii*8,(jj-1)*8+1:jj*8);
                    end		
                end 
        %{
		for ii = 1:((32/grid_size)-1)*grid_size
			for jj = 1: ((32/grid_size)-1)*grid_size
				k = k + 1;
				Patches{k} = A(ii:ii+grid_size,jj:jj+grid_size);
			end		
		end       
         %}
		%Patches{k} = PatchImg((i - 1) * 32 + 1 : i * 32, (j - 1) * 32 + 1 : j * 32);
                %temp = PatchImg((i - 1) * 64 + 1 : i * 64, (j - 1) * 64 + 1 : j * 64);
                %Patches_vec(k,:) = temp(:)';
            end
        end    

    end

    Patches = Patches(1:nPatches);
    save(PatchesPath1, 'Patches');
   %{ 
    k = 0;
    Patches_vec = zeros(1, 4096);
    for  k = 1:(256*nFiles)
        %k = k + 1;
        temp = Patches{k};
        Patches_vec(k,:) = temp(:)';
        fprintf('%d/%d\n', k, 256*nFiles);
    end
    save(PatchesPath, 'Patches', 'Patches_vec');
    %}
    
    patches_vec = zeros(grid_size*grid_size,1);
    patches_vec = uint8(patches_vec);

    data_num = size(Patches);

    for i = 1:data_num
        fprintf('%d/%d\n',i,data_num);
        patches_vec(:,i) = Patches{i}(:);   
    end
    
    %save Patches_vec patches_vec;
    
    save(PatchesPath2,'patches_vec','-v7.3');
    %save(PatchesPath, 'Patches','patches_vec' );
    %PatchesPath = [PatchDir 'patches_vec.mat'];
    %save(PatchesPath, 'patches_vec');
end
