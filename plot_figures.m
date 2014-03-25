
%% plot acc vs. ntrees

figure;

%plot(NTreeSet,ACC,'x-');
title(sprintf('Real, Random')); 
ylabel('Accuracy ');
xlabel('# of Trees');
saveas(gcf, sprintf( './figures_mnist/acc_ntrees_random.fig'), 'fig' );


ACC_cmplx = ACC;
ACC_real = ACC;


plot(NTreeSet, ACC_cmplx,'bx-',NTreeSet, ACC_real,'mx-.','LineWidth',2);
set(gca,'FontSize',16,'fontWeight','bold');
ylabel('Accuracy ');
xlabel('# of Trees');
legend('Complex','Real','Location','SouthEast');
set(findall(gcf,'type','text'),'FontSize',16,'fontWeight','bold');

print(gcf,'-depsc',sprintf('./figures_mnist/acc_ntrees_random.eps'));

%% draw digits
%%%%
p = randperm( 256); % permutation
%%%%

load 'MNIST_X_tr_all.mat';

for iclass = 0:9
    
    x = X_tr{iclass+1};
    x = x(:, 1:2);
    
    for i = 1:size(x,2)
        figure( 100+i),
        imagesc(reshape( x(:, i), 16, 16)); colormap( gray); axis off;
        set(gca,'position',[0 0 1 1],'units','normalized');
        print(gcf,'-dpng', sprintf( 'figures_mnist/sample/digit%d_%d.png', iclass, i));
        imagesc(reshape( x(p, i), 16, 16)); colormap( gray); axis off;
        set(gca,'position',[0 0 1 1],'units','normalized');
        print(gcf,'-dpng', sprintf( 'figures_mnist/sample/digit%d_%d_perm.png', iclass, i));
        
    end

end

%% draw basis

load 'rand_tree.mat';
BinT_feat = BinT_feat{1};
Data = Data{1};

len_haar = 16;
iL = log2(len_haar) + 1;
nGrp = length( unique(BinT_feat(iL,:)) );

%%% compute the energy on each support
energy = zeros( nGrp, 1);
for i  = 1:nGrp
    jj = find( BinT_feat(iL,:) == i);
    energy(i) = norm(Data(jj, :).^2, 'fro').^2; %2-norm
end
energy = energy/sum( energy);

[~, idxi ] = sort( energy, 'descend');

for ii = 1:nGrp
    i = idxi( ii );
    
    temp = zeros(256,1);
    temp(BinT_feat(iL,:) == i) = 1;
    
    imagesc(reshape( temp, 16, 16)); colormap( gray); axis off;
    set(gca,'position',[0 0 1 1],'units','normalized');
    print(gcf,'-dpng', sprintf( 'figures_mnist/sample/basis_level%d_%d.png', iL, ii)); 
    
    imagesc(reshape( temp(p), 16, 16)); colormap( gray); axis off;
    set(gca,'position',[0 0 1 1],'units','normalized');
    print(gcf,'-dpng', sprintf( 'figures_mnist/sample/basis_level%d_%d_perm.png', iL, ii)); 

end
