function y = naninterp1( X, Y, x, varargin )

% function y = naninterp1( X, Y, x, varargin)
% 
% Interpolate in 1-dimension, but remove all the nans from X first.  Varargin are any of the various additional
% arguments associated with interp1.
%
% KIM 06.11

if isempty( varargin )
    varargin = {}; 
end

naner = find( ~isnan( X )); 

if length( naner ) >1
    y = interp1( X(naner), Y(naner), x, varargin{:} );
else
    y = x*nan;
end
