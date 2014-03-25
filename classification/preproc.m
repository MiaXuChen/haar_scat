function [moys,t2] = preproc(t1)

epsilon = 1e-5;
moys = mean(t1) ;
t2 = t1-repmat(moys,[size(t1,1),1]) ;
t2 = t2*diag((sum(abs(t2).^2,1)+epsilon).^(-1/2)) ;