function out = subsample(im)

% im must be a 32x32 array

%out = im(2:31,2:31) ;
%out = (out(1:3:end,:)+out(2:3:end,:)+out(3:3:end,:))/3 ;
%out = (out(:,1:3:end)+out(:,2:3:end)+out(:,3:3:end))/3 ;

out = im ;
out = (out(1:2:end,:)+out(2:2:end,:))/2 ;
out = (out(:,1:2:end)+out(:,2:2:end))/2 ;

out = out' ;