function display_haar(len_haar, BinT_feat, Data, SaveFig)

% ----------------------------------------------------------------------------%
% Display the positions of the support of Haar wavelet at a certain support
% size, based on a known binary feature tree. Save the figures.
%
% Input:
%   len_haar - size of support of haar basis, to specify the tree level
%   BinT_feat - A binary feature tree. First row correponds to the smallest scale.
%   SaveFig - save figures if SaveFig == 1
% 
% ----------------------------------------------------------------------------%

%%% in case of thresholded tree
idx_short = find(sum(BinT_feat,1) > 0);
BinT_feat = BinT_feat(:,idx_short);
Data = Data(idx_short,:);
%%%

iL = log2(len_haar) + 1;
nGrp = length( unique(BinT_feat(iL,:)) );

ncols = 2^floor( log2(sqrt(nGrp)) );
nrows = nGrp/ncols;

%%% compute the energy on each support
energy = zeros( nGrp, 1);
for i  = 1:nGrp
    jj = find( BinT_feat(iL,:) == i);
    energy(i) = norm(Data(jj, :).^2, 'fro').^2; %2-norm
end
energy = energy/sum( energy);

[~, idxi ] = sort( energy, 'descend');

%%% plot the haar basis
figure(2); clf; hold on;
for ii = 1:nGrp
    i = idxi( ii );
    
    temp = zeros(256,1);
    temp(idx_short(BinT_feat(iL,:) == i)) = 1;
    
    subplot( nrows, ncols, ii);
    imagesc(reshape(temp,16,16));
    colormap('gray');
    
    title(sprintf('%f', energy( i)));    
end
if SaveFig
    saveas(gcf, sprintf( './figure_mnist/haar%d.fig', len_haar), 'fig' );
end

figure(3), clf;
plot( log ( max( energy(idxi) , 1e-16) ), 'x-' );
%title(sprintf('digit %d, log energy', digit(1)));
ylabel('|| x|_{supp} ||^2 ');
xlabel('index of support of Haar basis');
if SaveFig
    saveas(gcf, sprintf( './figure_mnist/haar%d_energy.fig', len_haar), 'fig' );
end




end