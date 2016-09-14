function y = interpnans( y, x, varargin )

% function x = interpnans( y, x, varargin )
%
% interpolate over the nans in a data vector y, who are a function of x,
% the base spacing of data y.  Varargin are any of the various additional
% arguments associated with interp1.
%
% KIM 06.11


if nargin<3
    varargin =  [];
    if nargin< 2
        x = 1:length(y ); 
    end
end

% find the nans
naner = find( ~isnan( y )); 
if length(naner) >2
    % interpolate
    y = interp1( x(naner), y(naner), x, varargin );
end
