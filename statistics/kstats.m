function [wmean, wvar] = kstats( vecin, Win, distribution )

% function [wmean, wvar] = kstats( vecin, Win, distribution)
%
% Find stats for a data vector with either 'normal' or 'lognormal'
% distribution
%
% KIM 11.14

if nargin < 3 % define the distribution
    distribution = 'normal'; 
end

if nargin <2  % define the weighting
    Win = ones(size(vecin)); 
    Win(isnan(vecin)) = nan; 
end

switch distribution
    case 'normal'
        % number of good data points
        Min = sum(~isnan(vecin));
        % area-weighted mean
        wmean = nansum(Win.*vecin)./nansum(Win);
        % area-weighted variance
        wvar = nansum(Win.*(vecin-wmean).^2)./((Min-1)./Min.*nansum(Win));
        
    case 'lognormal' 
        % remove zeros
        vecin(vecin == 0) = nan; 
        % number of good data points
        Min = sum(~isnan(vecin ));
        % area-weighted mean of the log
        mu = nansum(Win.*log(vecin))./nansum(Win);
        % area-weighted standard deviation
        sigma = nansum(Win.*(log(vecin)-mu).^2)./((Min-1)./Min.*nansum(Win));
        % mean
        wmean = exp(mu+0.5*sigma.^2);
        % variance
        wvar = (exp(sigma.^2) - 1).*exp(2*mu+sigma.^2); 

end

