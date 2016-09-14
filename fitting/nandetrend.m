function [dt]= nandetrend(x,t);

%  function [dt]= nandetrend(x, t);
%
% NANDETREND
%
% Detrend a time series with nan's in it
%
% KIM 5/2007

if nargin<2
    t = linspace( 0, 1, length( x ));
end

n = size(x,1);
if n == 1,
    x = x(:); % If a row, turn into column vector
    t = t(:);
end

% find the npn-nans
nn = find( ~isnan( x ) );

if length( nn )>2
    %remove the nans
    x1 = x( nn );
    t1 = t ( nn );
    N = size(x1,1);

    % make the dummy matrix
    dt = x*nan;

    % Make the regresssor
    rmp = linspace( 0 , nanmax( t ), n * 100 )./nanmax( t ) ;
    a = [ zeros(N, 1) , ones(N, 1) ];
    a( :, 1)  = interp1( linspace( nanmin( t ) , nanmax( t ), n * 100 ) , rmp , t1 ) ;
    
    % Regress
    rr = a\x1;
    
    % remove the trend
    dt1 = x1 - a * rr;
    
    dt( nn ) = dt1;

else
    % If only one point, do not detrend
    dt = x;
end