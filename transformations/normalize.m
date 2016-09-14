function [normed] = normalize( vec )

% function  [normed] = normalize( vec )
%
%  Normalize a function by subtracting the mean and then dividing by the
%  largest value
%
% KIM 10/10

vec = vec - nanmean( vec ); 

normed = vec./nanmax( abs( vec )); 