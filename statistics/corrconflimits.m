function [rlo,rup,pval] = corrconflimits(rin,dof,p)
% CORRCONFLIMITS is a function that calculates confidence
% limit for correlations using the Fischer z-transform (from
% Objective Analysis notes, D. Hartmann).
%
% [rlo,rup,pval] = corrconflimits(rin,dof,p)
%
%   rin - the correlation (not r^2) input, can be any size
%   dof - the number of degrees of freedom
%   p - the desired confidence limit (0.95 is default), treated as
%     two-tailed
%
%   rlo - the lower limits
%   rup - the upper limits
%   pval - equivalent p-values for rin, given dof.  this performs a
%     one-sided test away from zero.
%
%
%  Unlike the confidence limits obtainable from CORRCOEF.m, this
%  function allows the degrees of freedom to be calculated
%  externally.  (CORRCOEF simply uses the length of the vectors,
%  which is not appropriate when the time-series are red and thus
%  have many fewer degrees of freedom than implied by their length.)
%
  
% ZB Szuts 16 Feb 2010
% ZB Szuts 1 May 2013, updated with pval
  
if ~any(nargin==[2 3])
  error('2 or 3 input arguments are required')
end
if ~exist('p','var') || isempty(p)
  p = 0.95; % use the default value
end

% perform a Fischer z-transform, to make the correlations normally
% distributed
j1 = find(rin==1); % avoid a divide by zero error
j2 = find(rin==-1);
Zin = repmat(nan,size(rin));
i = setxor(1:prod(size(rin)),[j1 j2]);
Zin(i) = 0.5*log((1+rin(i))./(1-rin(i)));
Zin(j1) = inf;
Zin(j2) = -inf;


% calculate the standard deviation of the z-transform
sigmaZ = 1./sqrt(dof-3);

% determine the desired confidence limit
if p==0.95
  sf = 1.96;
else
  % treat the Z-transform to a two-tailed test
  sf = tinv((1-p)/2+p,dof);
end

% calculate upper and lower limits on Z
Zlo = Zin - sf*sigmaZ;
Zup = Zin + sf*sigmaZ;
  
% inverse transform
rlo = (exp(2*Zlo)-1)./(exp(2*Zlo)+1);
rup = (exp(2*Zup)-1)./(exp(2*Zup)+1);


% calculate the integrated probability density function of the null
% hypothesis (r=0) for the given values of the z-transform
junk(:,:,1) = tcdf(Zin/sigmaZ,dof);
junk(:,:,2) = 1 - tcdf(Zin/sigmaZ,dof);
pval = min(junk,[],3);