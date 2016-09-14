function [Pys, f, r] = kspecT( S, nfft, delt, plotit, clr, oceanfreqlat )
% function [Py, f, nfft, r] = kspecT( S, nfft, delt, plotit, clr, oceanfreqlat );
%
% Find the spectrum of a vector S using fft with overlapping chunks of size
% nfft. If defining the sampling interval with delt, make sure the units
% are seconds.
%
% plotit: Plot the 
% clr: plot color
% oceanfreqlat: plots vertical f line
% The fft is done over the second dimension
%
% ADDED ABILITY TO DO 2-D Matrices 
%KIM 04/08

% defaults
if nargin<6
    oceanfreqlat = 90;
    if nargin< 5
        clr = 'b';
        if nargin< 4
            plotit = 0;
            if nargin <3
                delt =  1;
            end
        end
    end
end

%number of values
[d1, d2] = size( S ); 

% remove mean of data
S = S - repmat( nanmean( S, 2 ), [ 1, d2 ] );

% Detrend
for n = 1:d1
    S(n,:) = nandetrend( S(n,:) )';
end

% find the power spectra
for n = 1:d1
    %     Ys = fft( S(n,:) , nfft );
    %     Pys(n,:) = Ys .*conj( Ys ) / (nfft./2);
    % default 50% overlapping hamming windows
    [ Pys(n,: ), f ] = pwelch( S(n,: ), nfft, [], nfft );
end

% find number of independent windows in pwelch for 50% window (bottom of
% pwelch doc)
Nb = (d2 - nfft./2)./(nfft - nfft./2);
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

% f = (1/delt) * linspace( 0 ,1, (nfft./2) )./2; %multiply by 60*60*24 to get freq from units of cycles/sec to cycles/day
f = f./delt; 

% Plot spectrum
if plotit
    patch([f(2:end); flipdim(f(2:end), 1); f(2)],...
        [nanmean( r.high(:, 2:end), 1)'; flipdim( nanmean( r.low(:, 2:end), 1 )', 1); nanmean( r.high(:, 2 ) ) ] , [1, 1, 1]*0.8, 'edgecolor', [1, 1, 1]*0.8)
    %     loglog( f, nanmean( r.high, 1 ),':',  f, nanmean( r.low, 1 ), ':',  'color',   [1, 1, 1]*0.7);  
    hold on
    loglog( f(1:end) ,nanmean( Pys( :, 1:length( f ) ), 1), '-', 'color', clr );

    title( 'Spectrum' );
    xlabel( 'frequency [cycles s^{-1}]' );
    legend( '95% confidence interval', 'S' );
    set( gca, 'xscale', 'log', 'yscale', 'log')
    % add in the M2 and F lines
    if exist( 'oceanfreqlat')
        hold on
%         loglog( 1./(12.421*60*60)*ones( 2,1 ) , ylim , 'r--' )
        vertline( 2*pi./12.421/60/60, 'r-')
%         loglog( sw_f( oceanfreqlat )*ones( 2,1 )./2*pi , ylim , 'g--' )
        vertline( sw_f( oceanfreqlat ), 'g-')
        legend(  '95% confidence interval', 'S' , 'M_{2}', 'f');
    end
    set( gca, 'layer', 'top', 'box', 'on')

end

% make the spectrum one-sided
Pys  = Pys( :, 1:length( f ) ); 