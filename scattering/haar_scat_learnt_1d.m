function [Scat_Tr Scat_Te] = haar_scat_learnt_1d( TrainData, TestData, TrainLabel, NTree, options )
% ----------------------------------------------------------------------------%
% Usage
%    [Scat_Tr Scat_Te] = HAAR_SCAT_LEARNT_1D( TrainData, TestData, TrainLabel, NTree, options )
%
% Input
%    TrainData, TestData (numeric): The input training and testing signal matrices.
%    TrainLabel (int): The input training label.
%    NTree (int): The number of trees that need to be learnt.
%    options (struct): The scattering options.
%       'M' (int): The scattering order.
%       'J' (int): The largest scale of Haar wavelet.
%       'mode' (string): 'real' or 'complex'.
%
%
% Output
%    Scat_Tr, Scat_Te (numeric): The scattering representation of TrainData, TestData. 
%
% Description
%    This function computes the learnt Haar scattering coefficients in 1D. 
%
% See also
%   HAAR_SCAT_1D, HAAR_SCAT_2D, HAAR_SCAT_LEARNT_2D
% ----------------------------------------------------------------------------%

%% Divide training data for learning multiple trees

Data = cell(NTree,1);

%manner_divide = 'digit_wise';
manner_divide = 'random';

switch manner_divide
    
    case 'digit_wise'
        
        for iclass = 1 :NClass
            ClassData = TrainData(:,TrainLabel == iclass);
            idx_pt = randperm(sum(TrainLabel == iclass));
            NPtree = floor(length(TrainLabel)/NTree); 
            for itree = 1:NTree/NClass
                Data{(iclass-1)*NTree/NClass+itree} = ClassData(:,idx_pt((itree-1)*NPtree+1:itree*NPtree));
            end
        end

    case 'random'
        
        idx_pt = randperm(length(TrainLabel));
        NPtree = floor(length(TrainLabel)/NTree);
        for itree = 1:NTree
            Data{itree} = TrainData(:,idx_pt((itree-1)*NPtree+1:itree*NPtree));
        end
   
end

%% Build multipe binary trees BinT_feat on features

BinT_feat = cell(NTree,1);
idx_order_feat = cell(NTree,1);

for itree = 1:NTree
    [BinT_feat{itree} idx_order_feat{itree}] = get_bint_feat(Data{itree});
end

%% Get scattering coefficients based on multiple feature binary tree BinT_feat

Scat_Tr = [];
Scat_Te = [];

for itree = 1:NTree
    
    temp_tr = haar_scat_1d( TrainData(idx_order_feat{itree},:), options );
    temp_tr = format_haar_scat(renorm_haar_scat(temp_tr));
    Scat_Tr = [Scat_Tr; temp_tr.signal];
    
    temp_te = haar_scat_1d( TestData(idx_order_feat{itree},:), options );
    temp_te = format_haar_scat(renorm_haar_scat(temp_te));
    Scat_Te = [Scat_Te; temp_te.signal];
    
end



end
