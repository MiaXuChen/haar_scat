function [BinT_feat idx_order_feat] = get_bint_feat_cmplx(Data)

% ----------------------------------------------------------------------------%
% Get binary feature tree from complex Haar scattering
%
% Input:
%   Data - Each col is a data sample.
% Output:
%   BinT_feat - Binary feature tree, learnt from pairing features;
%               First row correponds to the smallest scale.
%   Data_feat - Scattering coefficients after transforming Data, each col
%               corresponds to a data sample.
%   cmpt_real - A cell array indicating whether to perform real or complex Haar
%   idx_order_feat - The ordering indices of data according to BinT_feat.
% ----------------------------------------------------------------------------%


[Q,T] = size(Data);
nLevel = log2(Q)+1;

BinT_feat = zeros(nLevel, Q);
coef_all = cell(nLevel,1); % store scat coefs at each level of the tree
cmpt_real = cell(nLevel,1); % indicate whether to perform real or complex Haar
map2prev = cell(nLevel,1); % indicate the index of previous coefficient used

x = Data;
Qold = Q;

Hmat2 = haarmtx(2);
BinT_feat(1,:) = 1:Q;

% Initiation
coef_all{1} = cell(Q,1);
for igrp = 1:Q
    coef_all{1}{igrp} = x(igrp,:);
end
cmpt_real{1} = 1; % 1 : to perform real wavelet
map2prev{1} = 0;

% For each layer
for iL = 2:nLevel
    
    % Computing distance between groups
    d = zeros(Q , Q);
    for i =1 :Q
        for j= i+1:Q
            Gi = coef_all{iL-1}{i};
            Gj = coef_all{iL-1}{j};
            Gdiff = Gi-Gj;
            d(i,j) = sum(sqrt(sum(abs(Gdiff).^2,1)));
            %d(i,j) = sum(sum(abs(Gdiff)));
        end
    end
    maxd = max(max(d));
    C = maxd + 1;
    W = C - d;
    
    % Pairing
    disp('computing matching...'); tic,
    mate = max_wmatch_v2( W );
    t = toc;
    disp(sprintf('... done. time = %f.', t));
    
    mate = [(1:Q)' mate];
    mate = sort(mate,2,'ascend');
    mate = unique(mate,'rows');
    
    % Filling in current level of BinT_feat tree
    for ipair = 1:size(mate,1)
        temp = BinT_feat(iL-1,:);
        BinT_feat(iL, temp == mate(ipair,1)) = ipair;
        BinT_feat(iL, temp == mate(ipair,2)) = ipair;
    end
    
    % Extract coefficients for the current level of coef_all tree
    
    coef_all{iL} = cell(Q/2,1);
    for ipair = 1:size(mate,1)
        
        
        coef_all{iL}{ipair} = ...
            zeros(2*sum(cmpt_real{iL-1})+sum(cmpt_real{iL-1}==0), T);
        
        icoef = 1;
        for icoef_prev = 1:length(cmpt_real{iL-1})
            
            switch cmpt_real{iL-1}(icoef_prev)
                case 1
                    coef_all{iL}{ipair}([icoef,icoef+1],:) = ...
                        abs(Hmat2 * [coef_all{iL-1}{mate(ipair,1)}(icoef_prev,:);...
                        coef_all{iL-1}{mate(ipair,2)}(icoef_prev,:)]);
                    icoef = icoef + 2;
                case 0
                    coef_all{iL}{ipair}(icoef,:) = ...
                        sqrt(coef_all{iL-1}{mate(ipair,1)}(icoef_prev,:).^2 + ...
                        coef_all{iL-1}{mate(ipair,2)}(icoef_prev,:).^2);
                    icoef = icoef + 1;
            end
            
        end        
    end
    
    % Filling in current level of map2prev
    
    map2prev{iL} = zeros(size(coef_all{iL}{1},1),1);
    
    icoef = 1;
    for icoef_prev = 1:length(cmpt_real{iL-1})
        
        switch cmpt_real{iL-1}(icoef_prev)
            case 1
                map2prev{iL}([icoef,icoef+1],:) = icoef_prev;
                icoef = icoef + 2;
            case 0
                map2prev{iL}(icoef,:) = icoef_prev;
                icoef = icoef + 1;
        end
        
    end
    
    % Filling in current level of cmpt_real
    
    cmpt_real{iL} = ones(size(coef_all{iL}{1},1),1);
    for icoef = 1:length(cmpt_real{iL})
        if icoef > 1 && map2prev{iL}(icoef) == map2prev{iL}(icoef-1)
            cmpt_real{iL}(icoef) = 0;
        end
    end    
    
    % Prepare parameters for next level
    
    Q = Q/2;
    
end

% Output data features

Data_feat = coef_all{nLevel}{1};

% Order features according to BinT_feat

BinT_feat = flipud(BinT_feat); %%%

nodes = genNodes(BinT_feat);

[x1,y1] = treelayout(nodes);   
x1 = x1';   
y1 = y1';   
Q = size(BinT_feat,2);

[tempx idx_order_feat] = sort(x1(end-Q+1:end,1),'ascend');

BinT_feat = flipud(BinT_feat); %%%

end