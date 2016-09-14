function [r, Pn] = kcorr( X, Y ); 

% function [r, Pn] = kcorr( X, Y ); 
%
%  Kim's correlation function.  The linear correlation coefficient finds
% the extent to which N points from functions X and Y fit a straight line.
%
% Also calculates the probability (Pn) that two uncorrelated variables would give
% a coefficient as large as r as large as ro with N measurements
% if Pn < 0.05 = 5%, the correlation is significant
% if Pn < 0.01 = 1%, the correlation is highly significant
%
% Adapted from 'An Introduction to error
%  analysis' by John R. Taylor (1982)
%
% KIM 10.10

% remove the nans 
xnan = find( ~isnan( X )); 
ynan = find( ~isnan( Y )); 
naner = intersect( xnan, ynan ); 
X = X( naner ); 
Y = Y( naner ); 

sigXY = nansum( (X - nanmean( X )).*( Y - nanmean( Y ) ) ); 

sigX = nansum( (X - nanmean( X )).^2); 

sigY = nansum( ( Y - nanmean( Y )).^2 ); 

r = sigXY./sqrt(sigX.*sigY); 

% now calculate the probability (Pn)
N = length( X);
rin = linspace( abs(r), 1, 101); 
Pn = 2*gamma( 0.5.*(N-1) )./sqrt(pi )./gamma(0.5.*(N-2)).*trapz( rin, (1-rin.^2).^(0.5.*(N-4))); 




