function [xo, yo, zo] = interpline( x, y, z, xi, yi, ls) 

% function [zi] = interpline(x,y,z,xi,yi) 
%
%  Interpolates a grid onto a line defined by the endpoints
%
% KIM 04/09

dxi = diff( xi ); 
dyi = diff( yi ); 

sl = dyi./dxi; 

b = mean( yi - sl*xi ); 

% make the x vec
xo = linspace( xi(1), xi(2), ls); 
yo = xo*sl+b; 

% now to interpolate
zo = interp2( x, y, z, xo, yo ); 








