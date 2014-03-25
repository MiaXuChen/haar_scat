function S = haar_scat_1d( x, options )
% ----------------------------------------------------------------------------%
% Usage
%    S = HAAR_SCAT_1D( x, options )
%
% Input
%    x (numeric): The input signal.
%    options (struct): The scattering options.
%       'M' (int): The scattering order.
%       'J' (int): The largest scale of Haar wavelet.
%       'mode' (string): 'real' or 'complex'.
%
% Output
%    S (cell): The scattering representation of x. 
%       Each cell corresponds to a scattering order, and is a struct with 
%       two fields.
%       'signal' (numeric): The matrix whose rows correspond to paths, and 
%           whose columns correspond to rasters. 
%       'meta' (struct): Relative information on signals. 
%           'j' (int): The scale(s) information w.r.t. the paths.
%
% Description
%    This function computes the Haar scattering coefficients in 1D. 
%
% See also
%   HAAR_SCAT_LEARNT_1D, HAAR_SCAT_2D, HAAR_SCAT_LEARNT_2D
% ----------------------------------------------------------------------------%





end
