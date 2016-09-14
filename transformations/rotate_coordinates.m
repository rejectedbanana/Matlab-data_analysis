function [u, v] = rotate_coordinates( u, v, ph)

% function [u, v] = rotate_coordinates( u, v, ph)
%
% Positive ph rotates cartesian plane CW.
% Negative ph rotates cartesian plane CCW.  
% Phase is in degrees
%
% KIM 4.2016

w=u+1i*v;
w=w*exp(-1i*ph*pi./180);
u=real(w);
v=imag(w);