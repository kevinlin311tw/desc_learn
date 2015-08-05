%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

clear;

run('init');

PRFiltersPath = sprintf('%s/common/PRFilters.mat', DataDir);

PatchSize = 64;

% sample PRs
[r, phi, sigma] = ndgrid(0:31, [0, pi/12, pi/8, pi/6, pi/4], 0.5:0.5:16);

PRParams = [r(:), phi(:), sigma(:)];

nParams = size(PRParams, 1);

nPR = nParams * 8;

PRFilters = zeros(nPR, PatchSize ^ 2, 'single');

k = 0;

%% symmetric PRs
for iCenter = 1:nParams
    
    fprintf('%d/%d\n', iCenter, nParams);
    
    RadRing = PRParams(iCenter, 1);
    phi = PRParams(iCenter, 2);
    sigma = PRParams(iCenter, 3);
    
    xc = RadRing * cos(phi);
    yc = RadRing * sin(phi);
    
    % special cases
    if phi == 0
        
        if RadRing == 0
            Offsets = [0 0];
        else
            
            Offsets =  [0 xc; ...
                        0 -xc; ...
                        xc, 0; ...
                        -xc, 0];
        end
                
    elseif phi == pi/4
        
        Offsets =  [yc   xc; ...
                    yc  -xc; ...
                    -yc,  xc; ...
                    -yc, -xc];
        
    else
        
        Offsets =  [yc   xc; ...
                    yc  -xc; ...
                    -yc,  xc; ...
                    -yc, -xc; ...
                    xc,  yc; ...
                    xc, -yc; ...
                    -xc, -yc; ...
                    -xc,  yc];
                
    end
    
    k2 = k;
    
    for iOffset = 1:size(Offsets, 1)
        
        PR = get_PR_filter(PatchSize, Offsets(iOffset, 2), Offsets(iOffset, 1), sigma);
        
        % Gaussian centred at (x0, y0)
        k2 = k2 + 1;
        PRFilters(k2, :) = PR(:)';
        
    end
    
    k = k + 8;
      
end

%% save
save(PRFiltersPath, 'PRFilters');
