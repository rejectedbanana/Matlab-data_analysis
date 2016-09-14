function [u, v] = rotate_vel( u, v, ph)

% function [u, v] = rotate_vel( u, v, ph)
%
% Negative ph rotates velocity vectors CW.  
% Positive ph rotates velocity vectors CCW.
% Phase is in degrees
%
% KIM 10/10

w=u+1i*v;
w=w*exp(1i*ph/180*pi);
u=real(w);
v=imag(w);