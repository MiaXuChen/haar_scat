function res = apply_classif2(X,esp,P)

nb_cl = max(size(X)) ;
for s=1:nb_cl
    for t=1:nb_cl
        coords = P{t}*bsxfun(@minus,X{s},esp{t}) ;
        probas(t,:) = sum(abs(coords).^2,1) ;
    end
    [oub,r] = min(probas,[],1) ;
    res(s,:) = r ;
   
end