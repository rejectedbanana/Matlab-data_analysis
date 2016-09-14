function [x] = bandpass( x, wh, t )

% function [x] = bandpass( x, [low, hi], t )
% 
%  Bandpass the data x along each column x the frequency range wh where wh = [lo, hi];  
% using a 1st order butterworth filter
%
% KIM 09.11

if nargin < 3
    t = 1:size( x ,1 );
end

% find the change in time
dt = nanmean( diff(t) );

% design high pass filter
[b, a] = butter(1, 2*dt.*wh(1), 'high' );
% highpass filter
x = filtfilt( b, a, x);

% design the low pass filter
[b, a] = butter(1, 2*dt.*wh(2), 'low' );
% lowpass filter
x = filtfilt( b, a, x );