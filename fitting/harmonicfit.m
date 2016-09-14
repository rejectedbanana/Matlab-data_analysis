function [fit, amp, phase, mean, trnd, err] = harmonicfit( t, d, freqfit )

% function [fit, amp, phase, mean, trnd, err] = harmonicfit( t, d, freqfit )
%
% Using least squares regression, do a harmonic fit on a data vector using
% regress.  
%
% inputs:
% t - time vector [unit time]
% d - data vector [data units]
% freqfit - vector of frequencies to fit.  [cycles/unit time]
% 
% NOTES: modify fit so it outputs a column for each frequency
%
%  KIM 04.2012

% flip t and d into columns
[dum, d2] = size( t ); 
if d2 ~=1
    t = t'; 
end
[dum, d4 ] = size( d ); 
if d4  ~=1
    d = d'; 
end

% make sure t and d are the same size
if size( t, 1 )~= size( d, 1 )
    error( 'time and data are not the same length')
end

% find the number of frequencies to fit
frqs = max( size( freqfit )); 

% create sine and cosine signals
st = nan*ones( [length(t), frqs] );
ct = st;
for f = 1:frqs ;
    st(:, f) = sin(2*pi*t*freqfit(f));
    ct(:, f) = cos(2*pi*t*freqfit(f));
end

% % first detrend the data using a linear fit
% [b, bint] = regress( d, [ lt, ones( size( t )) ], .05); 


% Regress onto a sine, cosine, and constant w/95% confidence levels
if sum( ~isnan( d ) ) >=4 % only run regression if more than 4 data points    
    % make a linear trend to fit
    lt = interp1(linspace( t(1), t(end), length( t )), linspace( 0, 1, length( t )),  t);
    % fit with regress
    % tic
    % [ b,bint ] = regress(d,[ ct, st, lt, ones( size( t )) ] ,.05);
    % toc
    % keyboard
    % fit with lmfit instead
    lm = fitlm([ ct, st, lt ],d);
    b = lm.Coefficients.Estimate;
    bint = coefCI(lm); 
    % edit based on p-value
    badinds = find( lm.Coefficients.pValue > 0.05);
    b(badinds,:) = 0;
    bint(badinds, : ) = 0;
    % rearrange b to match regress
    b = [b(2:end); b(1)];
    bint = [bint(2:end,:); bint(1,:)];

else % output nans
    lt = t*nan; 
    b=nan(frqs*2+2,1);
    bint = nan(frqs*2+2,2);
end % if

% recreate the fit
for f = 1:frqs
    fit(:,f) = [ct(:, f), st(:,f)]*b([f, f+frqs]);
end %f

%find the mean
mean = b(end);

% find the trend
trnd = lt.*b(end-1)+b(end); 

% find the amplitude and phase
phase = atan2( b(frqs+1:end-2), b(1:frqs) )*180./pi;
amp = hypot( b(1:frqs), b(frqs+1:end-2) );

% calculate the residual
err.msqrt = nansum((d - [ ct, st,  lt , ones( size( t )) ]*b).^2)./nansum(d.^2); 

% convert confidence intervals to amplitude and phase
[ph1, r1]=cart2pol( bint(1:frqs,1), bint(frqs+1:end-2,1) );
[ph2, r2]=cart2pol( bint(1:frqs,2), bint(frqs+1:end-2,2) );
[ph3, r3]=cart2pol( bint(1:frqs,1), bint(frqs+1:end-2,2) );
[ph4, r4]=cart2pol( bint(1:frqs,2), bint(frqs+1:end-2,1) );

% output error
err.mean.min = bint( end, 1 ); 
err.mean.max = bint( end, 2 ); 
err.trnd.min = bint( end-1, 1); 
err.trnd.max = bint( end-1, 2); 
err.amp.min = min( [r1, r2, r3, r4], [], 2 ); 
err.amp.max = max( [r1, r2, r3, r4], [], 2 );  
err.phase.min = min( [ph1, ph2, ph3, ph4], [], 2)*180./pi; 
err.phase.max = max( [ph1, ph2, ph3, ph4] , [], 2)*180/pi; 




