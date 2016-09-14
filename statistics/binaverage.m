function [binned] = binaverage(press,series,pbin,bintype, slowflag)

%[binned] = binaverage(press,series,pbin,bintype,slowflag)
% BINAVERAGE2 - bins a data SERIES onto a specified pressure grid
%
% Interpolate press onto fine grid, and data onto press
% bin [m] resolution, e.g. 0.25 m resolution
% 
% INPUTS
%     SERIES [Nx1] data series, any units
%     PRESS  [Nx1] pressure (db) original
%     PBIN   [Mx1] pressure grid (db)
%     BINTYPE  user input, 'centered' for centered on pbin, 'edges' for bin
%     on edged
%     SLOWFLAG [Nx1] boolean, 1 for flagged
%     You can also denan by setting SLOWFLAG = isnan( SERIES )
%
% MODIFIED 4/06 KIM
% MODIFIED 05/06 KIM, Took the loop out
% MODIFIED 03/2013 Switched inputs to make it like interp


if (nargin<5)
    slowflag = 0*series;
end

if nargin <4
    bintype = 'centered'; 
end

% remove nans
good_inds = find( ~isnan(press+series)); 
press = press(good_inds);
series = series(good_inds);
slowflag = slowflag(good_inds);

% Omit flagged values
pressN = press(find(1-slowflag));
seriesN = series(find(1-slowflag));

% % Find the upper and lower bin limits
% bin = nanmean(diff(pbin));
% plow = pbin'-(0.5*bin);

if strcmp(bintype, 'centered')
    % Find the upper and lower bin limits
    bin = diff(pbin);
    plow = pbin(1:end-1)+(0.5*bin);
    plow = [pbin(1) - 0.5*bin(1); plow;  pbin(end)+0.5*bin(end)];
    %  plow(end+1) = plow(end)+bin;
else
    plow = [pbin; pbin(end)+diff(pbin(end-1:end))]; 
end

% Faster and newer script. Use histc to do binning
[N, bins]=histc(pressN, plow);
binzero=find(bins==0);
if ~isempty( binzero )
    bins( binzero ) = length( N );
end
binsum=accumarray(bins, seriesN, [length(plow),1]);
binned=binsum./N;
%remove the end point as it is not a true bin
binned=binned(1:end-1);