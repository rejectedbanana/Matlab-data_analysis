function [ value_time ] = find_periodic( time, data, value )

% function [ value_time ] = find_periodic( time, data, value )
%
%  For a periodic time series, find all the times where the value v
%  appears using interpolation.
%
%  For example, to find the zero-crossings, use value = 0;  time and data
%  must be vectors of the same length
%
% KIM 02.10

% set up the value time
value_time = data*nan; 

for n = 1:length( data )-1
    % find the data
    data_win = data( n:n+1); 
    time_win = time( n:n+1); 
    % remove any nans
    data_win = data_win( ~isnan( data_win )  ); 
    time_win = time_win(  ~isnan( data_win )  ); 
    % interpolate to find the value
    if   length( data_win ) >=2 
       value_time( n ) = interp1( data_win, time_win, value);
    else
       value_time( n ) = nan; 
    end
end
% remove the nans
value_time = value_time( ~isnan( value_time ) ); 