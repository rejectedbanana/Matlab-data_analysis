function [turningpoints] = find_turningpoints(vec)

% [turningpoints] = find_turningpoints(vec)
%
% Find turning points on a vector. Theoretically this is a change in the
% gradient, practically this is when the difference changes.
%
% KIM 08.2016


% calculate first and second derivatitives of the vector to find turning points
dvec = diff( vec ); dvec(end+1) = dvec(end); % vertical velocity
% dvec2 = gradient( dvec ); % double derivative of pressure

% find up and down profiles
upi= find( dvec  <0); % find all the up data points
dwni = find(dvec >0 ); % find all the down points

% make one giant vector
udvec = nan*vec;
udvec(upi) = +1; 
udvec(dwni) = -1; 
% find turning points
tpb = find( diff(udvec) ~=0 ); 
tpb = tpb+1; % shift one indice to the right

% output the information% turningpoints = vec*0; 
% turningpoints( tpb ) = 1; 

turningpoints = tpb; 

% % faketurns = find(diff(tpb) <5); % changed from 5 to account for autopilot problems
% % tpb(faketurns) = nan; 
% tpb = tpb(~isnan( tpb )); 
% % now define whether the following profile is up or down
% updowns = udvec( tpb ); 
% badinds = find( diff(updowns) ==0 ); 
% badinds = badinds+1; 
% % now remove the bad indices
% updowns(badinds) = nan; 
% updowns = updowns( ~isnan( updowns )); 
% tpb(badinds) = nan; 
% tpb = tpb( ~isnan( tpb )); 
% 
