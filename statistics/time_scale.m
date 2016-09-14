% function [tau,df] = time_scale(xx,reclength)
%
% computes the autocovariance of xx
% then computes the no. of degrees of freedom in xx
% reclength is N*delta(t) = the length of the record, needed to compute the
% degrees of freedom
function [tau,df] = time_scale(xx,reclength)
% compute autocovariance
mlag=round(length(xx)/2);
rho=xcov(xx,mlag,'biased');
% keep only one side of the symmetric autocovariance
corr=rho(mlag+1:2*mlag+1)/max(rho);
lags=0:mlag;

% integral time scale (approximate)
% integrate only while positive
% USE TRAPEZOID RULE
tau=0.;
i=1;
   while corr(i)>=0
   tau=tau+(corr(i)+corr(i+1))/2;
   i=i+1;
   end

% find degrees of freedom
df=floor(reclength/tau);