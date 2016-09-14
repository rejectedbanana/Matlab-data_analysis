function S = interp_gaps( S )

% function S = interp_gaps( S )
%
%  Interpolate along the second dimension.  Transpose if you want the first
%  dimension.
%
% KIM 01/11


[n1, n2]  = size( S );

for n =1:n1; 
    naner = find( ~isnan( S( n,: ) ) ); 
    if length( naner ) > length( S( n,: ) )*0.1
    S( n, : ) = interp1( naner, S(n,naner ), 1:n2 ); 
    else
        S(n,: ) = nan; 
    end
end

