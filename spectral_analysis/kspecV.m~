function [Pys, f, r] = kspecV( S, nfft, dz, plotit, clr )
% function [Py, f, r] = kspecV( S, nfft, dz, plotit, clr );
%
% Find the vertical wavenumber spectrum of a vector S using fft with overlapping chunks of size
% nfft. If defining the sampling interval with dz, make sure the units
% are meters. Output frequency, f, is in radians/m.
%
% plotit: Plot the 
% clr: plot color
% The fft is done down the first dimension
%
% ADDED ABILITY TO DO 2-D Matrices 
%KIM 04/08

% defaults
    if nargin< 5
        clr = 'b';
        if nargin< 4
            plotit = 0; % default is not to plot
            if nargin <3
                dz =  1; % 1m vertical spacing
            end
        end
    end

%number of values
[d1, d2] = size( S ); 

% remove mean of data
S = S - repmat( nanmean( S ), [ d1, 1 ] );

% Detrend
for n = 1:d2
    S(:,n) = nandetrend( S(:,n) );
end

% find the power spectra
for n = 1:d2
    %     Ys = fft( S(n,:) , nfft );
    %     Pys(n,:) = Ys .*conj( Ys ) / (nfft./2);
    % default 50% overlapping hamming windows
    [ Pys(:,n), f ] = pwelch( S(:,n), nfft, [], nfft ); % output frequency is radians per sample
end

% f = (1/dz) * linspace( 0 ,1, (nfft./2) )./2; %multiply by 60*60*24 to get freq from units of cycles/sec to cycles/day
f = f./dz; % divide by dz to get radians per meter

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


% Plot spectrum
if plotit
    patch([f(2:end); flipdim(f(2:end), 1); f(2)],...
        [nanmean( r.high(2:end,:), 2); flipdim( nanmean( r.low(2:end,:), 2 ), 1); nanmean( r.high(2,:) ) ] , [1, 1, 1]*0.8, 'edgecolor', [1, 1, 1]*0.8)
    
    hold on
    loglog( f(1:end) ,nanmean( Pys( 1:length( f ), : ), 2), '-', 'color', clr );

    title( 'Spectrum' );
    xlabel( 'frequency [cycles m^{-1}]' );
    legend( '95% confidence interval', 'S' );
    set( gca, 'xscale', 'log', 'yscale', 'log')

    set( gca, 'layer', 'top', 'box', 'on')

end

% make the spectrum one-sided
Pys  = Pys( 1:length( f ), : ); 