function [BinT_feat idx_order_feat] = get_bint_feat(Data)

% ----------------------------------------------------------------------------%
% Get binary feature tree from Haar scattering
%
% Input:
%   Data - Each col is a data sample.
% Output:
%   BinT_feat - Binary feature tree, learnt from pairing features;
%               First row correponds to the smallest scale.
%   Data_feat - Scattering coefficients after transforming Data, each col
%               corresponds to a data sample.
%   idx_order_feat - The ordering indices of data according to BinT_feat.
% ----------------------------------------------------------------------------%


[Q,T] = size(Data);
nLevel = log2(Q)+1;

BinT_feat = zeros(nLevel, Q);

x = Data;
Qold = Q;

Hmat2 = haarmtx(2);
BinT_feat(1,:) = 1:Q;
for iL = 2:nLevel
    
    % Computing distance between groups
    d = zeros(Q , Q);
    for i =1 :Q
        for j= i+1:Q
            Gi = x(BinT_feat(iL-1,:) == i,:);
            Gj = x(BinT_feat(iL-1,:) == j,:);
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
    
    % Filling in current level of tree
    for ipair = 1:size(mate,1)
        temp = BinT_feat(iL-1,:);
        BinT_feat(iL, temp == mate(ipair,1)) = ipair;
        BinT_feat(iL, temp == mate(ipair,2)) = ipair;
    end
    
    % Preparing data for next level
    
    tempmat = zeros(size(x));
    for ipair = 1:size(mate,1)
        idc_1 = find(BinT_feat(iL-1,:) == mate(ipair,1));
        idc_2 = find(BinT_feat(iL-1,:) == mate(ipair,2));
        for irow = 1:length(idc_1)
            tempmat([idc_1(irow);idc_2(irow)],:) = ...
                abs(Hmat2 * x([idc_1(irow);idc_2(irow)],:));
        end
    end
    x = tempmat;
    Q = Q/2;
    
    
end

% Order features according to BinT_feat

BinT_feat = flipud(BinT_feat); %%%

nodes = genNodes(BinT_feat);

[x1,y1] = treelayout(nodes);   
x1 = x1';   
y1 = y1';   
Q = size(BinT_feat,2);

[tempx idx_order_feat] = sort(x1(end-Q+1:end,1),'ascend');

Data_feat = x(idx_order_feat,:);

BinT_feat = flipud(BinT_feat); %%%

end