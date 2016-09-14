function [PDF] = khist2(x, y, xedges, yedges)

% function [PDF] = khist2(x, y, xedges, yedges)
%
% MAke a 2D histogram
%
% KIM 03.14

PDF = nan( length(yedges), length(xedges)); 

for rr = 1:length(yedges)-1
    for cc = 1:length(xedges)-1
        inds = find( x>=xedges(cc) & x<xedges(cc+1) & y>=yedges(rr) & y<yedges(rr+1)); 
        PDF(rr, cc) = numel(inds); 
    end
end

PDF(end,:) = 0; PDF(:, end) = 0; 

