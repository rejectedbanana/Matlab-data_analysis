function Y = nonmonpchip( x, y, X )

% function Y = nonmonpchip( x, y, X )
%
%  Use the pchip function to interpolate data y from a non-monotonic base vector x onto
%  the a new base vector X.
%
% KIM 10.11

% make empty matrices
dx = x*0; 
Y = X*nan; 

% find the slope of x
dx(2:end) = diff( x );

% now find regions where the slope is the same sign
sc = find( diff( sign(dx ) )~=0 ); 
sc(end+1) = length( x ); 
if sc(1)~=1
    sc = [1; sc ]; 
end
% figure(1); subplot( 211)
% plot( 1:length( dx ), dx,'.-', sc, dx( sc ), 'or'); horzline( 0 ); hold on
% subplot( 212)
% plot( x, y, '.-', x(sc), y(sc), 'ro'); hold on

% start cycling through each region where the slope is the same
for dd = 1:length( sc ) - 1
    % find the indices for that region
    xr = sc(dd):sc(dd+1);
%     subplot( 211); plot( xr, dx(xr), 'b-')
    
    % find the values of X in that region
    Xr = find( X >=nanmin( x(xr) ) & X<=nanmax( x(xr )) ); 
    if ~isempty( Xr )
        % now to find the unique values
        [b, m, n] = unique( x( xr ));
        if length( m ) > 2
            % use pchip
            Y(Xr) = pchip( x(xr(m)), y(xr(m)), X(Xr));
            %     subplot( 212); plot( X(Xr), Y(Xr), 'b-')
        end
    end
    
end %dd
