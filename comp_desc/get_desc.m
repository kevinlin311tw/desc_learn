%  Copyright (c) 2012, Karen Simonyan
%  All rights reserved.
%  This code is made available under the terms of the BSD license (see COPYING file).

function Desc = get_desc(Patch, PR, Proj)

    TransParams = struct;
    TransParams.InitSigma = 1.4;
    TransParams.nAngleBins = 8;    
    TransParams.bNorm = true;
    
    % transform patch
    PatchTrans = trans_patch_T1(Patch, TransParams);
    
    % pool features
    Desc = PR * PatchTrans;
    
    % crop
    Desc = min(Desc, 1);
    
    % project
    Desc = Desc';
    Desc = Proj * Desc(:);
    
end