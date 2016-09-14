function [boxed] = boxcarsmooth( vec, win )

% function [boxed] = boxcarsmooth( vec, win )
%
%  Smooth matrix along each column with a running boxcar of size win
%  Can use both even and odd sized windows
%
% KIM 10/10

[M, N] = size( vec ); 
if (M == 1) && (N>1)
    vec = vec'; 
    flip = 1; 
    [M, N] = size( vec ); 
end
boxed = vec*nan; 

% check if the window is even or odd
evenodd = mod( win, 2 ); 

for cc = 1:N
    
    if evenodd == 1 % odd
        lobe = floor( win./2 );
        % define the start and end indices
        start_i = lobe+1;
        end_i = length( vec(:,cc) ) - (lobe+1);
        % now cycle through
        for n = start_i:end_i
            chunk = vec( n-lobe:n+lobe, cc);
            boxed( n,cc ) = nanmean( chunk );
        end
        %  add on the ends
        boxed( 1:start_i, cc) = boxed( start_i, cc );
        boxed( end_i:end, cc ) = boxed( end_i, cc );
        
    elseif evenodd == 0 % even
        lobe = win - 1;
        % define the start and end indices
        start_i = 1;
        end_i = length( vec(:,cc) ) - (win);
        % cycle through
        for n =start_i:end_i
            chunk = vec( n:n+lobe, cc );
            % offset grid
            oddb(n) = nanmean( chunk );
            ind(n) = nanmean( n:n+lobe);
        end
        %  keep ends constant
        oddb( 1:start_i ) = oddb( start_i );
        oddb( end_i:end ) = oddb( end_i );
        
        %interpolate back onto the original grid
        boxed(:, cc ) = interp1( ind, oddb, 1:M)';
        
    end
end %cc
if exist( 'flip' ) ==1
    boxed = boxed';
end