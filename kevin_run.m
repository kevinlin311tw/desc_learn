close all;
run('init');
addpath('cbfd_demo');
addpath('cbfd_demo/sp');
addpath('cbfd_demo/sup');
addpath('cbfd_demo/orth_opt');



%kevin_train;
%script_comp_binary;
script_comp_deepbinary;
script_ROC_binary;