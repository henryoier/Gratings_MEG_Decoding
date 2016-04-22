function [h, legend_line] = RStep6_plot_f(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save)

h = figure('color', [1 1 1]); hold on; 

text_size = 13;

Plot = 101:1:1801;

if (flag_save) 
    set(h,'Position',[1 1 1400 900]); 
    set(h,'PaperPositionMode','auto');
    text_size = 15;
    set(gca,'linewidth', 5);
    % set(h_Diff, 'Position', get(0,'ScreenSize'));
    % set(h_Diff, 'PaperUnits', 'centimeters', 'PaperPosition', [0 0 32 18]);
end

plot_number = length(Data);

line('XData', [0 0], 'YData', [YMIN + 1.65,YMAX], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255);
line('XData', [0.8 0.8], 'YData', [YMIN + 1.65,YMAX], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255);

for i_plot = 1:plot_number
    plot_Data = Data{i_plot}.mean;
    
     % smooth accuracy data, not significant time data
    
    legend_line(i_plot,:) = plot(Time(Plot),plot_Data(Plot),Data{i_plot}.color,'LineWidth',5);
    
end

% plot significant time
for i_plot = 1:plot_number
    if (isfield(Data{i_plot}, 'stat_stime'))
%         if length(Data{i}.stat_stime)
        stat_stime = Data{i_plot}.stat_stime;
        
        if ( rem(plot_number,2) | (i_plot <= (plot_number)/2) )
            line(Time(stat_stime),45 - i_plot*3,'Marker', 'o','Markersize', 3, 'color',Data{i_plot}.color(1));
        else
            plot( Time( stat_stime),ones(1, length(stat_stime)) * 45 - i_plot*3,Data{i_plot}.color, 'LineWidth', 3);
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

Time = Time(Plot);
axis([min(Time),max(Time),YMIN,YMAX]);
set(gca,'xtick',-0.2:0.1:1.5);
set(gca,'XTickLabel', {});
set(gca,'YTickLabel', {});
%if (YMIN>=0) line('XData', [min(Time),max(Time)], 'YData', [50 50], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); end
%if (YMIN<0) line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0]); end
%line('XData', [stimulate_end_time stimulate_end_time], 'YData', [YMIN,YMAX], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
%title(title_text, 'FontSize', text_size)
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
