function y = haar_conv_1d(x, filter, ds)

% ----------------------------------------------------------------------------%
% Usage
%    y = HAAR_CONV_1D(x, filter, ds)
%
% Input
%    x : The signal to be convolved.
%    filter : 'h' = (1,1)/sqrt(2) or 'g' = (1, -1)/sqrt(2).
%    ds : The downsampling factor, 1 or 2.
%
% Output
%    y : The filtered, downsampled signal, in the time domain.
%
% Description
%    This function is at the foundation of the Haar scattering transform 
%    in 1D. It performs a convolution of a signal and a filter in the 
%    time domain.
%    
%    Multiple signals can be convolved in parallel by specifying them as 
%    different columns of x.
%
% See also
%   HAAR_CONV_2D
% ----------------------------------------------------------------------------%


N = size(x,1);

switch filter
    case 'h'
        y = x(1:ds:N-1,:) + x(2:ds:N,:);
        if mod(N,2) % symmetric boundary condition
            y = [y; 2*x(N,:)];
        end
    case 'g'
        y = x(2:ds:N,:) - x(1:ds:N-1,:);
        if mod(N,2) % symmetric boundary condition
            y = [y; zeros(1,size(x,2))];
        end
end

y = y/sqrt(2);

end