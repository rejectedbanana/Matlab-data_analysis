function [ x, sd, N, ygauss, hh] = plot_gaussian( y, bins, varargin )

% function [ x, sd, N, ygauss,hh] = plot_gaussian( y, varargin )
   %
   % insert a data vector y to find the standard deviation (sd), plot a
   % normalized histogram (PDF) over a 4 standard deviation range (default is 21 bins),
   % plot the gaussian distribution based upon the calculated standard
   % deviation.  
   %
   % Varargin sets the attributes for the bar graph;
   %
   % Also output the handles for each plotted attribute
   % hh = [bar, gaussian, -2sd, +2sd]
   %
   %
   % KIM 06.11
   if nargin <2
       bins = 21;
       if nargin <3
           varargin  = {'facecolor', [1, 1, 1]*0.5, 'edgecolor', 'k'};
       end
   end
   
 % remove the nans
 y = y( ~isnan( y )); 
   
% find the standard deviation
sd = std( y ); 
% find and plot the PDF
x = linspace( -1, 1, bins)*4*sd+mean(y); 
[N, bin] = histc( y, x);
hh(1) = bar( x, N./max(N), varargin{:}); hold on
% plot the normal distribution associated with the standard distribution
ygauss = exp( -0.5*(x- mean( y )).^2./sd.^2);
hh(2) = plot( x, ygauss, 'k-'); 
% plot 2 standard deviations away
hh(3) = vertline( -2*sd+mean( y ), 'k--'); 
hh(4) = vertline( 2*sd+mean(y ), 'k--');
legend( 'PDF', 'gaussian fit', '2\sigma')