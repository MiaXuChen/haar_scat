function [esp,P] = create_classif2(X,max_dim)

nb_cl = max(size(X)) ;
for s=1:nb_cl
    esp{s} = mean(X{s},2) ;
    X_centered = bsxfun(@minus,X{s},esp{s}) ;
    Xcov = X_centered*X_centered'/size(X{s},2) ;
    [U,D] = eig(Xcov) ;
    [max_D,ind_D] = sort(diag(D),'descend') ;
    max_D = max_D(1:max_dim) ;
    ind_D = ind_D(1:max_dim) ;
    U(:,ind_D) = [] ;
    P{s} = U' ;
end