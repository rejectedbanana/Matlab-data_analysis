function  [ coh, ph, S1, S2, CS, fr ] = speccoherence( x, y, sampfreq, nfft, off, demean, detrnd , taper, fig, kmin, kmax)

%    [ coh, ph, S1, S2, CS, fr ] = speccoherence( x, y, sampfreq, nfft, off, demean, detrnd ,taper, plotit, kmin, kmax)
%
% finds coherence squared between two data matrices along the first dimension
% based on script by MHA
%
% KIM 08.11

[Nx, Mx]  = size( x ); 
[Ny, My]  = size( y ); 

if Nx~=Ny
	error(  'arrays must have same dimensions.' )
end

% SET DEFAULTS
% if no sampling frequency specified, set it to 1 Hz
if nargin < 3
    sampfreq = 1/Nx;
end
% if no window length specified, make it entire vector
if nargin < 4
    nfft = Nx;
end
% do not lag the vectors with respect to one another
if nargin <5
    off = 0;
end
% demean automatically
if nargin < 6
    demean = 1; 
end
% detrend automatically
if nargin < 7
    detrnd = 1; 
end
% hanning window
if nargin < 8
    taper = 1; 
end
% no plot
if nargin < 9
    fig = 0;
end

if off<0
    si = -off; 
else 
    si = 0; 
end

% pull the vectors
sig1 = x(si+1:end-off-si, : ); 
sig2 = y( si+off+1:end-si, :);
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
    naner = find( isnan( sig2( :, c )));
    if ~isempty( naner )
        sig2( naner, c ) = nanmean( sig2( :, c ));
    end
end

% demean and detrend
if demean == 1
    sig1 = detrend( sig1, 0 );
    sig2 = detrend( sig2, 0 );
end
if detrnd ==1
    sig1 = detrend( sig1 );
    sig2 = detrend( sig2 );
end

if taper == 1
    win = hanning( nfft )/mean( hanning(nfft).^2);
else 
    win = []; 
end

% compute the auto and cospectra
for nn = 1:Mx
    [S1(:,nn),freq] = cpsd( sig1(:,nn), sig1(:,nn), win , 0 , nfft , sampfreq, 'twosided' );
    [S2(:,nn),freq] = cpsd( sig2(:,nn), sig2(:,nn), win , 0 , nfft , sampfreq, 'twosided' );
    [CS(:,nn),freq] = cpsd( sig1(:,nn), sig2(:,nn), win , 0 , nfft , sampfreq, 'twosided' );
end

% average all the columns
S1 = nanmean( S1, 2 ); 
S2 = nanmean( S2, 2 ); 
CS = nanmean( CS, 2 ); 

% shift the FFT data
S1 = fftshift( S1 ); 
S2 = fftshift( S2 ); 
CS = fftshift( CS ); 

% now to calculate the Co-and Quadspectra, coherence and phase
Kxy  = real( CS );
Qxy  = imag( CS );
% coh  = CS.*conj(CS)./(S1.*S2);
ph = atan2( imag(CS), real( CS ) ); 
% ph  = atan2( Qxy, Kxy );

%now scale the result to match the FFT method
S1 = S1*2*2^(nextpow2( nfft ))./sampfreq;
S2 = S2*2*2^(nextpow2( nfft ))./sampfreq;
CS = CS*2*2^(nextpow2( nfft ))./sampfreq;

coh =  mscohere(sig1,sig2,hanning(nfft),fix(nfft./2),nfft, 'twosided'); % NO overlap
coh = fftshift(coh); 

% % % spectra using FFT
% s1 = fft( sig1, nfft );
% s2 = fft( sig2, nfft );
% % % cross spectrum
% cs = nanmean( s1.*conj( s2 ), 2).*sampfreq/nfft;
% cs = fftshift( cs );
% %
% % % normalize and shift the spectra
% s1 = nanmean( abs(s1).^2, 2 ).*sampfreq/nfft;
% s1 = fftshift( s1 );
% s2 = nanmean( abs(s2).^2, 2 ).*sampfreq/nfft;
% s2 = fftshift( s2 );
% 
% % calculate coherence and phase
% coh = cs.*conj( cs )./(s1.*s2);
% for c = 1:My
%     coh(:,c) = mscohere(sig1(:, c),sig2(:,c), [], [],  nfft, 'twosided');
% end
% coh = nanmean( coh,2 );
% ph = atan2( imag(cs), real( cs ) );


if fig ~=0
    plot_coherence( fr( lp+2:end), S1( lp+2:end), S2( lp+2:end), CS( lp+2:end), coh( lp+2:end), ph( lp+2:end), [kmin, kmax], fig)
end
    
    




