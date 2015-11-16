function h = RStep6_plot_f(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save)

h = figure; hold on; 
text_size = 13;

box on; grid on; 

if (flag_save) 
    set(h,'Position',[1 1 1400 900]); 
    set(h,'PaperPositionMode','auto');
    text_size = 15;
    % set(h_Diff, 'Position', get(0,'ScreenSize'));
    % set(h_Diff, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 32 18]);
end


plot_number = length(Data);

for i_plot = 1:plot_number
    plot_Data = Data{i_plot}.mean;
    
     % smooth accuracy data, not significant time data
    if ( flag_smooth ) 
        plot_Data = conv(plot_Data,smooth_vector,'same');
    end
    
    plot(Time,plot_Data,'Color',Data{i_plot}.color,'LineWidth',1.5);
end

% plot significant time
for i_plot = 1:plot_number
    if (isfield(Data{i_plot}, 'stat_stime'))
%         if length(Data{i}.stat_stime)
        stat_stime = Data{i_plot}.stat_stime;
        
        if ( rem(plot_number,2) | (i_plot <= (plot_number)/2) )
            line(Time(stat_stime),48 - i_plot*2,'Marker', 'o','Markersize', 2, 'color',Data{i_plot}.color(1));
        else
            line( Time( stat_stime(1:8:size(stat_stime,2)) ),48 - i_plot*2,'Marker', 'o','Markersize', 2, 'color',Data{i_plot}.color(1));
        end
        %
        % stat_ttest = Data.stat_ttest;
        % line(Time(stat_ttest>0),30,'Marker', 'o' , 'Color','k');
        %
        % stat_pvalue = Data.stat_pvalue;
        % line(Time(stat_pvalue>0),25,'Marker', 'o' , 'Color','k');
%         end
    end
end

axis([min(Time),max(Time),YMIN,YMAX]);
if (YMIN>=0) line('XData', [min(Time),max(Time)], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); end
if (YMIN<0) line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); end
line('XData', [0 0], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
line('XData', [stimulate_end_time stimulate_end_time], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
title(title_text, 'FontSize', text_size)
set(gca,'FontSize',text_size);


% % % 
% close all;
% h = figure; text_size = 13;
% plot_Data = Data{1}.mean;
% if ( flag_smooth )
%     plot_Data = conv(plot_Data,smooth_vector,'same');
% end
% plot(Time,plot_Data,Data{1}.color,'LineWidth',3);
% 
% set(h,'Position',[100 100 1200 800]); 
% axis([ -0.2, 1.5, 41, 90]); box off;grid off; 
% line('XData', [-0.2, 1.5], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); 
% line('XData', [0 0], 'YData', [40, 90], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
% line('XData', [0.8 0.8], 'YData', [40, 90], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
% 
% stat_stime = Data{1}.stat_stime;
% line(Time(stat_stime),[45],'Marker', 'o','Markersize', 2, 'color',Data{1}.color(1));
% % set(gca,'xtick',[]);set(gca,'ytick',[]);
