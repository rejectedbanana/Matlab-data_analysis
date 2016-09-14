function [flag] = flag_data( vec )

% function [flag] = flag_data( vec )
%
%  Opens a GUI where a vector of data is plotted and you can pick the bad
%  spots.  The indices are then output in the vector flag
%
%  KIM 11.11

f = figure(1); clf;
set( gcf, 'position', [188         552        1128         261], 'name', 'data flagger')

ax1 = axes( 'position', [  0.08    0.1500    0.7358    0.7500]); 

% Move the GUI to the center of the screen.
movegui(f,'center')
% Make the GUI visible.
set(f,'Visible','on');

% plot the original data
plot( vec ); hold on

% make an flag vector of zeros
flag = vec*0; 

%Settings of pushbutton below   
b1 = uicontrol('parent', 1, 'Style', 'pushbutton',...
       'String', 'flag data.',...
       'Units', 'normalized', ...
       'fontsize', 14, ...
       'ForegroundColor', 'b', ...
       'Position', [0.82 0.7 0.15 0.08],...
       'Callback', 'flag = pickdata( vec, flag );');

      b2 = uicontrol('parent', 1, 'Style', 'pushbutton',...
       'String', 'clear all flags.',...
       'Units', 'normalized', ...
       'fontsize', 14, ...
       'ForegroundColor', 'b', ...
       'Position', [0.82 0.5 0.15 0.08],...
       'Callback', 'flag = vec*0; cla; plot(vec); hold on');
   
   b3 =  uicontrol('parent', 1, 'Style', 'pushbutton',...
       'String', 'done and output.',...
       'Units', 'normalized', ...
       'fontsize', 14, ...
       'ForegroundColor', 'b', ...
       'Position', [0.82 0.3 0.15 0.08],...
       'Callback', 'return');
   
%    % flag the data
%     function flag = flagdata_Callback( vec, flag )
%         %pick start of bad data
%         [pickx, picky] = ginput(1);
%         % translate value to an indice
%         f1 = floor( pickx );
%         plot( f1, vec(f1), 'rx', 'markersize', 8, 'linewidth',2)
%         
%         % pick end of bad data
%         [pickx, picky] = ginput(1);
%         
%         % translate value to an indice
%         f2 = floor( pickx );
%         plot( f2, vec(f2),'rx', 'markersize', 8, 'linewidth',2)
%         
%         % set values in flag to 1
%         flag( f1:f2 ) = 1;
%         
%         % highlight flagged data in red
%         plot( f1:f2, vec( f1:f2), 'r-')
        
% % make the buttons do something
% switch(lower(theCallback))
%     case 'callback'
%         switch(lower(get(gcbo,'string')))
%             case 'flag data.'
%                 flag = pickdata( vec, flag );
%             case 'clear all flags.'
%                 flag = vec*0; cla; plot( data); hold on
%             case 'done and output.'
%                 return
%                 
%         end %switch
% end % switch