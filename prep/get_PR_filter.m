%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

function PR = get_PR_filter(PatchSize, x0, y0, sigma)

    rExt = ceil(3 * sigma);
    
    % extended patch
    PR = zeros(PatchSize + 2 * rExt, 'single');
    
    x0 = x0 + 0.5 * (1 + PatchSize) + rExt;
    y0 = y0 + 0.5 * (1 + PatchSize) + rExt;
    
    % compute weights
    for y = floor(y0 - 3 * sigma) : ceil(y0 + 3 * sigma)
        for x = floor(x0 - 3 * sigma) : ceil(x0 + 3 * sigma)
            
            r2 = (x - x0) ^ 2 + (y - y0) ^ 2;
            PR(y, x) = exp(-r2 / (2 * sigma ^ 2));
            
        end
    end
    
    % crop the original patch borders
    PR = PR(rExt + 1 : PatchSize + rExt, rExt + 1 : PatchSize + rExt);
    
    % normalise to a unit sum
    PR = PR / sum(PR(:));

end