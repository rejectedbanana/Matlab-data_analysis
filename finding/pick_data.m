function [flag] =  pick_data( data, flag, h )

% function [flag] = pick_data( data, flag, h )
%
% using a graphical interface, pick and flag the data. h is the current
% axes handle.
%
% KIM 04.2012
if nargin <3
    h = gca; 
end

axes(h)

%pick start of bad data
[pickx, picky] = ginput(1);
% translate value to an indice
f1 = floor( pickx ); 
plot( f1, data(f1), 'rx', 'markersize', 8, 'linewidth',2)

% pick end of bad data
[pickx, picky] = ginput(1); 

% translate value to an indice
f2 = floor( pickx ); 
plot( f2, data(f2),'rx', 'markersize', 8, 'linewidth',2)

% sort f1 and f2 to find the inds
inds  = sort( [f1, f2] ); 
inds = inds(1):inds(2); 

% set values in flag to 1
flag( inds ) = 1; 

% highligh flagged data in red
plot( inds, data( inds), 'r.-')


