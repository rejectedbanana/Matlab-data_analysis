function lim = variancez(nu,p,scale)
% function to determine the confidence intervals (variance) for a
% spectral density function.  This assumes a chi-square distribution
% with nu degrees of freedom, and utilizes the matlab function gaminv.
%
%  lim = variancez(nu,p,scale)
%
%	nu - the degrees or equivalent degrees of freedom for the spectral
%		estimate under consideration (no limitations, unless gaminv
%		has limitations on A)
%	p - sets the confidence interval to compute as p*100%,
%		e.g. 0.95 for 95% intervals
%		(only 0.005, 0.025 and 0.05 will work)
%	scale - a text string to indicate what kind of log-scale
%		'e' - log base e
%		'10' - log base 10 (default)
%		'db' - decibel
%	lim - the upper and lower limits (which order are they?) given
%		by equation 258, with the base level removed (lambda*log(S))
%

if ~any(nargin==[2 3])
	error('incorrect number of inputs')
end


if ~exist('scale')
	lambda=log10(exp(1));
elseif strcmp(scale,'e')
	lambda=1;
elseif strcmp(scale,'10')
	lambda=log10(exp(1));
elseif strcmp(scale,'db')
	lambda=10*log10(exp(1));
else
	error(['the value ''' scale ''' is not defined for scale'])
end

Qv=gaminv( (1-p)/2*[1 -1]+[0 1] ,nu/2,2);

lim=lambda*[ log(nu/Qv(2)) log(nu/Qv(1)) ];
lim=[min(lim) max(lim)];
