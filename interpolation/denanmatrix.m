function [mat] = denanmatrix( mat )

% function [mat] = denanmatrix( mat )
% 
% If a matrix needs all NaNs removed (e.g. for computing spectra), this
% script linearly interpolates over all gaps with nans with interpnans and fills in the
% mean at the ends.  For a matrix works down all the rows.
%
% KIM 04.12

% find the size of the matrix
[d1, d2] = size( mat ); 

% now cycle through all the columns 
for cc = 1:d2
   % interpolate over all the nans
   mat( :, cc ) = interpnans( mat(:,cc)); 
   % fill in the ends with the mean
   mat(isnan( mat( :, cc )), cc ) = nanmean( mat(:,cc)); 
end


   