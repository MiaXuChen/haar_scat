% Retrieve data from MNIST 

Ltest = 1000 ; % Number of training samples in each class
Ltrain = 6000 ; % Number of test samples in each class


[train,test] = retrieve_mnist_data(Ltrain,Ltest) ;


train = cellfun(@(r)(cellfun(@subsample,r, ...
    'UniformOutput',0)), ...
    train,'UniformOutput',0) ;
test = cellfun(@(r)(cellfun(@subsample,r, ...
    'UniformOutput',0)), ...
    test,'UniformOutput',0) ;


NClass = 10;

X_te = cell(NClass,1);
X_tr = cell(NClass,1);
for iclass = 1:NClass
    X_tr{iclass} = zeros(256,length(train{iclass}));
    X_te{iclass} = zeros(256,length(test{iclass}));
    for i = 1:length(train{iclass})
        X_tr{iclass}(:,i) = train{iclass}{i}(:);
    end
    for i = 1:length(test{iclass})
        X_te{iclass}(:,i) = test{iclass}{i}(:);
    end
    
end

save('MNIST_X_tr_all.mat','X_tr');
save('MNIST_X_te_all.mat','X_te');

               
               