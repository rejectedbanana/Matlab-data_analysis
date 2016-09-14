function [Pys, w, r] = kwelch( S, nfft, ds )
% function [Py, w, r] = kwelch( S, nfft, ds );
%
% Find the wavenumber spectrum of a matrix S along the first dimension
% using pwelch with 50% overlapping chunks of size
% nfft. Define the sampling interval so that the frequency outputs in . Example units of ds are
% seconds between samples or meters between sample. 
%
% INPUTS
% ----------
% S = data matrix
% nfft = window size
% ds = sampling interval. default = 1.
% 
% OUTPUTS
% -------------
% Pys = power spectral density
% w = output frequency [radians/sample unit].
% r = 95% confidence intervals
%
%
%KIM 05/12

% size of input matrix
[d1, d2] = size( S ); 

% defaults
if nargin <3
    ds =  1; % 1m vertical spacing
end
if nargin <2
    nfft = d1; % window size entire length of matrix
end

% remove mean of data
S = S - repmat( nanmean( S ), [ d1, 1 ] );

% Detrend
for n = 1:d2
    S(:,n) = nandetrend( S(:,n) );
end

% denan the matrix by interpolating over gaps and filling the ends in with
% the mean
S  = denanmatrix( S );

% first make a dummy matrix to fill
Pys = nan( floor(nfft), d2 ); % complex S

% find the power spectra
for n = 1:d2
    % default 50% overlapping hamming windows
    [ Pys(:,n), w ] = pwelch( S(:,n), nfft, [], nfft, 'twosided' ); % output frequency is radians per sample
end

% for two-sided spectra, pwelch outputs w from 0 to 2*pi. Wrap from to -pi to pi
w  = wrapToPi(w); 
% w = w./2./pi; % scale out of radians

% f = (1/ds) * linspace( 0 ,1, (nfft./2) )./2; %multiply by 60*60*24 to get freq from units of cycles/sec to cycles/day
w = w./ds; % divide by ds to get radians per sample spacing
% w = w./2./pi; % get in cycles per sample spacing

% find number of independent windows in pwelch for 50% window (bottom of
% pwelch doc)
Nb = (d1 - nfft./2)./(nfft - nfft./2);
%calculate the number of degrees of freedom
%account for 50% overlap & account for hamming windowing (Percival p 292)
nu1 = ( 36*Nb*Nb ) / (19*Nb -1 );
% NOW FROM BETH:
%get confidence limits for windowing
%function lim = variancez(nu,p,scale)
p = 0.95; %confidence interval bracket
Var1 = variancez( nu1, p, '10' );
%make upper and lower CI lines
r.high = Pys * 10^Var1( 2 );
r.low = Pys * 10^Var1( 1 );

if isreal( S )
    % make the spectrum one-sided if real
    w = w( 1:floor(nfft/2)+1);
    Pys  = Pys( 1:length( w ), : );
end
