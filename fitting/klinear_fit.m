function [xsort, fit, p, CI, Rsq,Fstat, pval ] = klinear_fit(x,y, plotit)

% [xsort, fit, p, CI, Rsq,Fstat, pval ] = klinear_fit(x,y, plotit)
%
% Calculate a linear fit to data.
%
% KIM 02.14

if nargin <3
    plotit = 0; 
end

% remove all the nans
goodinds = find( ~isnan( x+y )); 
x = x(goodinds); 
y = y(goodinds); 

% first sort so that x is monotonically increasing
[xsort, inds ] = sort(x); 
ysort = y(inds); 

% use polyfit to do a fit
[p,s] = polyfit(xsort,ysort,1);
% use the integral time scale to determine the actual degrees of freedom
[tau,df] = time_scale(y,length(y)); 
s.df = df; 
% now find the confidence intervals
[fit,CI] = polyconf(p,xsort,s,'predopt','curve');

% use regress to output the statistics
[b,bint,r,rint,stats] = regress(ysort,[ones(size(xsort)), xsort]);
Rsq = stats(1); 
Fstat = stats(2); 
pval = stats(3); 

disp( ['Number of observations: ', num2str(length(x)), '; Degrees of Freedom: ', num2str(df)])
disp( ['Slope: ', num2str(p(1))])
disp( ['R-squared: ', num2str(Rsq)])
disp( ['p-value: ', num2str(pval)])

if plotit~=0
    figure(plotit)
    plot(x,fit,'color','r', 'linewidth', 2);
    line(x,fit-CI,'color','r','linestyle',':')
    line(x,fit+CI,'color','r','linestyle',':')
    
end