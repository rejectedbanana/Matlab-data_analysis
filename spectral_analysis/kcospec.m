function [PSD, w, r, Var1] = kcospec( S1, S2, nfft, ds, win )
% function [PSD, w, r, Var1] = kcospec( S1, S2, nfft, ds, win );
%
% Find the Power Spectral Density (PSD) of a matrix S along the first dimension
% using non-overlapping FFTs over chunks of size nfft. 
% Define the sampling interval (ds) so that the frequency outputs in [cycles/sample unit]. Example units of ds are
% seconds between samples or meters between sample. 
%
% INPUTS
% ----------
% S1 = data matrix
% S2 = data matrix
% nfft = window size
% ds = sampling interval. default = 1.
% 
% OUTPUTS
% -------------
% PSD = Power spectral density [variable units^2/(cycles/sample unit)]
% w = output frequency [cycles/sample unit].
% r = 95% confidence intervals
%
% NOTE: To convert output frequencies to [radians/sample unit], multiply w by
% 2*pi. To convert output PSD to [variable units^2/(radians/sample
% unit)] divide PSD by 2*pi.
%
%
%KIM 05/12

% size of input matrix
[d1, d2] = size( S1 ); 
[d3, d4] = size( S2 ); 
 
if d1~=d3
	error(  'arrays must have same dimensions.' )
end

% defaults
if nargin <3
    ds =  1; % vertical spacing of 1.
end
if nargin <2
    nfft = d1; % window size entire length of matrix
end
if nargin < 3
    win = ones( nfft, 1); 
end

% remove mean of data
S1 = S1 - repmat( nanmean( S1 ), [ d1, 1 ] );
S2 = S2 - repmat( nanmean( S2 ), [ d1, 1 ] );

% Detrend
for n = 1:d2
    S1(:,n) = nandetrend( S2(:,n) );
    S1(:,n) = nandetrend( S2(:,n) );
end

% denan the matrix by interpolating over gaps and filling the ends in with
% the mean
S1  = denanmatrix( S1 );
S2  = denanmatrix( S2 );

% STOPPED EDITING HERE:


% first make a dummy matrix to fill
PSD = nan( fix(nfft), d2 ); % complex S

% compute the power spectra
for n = 1:d2
    Ys = fft( S(:, n) , nfft ).';
    PSD(:,n) = Ys .*conj( Ys ) /(nfft)./ds; % scale by chunk length and sampling frequency
end

% output the frequency in cycles per sample unit
w = (1/ds) * linspace( 0, 1, nfft./2+1 )./2; 
%         [0 k -N/2 -fliplr(k)]
% w = (1/ds).*[0:fix(nfft/2)]./nfft/2; 

% if the spectrum is real, it is one-sided. 
if isreal( S )
    w = w(1:nfft/2+1); % only take first half of frequency spectra
    PSD  = 2*PSD( 1:nfft/2+1, : ); % fold two-sided into one-sided spectra by multipling PSD by 2
else
    % if two sided, shift fft
    PSD = fftshift( PSD, 1 );
    % output frequency
    if rem( nfft, 2 ) % odd
        w = [-fliplr(w(2:end)), w]; % both sides of fft contain nyquist frequency
    else % even
        w = [-fliplr(w(2:end)), w(1:end-1)]; % nyquist frequency only at w(1) or - nyquist frequency
    end
end

nu1 = 2*fix(d1./nfft); % find degrees of freedom
p = 0.95; %confidence interval bracket
Var1 = variancez( nu1, p, '10' );
%make upper and lower CI lines
r.high = nanmean(PSD, 2)*10^Var1( 2 );
r.low = nanmean(PSD, 2)*10^Var1( 1 );

% % find number of independent windows in pwelch for 50% window (bottom of
% % pwelch doc)
% Nb = (d1 - nfft./2)./(nfft - nfft./2);
% %calculate the number of degrees of freedom
% %account for 50% overlap & account for hamming windowing (Percival p 292)
% nu1 = ( 36*Nb*Nb ) / (19*Nb -1 );
% % NOW FROM BETH:
% %get confidence limits for windowing
% %function lim = variancez(nu,p,scale)
% p = 0.95; %confidence interval bracket
% Var1 = variancez( nu1, p, '10' );
% %make upper and lower CI lines
% r.high = PSD * 10^Var1( 2 );
% r.low = PSD * 10^Var1( 1 );

