function [I, J] = match_i2d(x, y, xi, yi )

% function [I, J] = match_i2d(X, Y, xi, yi )
%
% If you have 2-dimenstional X and Y coordinate grids, find the point
% closest to coordinate [xi, yi]. X and Y must be the same size.
%
% KIM 12.13
 
[d1, d2] = size( x ); 

% the calculations
x = reshape( x, [numel(x), 1]); 
y = reshape( y, [numel(y), 1]); 
DT =  delaunayTriangulation(x,y);
xi = nearestNeighbor(DT, xi, yi);
% pull the indices
[I, J] = ind2sub([d1, d2], xi); 
