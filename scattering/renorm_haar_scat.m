function X = renorm_haar_scat(X, epsilon, min_order)
% ----------------------------------------------------------------------------%
% Usage
%    X = renorm_scat(X)
%
% Input
%    X: A scattering transform.
%
% Output
%    X: The scattering transform with second- and higher-order coefficients
%       divided by their parent coefficients.
%
% Description
%    This function renormalize scattering coefficients by their parents
%
% See also
%   FORMAT_HAAR_SCAT
% ----------------------------------------------------------------------------%

if nargin < 2
    epsilon = 1e-6;
end

if nargin < 3
    min_order = 2;
end


for n = 1:length(X)
    for m = length(X{n})-1:-1:min_order
        for p2 = 1:size(X{n}{m+1}.signal,1)
            
            j = X{n}{m+1}.meta.j(p2,:);
            
            p1 = find(all(bsxfun(@eq,X{n}{m}.meta.j,j(1:m-1)),1));
            
            X{n}{m+1}.signal(p2,:) = X{n}{m+1}.signal(p2,:)./(X{n}{m}.signal(p1,:)+epsilon);
        end
    end
end


end
