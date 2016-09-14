function [mu, sigma, a, fit] = kgaussianfit( x, y )

% function [mu, sigma, a, fit] = kgaussianfit( x, y )
%
% Fit a gaussian curve (normalized distribution) to using least-squares
% regression of the linerized gaussian equation. 
%
% OUTPUTS: 
% mu = mean
% sigma = standard deviation
% a = peak amplitude
% fit = fit
%
% KIM 3.15

goodinds = find( ~isnan( x+y )); 
xin = x(goodinds); 
yin = y(goodinds); 


% % adjust the x vector
% A = [x.^2, x, ones(size( x ))]; 
% % log of the data
% b = log(y); 
% % now do the least squares
% z = A\b % where z = [P, Q, R]

% Use a polyfit to do the least-squares regression
z = polyfit( xin, log(yin), 2 ); 

% solve for the mean
mu = -z(2)./z(1)./2; 
% solve for the standard deviation
sigma = sqrt( -1/2/z(1)); 
% solve for the amplitude
a = exp( z(3) + mu.^2/sigma.^2/2); 

% output the fit
fit = a.*exp(-1/2*(x-mu).^2./sigma.^2); 

% figure(1); clf
% plot( x, y, '.', x, fit ); vertline( mu ); vertline( mu+sigma, 'b-'); vertline( mu-sigma, 'b-');