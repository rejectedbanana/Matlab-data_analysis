function [ind] = match_i( vec, value, firstlast )

% function  [ind] = match_i( vec, value, firstlast);
%
%  Find the closest indice for the value in the vector.
%
% KIM 11.2007
if nargin <3
    firstlast = 'first';
end

ind = find( abs( vec - value) == nanmin( abs( vec - value )  ) );

if strcmp( firstlast, 'first')
    ind = ind( 1 );
elseif strcmp( firstlast, 'last')
    ind = ind( end );
end


