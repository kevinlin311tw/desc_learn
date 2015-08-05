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

TestPairsFile = 'm50_100000_100000_0';
bShowROC = true;

%% train-test combinations
for k = 1:size(TrainTestSet, 1)

    %% set paths
    TrainSet = TrainTestSet{k, 1};    
    TestSet = TrainTestSet{k, 2};

    DatasetDir = sprintf('%s/%s/', DataDir, TestSet);

    TestPairsPath = sprintf('%s/patches/%s.txt', DatasetDir, TestPairsFile);

    DescDir = sprintf('%s/desc/train_%s/%s/', DatasetDir, TrainSet, ProjType);
    DescPath = sprintf('%s/desc.mat', DescDir);

    %% load test data
    TestPairs = load(TestPairsPath);
    nTestPairs = size(TestPairs, 1);

    PatchesIdx1 = TestPairs(:, 1) + 1;
    PointID1 = TestPairs(:, 2);

    PatchesIdx2 = TestPairs(:, 4) + 1;
    PointID2 = TestPairs(:, 5);

    % match labels
    Label = single(PointID1 == PointID2);

    % load descriptors
    load(DescPath, 'Desc');

    %% compute ROC curve
    DescDiff = Desc(:, PatchesIdx1) - Desc(:, PatchesIdx2);
    PatchDist = sum(DescDiff .^ 2, 1);

    % sort descriptor distances in the ascending order
    [~, PatchRank] = sort(PatchDist, 'ascend');
    LabelRanked = Label(PatchRank);

    nPos = sum(Label);
    nNeg = nTestPairs - nPos;

    TPR = cumsum(LabelRanked == 1) / nPos;
    FPR = cumsum(LabelRanked == 0) / nNeg;

    % plot ROC curve
    if bShowROC

        figure;
        plot(FPR, TPR);
        title(sprintf('ROC: %s - %s', TrainSet, TestSet));
        xlabel('False positive rate');
        ylabel('True positive rate');
    end

    % area under curve
    AUC = trapz(FPR, TPR);

    % FPR @ 95% Recall
    IdxRecall95 = find(TPR >= 0.95, 1, 'first');
    FPR95 = FPR(IdxRecall95);

    % print measures
    fprintf('%s - %s, FPR95 = %.2f, AUC = %g\n', TrainSet, TestSet, FPR95 * 100, AUC);
end
