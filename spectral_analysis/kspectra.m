function  [ S1, fr ] = kspectra( x, sampfreq, nfft, demean, detrnd , taper, fig, kmin, kmax)

%   [ S1, fr ] = kspectra( x, sampfreq, nfft, demean, detrnd , taper, fig, kmin, kmax)
%
% finds the spectra along the first dimension
%
% KIM 08.11

[Nx, Mx]  = size( x ); 

% SET DEFAULTS
% if no sampling frequency specified, set it to 1 Hz
if nargin < 3
    sampfreq = 1/Nx;
end
% if no window length specified, make it entire vector
if nargin < 4
    nfft = Nx;
end
% demean automatically
if nargin < 5
    demean = 1; 
end
% detrend automatically
if nargin < 6
    detrnd = 1; 
end
% hanning window
if nargin < 7
    taper = 1; 
end
% no plot
if nargin < 8
    fig = 0;
end


% pull the vector
sig1 = x; 
N = size( sig1, 1 ); 

% define the wavenumber/frequency
fr = (1:nfft/2)/nfft*sampfreq; 
lp = fix( nfft/2 ); 

if rem(nfft,2) == 0
    fr = [fliplr( -fr ), 0, fr(1:end-1) ]';
else
    fr =[fliplr(-fr) 0 fr]';
end

% set the frequency limits
if ~exist('kmin', 'var')
kmin = fr( lp+2); 
end
if ~exist( 'kmax', 'var')
    kmax =fr(end);
end

% find nans and replace with the mean in each column
for c = 1:Mx
    naner = find( isnan( sig1( :, c ))); 
    if ~isempty( naner )
        sig1( naner, c ) = nanmean( sig1( :, c )); 
    end
end

% demean and detrend
if demean == 1
    sig1 = detrend( sig1, 0 );
end
if detrnd ==1
    sig1 = detrend( sig1);
end

if taper ==1
    win = hanning( nfft )/mean( hanning(nfft).^2);
end

% compute the auto and cospectra
for nn = 1:Mx
    [S1(:,nn),freq] = cpsd( sig1(:,nn), sig1(:,nn), win , 0 , nfft , sampfreq, 'twosided' );
end

% average all the columns
S1 = nanmean( S1, 2 ); 

% shift the FFT data
S1 = fftshift( S1 ); 


%now scale the result to match the FFT method
S1 = S1*2*2^(nextpow2( nfft ))./sampfreq;


% if fig ~=0
%     plot_coherence( fr( lp+2:end), S1( lp+2:end), S2( lp+2:end), CS( lp+2:end), coh( lp+2:end), ph( lp+2:end), [kmin, kmax], fig)
% end
    
    




