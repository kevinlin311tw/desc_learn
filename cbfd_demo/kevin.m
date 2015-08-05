%% CBFD Implementation

clc;
close all;
clear variables

addpath orth_opt
addpath sp
addpath sup

% Set parameters
params.ht = 28;
params.wt = 28;
params.N = 8;
params.M = 8; 
params.lambda1 = 0.001;
params.lambda2 = 0.0001;
params.binsize = 32;
params.dictsize = 500;
params.n_iter = 1000;
params.coeff = 1000;
%{
makebatches;
mnist_data = zeros(60000,784);
a = 0;
for i = 1:100
    for j = 1:600
        a = a + 1;
        mnist_data(a,:)=batchdata(i,:,j);
    end
end

%}
%cbfd_train;

load mnist/mnist.mat
fprintf('learn CBFD for MNIST digits');

        
        W = cbfd_learn(mnist_data,params.binsize, ...
            params.n_iter,params.lambda1,params.lambda2);
        D = CalculateDictionary(double(mnist_data*W >0), ...
            params.dictsize); 
save mnist_cbd W D params;

b_feat = double(mnist_data*W > 0);
save mnist_binarycode b_feat; 
%load cbfd.mat

%load feret\gallery.mat    
%{
ytr = label;
Xtrain = extractFeature(data,W,D,params);
[eigvec2,eigval,~,sampleMean] = PCA(Xtrain);
eigvec = (bsxfun(@rdivide,eigvec2',sqrt(eigval))');
xtr = (bsxfun(@minus, Xtrain, mean(Xtrain))*eigvec(:,1:params.coeff))';

probe{1}='dup1'; probe{2}='dup2';
for i =1:2
    load(['feret\' probe{i} '.mat']);
    yts = label;
    Xtest = extractFeature(data,W,D,params);
    xts = (bsxfun(@minus, Xtest, sampleMean)*eigvec(:,1:params.coeff))';
    acc(i) = NN(xtr',ytr',xts',yts',2);
end
fprintf('\nRank-1 recognition rate for %s set:%2.2f\n',probe{1},acc(1));
fprintf('\nRank-1 recognition rate for %s set:%2.2f\n',probe{2},acc(2));
%}
