function [PredictLabel Acc opt_C] = SVMC_Linear(TrainData, TrainLabel, TestData, TestLabel)

% ----------------------------------------------------------------------------%
% SVMC_Linear.m: Multi-class linear kernel SVM including parameter selection by
% cross validation.
% Mia Xu Chen, updated on Dec 10, 2013
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
% opt_C        - Optimal value of parameter C out of cross validation
% ----------------------------------------------------------------------------%

% Parameter selection by cross-validation based on grid search

C = 2.^(-1:2:15)';
numcv = 5; % # of cross validation folds

cvAcc = zeros(1,length(C));

for iC = 1:length(C)
    svm_opt = sprintf('-t 0 -h 0 -v %d -c %11.5f', numcv, C(iC));
    cvAcc(iC) = svmtrain(TrainLabel, TrainData, svm_opt);
end

[tempval idx_C] = max(cvAcc);

opt_C = C(idx_C);

% SVM

svm_opt = sprintf('-t 0 -h 0 -c %11.5f', opt_C);
        
ModelLinear = svmtrain(TrainLabel, TrainData, svm_opt); 

[PredictLabel, temp, dec_values] = svmpredict(TestLabel, TestData, ModelLinear);

Acc = temp(1);
    
end