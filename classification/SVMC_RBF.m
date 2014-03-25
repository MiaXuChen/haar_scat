function [PredictLabel Acc opt_gamma opt_C] = SVMC_RBF(TrainData, TrainLabel, TestData, TestLabel)

% ----------------------------------------------------------------------------%
% SVMC_RBF.m: Multi-class RBF-kernel SVM including parameter selection by
% cross validation.
% Mia Xu Chen, updated on Feb 11, 2013
%
% ** Pls include LIBSVM toolbox outside this function, e.g. 'addpath(genpath('./libsvm-3.12/'));'
% ** For infomation about LIBSVM, pls refer to: http://www.csie.ntu.edu.tw/~cjlin/papers/guide/guide.pdf
% 
% ----------------------------------------------------------------------------%
% Input: 
% 
% TrainData    - A matrix containing training samples as rows
% TrainLabel   - A column vector containing training labels
%
% TestData     - A matrix containing testing samples as rows
% TestLabel    - A column vector containing testing labels
%
% ** TrainData and TestData are already after normalization to [-1,1] using the same
% scaling factor.
% 
% Output:
%
% PredictLabel - Predicted class label for TestData
% Acc          - Accuracy
% opt_gamma    - Optimal value of parameter gamma out of cross validation
% opt_C        - Optimal value of parameter C out of cross validation
% ----------------------------------------------------------------------------%

% Parameter selection by cross-validation based on grid search

gamma = 2.^(-1:2:3)';%2.^(-15:2:3)';
C = 2.^(-1:2:15)';
numcv = 5; % # of cross validation folds

cvAcc = zeros(length(gamma),length(C));

for igamma = 1:length(gamma)
    for iC = 1:length(C)
        svm_opt = sprintf('-t 2 -h 0 -v %d -g %11.9f -c %11.5f', numcv, gamma(igamma), C(iC));
        cvAcc(igamma,iC) = svmtrain(TrainLabel, TrainData, svm_opt);
    end
end

[tempval idx_C] = max(max(cvAcc));
[tempval idx_gamma] = max(max(cvAcc,[],2));

opt_C = C(idx_C);
opt_gamma = gamma(idx_gamma);

% SVM

svm_opt = sprintf('-t 2 -h 0 -g %11.9f -c %11.5f', opt_gamma, opt_C);
        
ModelRBF = svmtrain(TrainLabel, TrainData, svm_opt); 

[PredictLabel, temp, dec_values] = svmpredict(TestLabel, TestData, ModelRBF);

Acc = temp(1);
    
end