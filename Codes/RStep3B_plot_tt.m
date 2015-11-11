% function RStep6B_plot_tt(RhythmMode)
% % plot time-time decoding accuracy

clear;clc;close all;
%cd F:\Mingtong\ToOnedrive\Scripts_RhythmClassifier
ProjectName = 'sheng';   %%%%%
RhythmMode = 'evoked'; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all'
cluster_th = '';

file_location = [ pwd '/Results/' ProjectName ];
% mat_location = [ file_location '\Mat_' RhythmMode];
mat_location = [ file_location '/Mat_' RhythmMode ];

flag_save = 1;

Result = [];
Baseline = 300;

 for i_subject = [0]  SubjectName = '14gratings316'; YMIN = 40; YMAX = 90;
%for i_subject = [3:16]  SubjectName = ['grating' num2str(i_subject, '%0.2d')]; YMIN = 20; YMAX = 100;
    
    file_load = [ 'TT_' SubjectName '_' RhythmMode '_' SensorMode cluster_th];
    load( [mat_location '/' file_load]);
    if strcmp(param.SubjectName([1:7]),'grating')   % if individual subject
        TT.mean = AccuracyTT;
    end
    
    jpg_file_name = [ file_location '/Mat_' RhythmMode '/IITT_' file_load([4:end]) '___'];
%     jpg_file_name = [ file_location '/Fig3_IITT/Fig_' RhythmMode '/IITT_' file_load([4:end]) '___'];
    
    %%
    Time = param.Time;
    h = figure;
    imagesc(Time,Time,TT.mean); colorbar; set(gca,'YDir','normal');
    colormap(jet);
    axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
    %caxis([YMIN YMAX]);
    
    % Draw the analytical area
    line('XData', [0.05, 0.2], 'YData', [0.9 0.9], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
    line('XData', [0.05, 0.2], 'YData', [1.0 1.0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
    line('XData', [0.05 0.05], 'YData', [0.9, 1.0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
    line('XData', [0.2 0.2], 'YData', [0.9, 1.0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')

    line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    h_title = title([SubjectName '      ' RhythmMode '      ' SensorMode '      Time-Time'], 'FontSize', 15);
    set(gca,'FontSize',15);
    max_accuracy = max(max(TT.mean));
    min_accuracy = min(min(TT.mean));
    display([ 'Matrix: ' num2str(min_accuracy,3) '% ~ ' num2str(max_accuracy,3) '%']);
    
    %Result = [Result (mean(mean(TT.mean(Baseline + [100:150],Baseline + [900:950]) ,1),2) - min_accuracy)/(max_accuracy - min_accuracy)];
    
    if (flag_save)
        %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
        set(h,'Position',[1 1 1400 900]);
        set(h,'PaperPositionMode','auto');
        set(gca,'FontSize',25);
        set(h_title,'FontSize', 20);
        print(h,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.jpg'],'-djpeg','-r0');
        close(h);
    end
    
    %     set(h,'Position',[100 100 1200 800]);
    %     axis([ -0.2, 1.5, -0.2, 1.5]); % box off;
    
    
    
    if isfield(TT,'stat_stime')
        h = figure;
        imagesc(Time,Time,TT.stat_stime); set(gca,'YDir','normal');
        axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
        
        % Draw the analytical area
        line('XData', [0.05, 0.2], 'YData', [0.9 0.9], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
        line('XData', [0.05, 0.2], 'YData', [1.0 1.0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
        line('XData', [0.05 0.05], 'YData', [0.9, 1.0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
        line('XData', [0.2 0.2], 'YData', [0.9, 1.0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
       
        line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
        line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
        line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
        line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
        h_title = title([SubjectName '      ' RhythmMode '      ' SensorMode '      Time-Time'], 'FontSize', 15);
        set(gca,'FontSize',15);
        display([ 'Time-time significant time' ]);
        
        if (flag_save)
            %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
            set(h,'Position',[1 1 1400 900]);
            set(h,'PaperPositionMode','auto');
            set(gca,'FontSize',25);
            set(h_title,'FontSize', 20);
            print(h,[jpg_file_name 'TT__stime.jpg'],'-djpeg','-r0');
            close(h);
        end
    end
end

%% Bar chart
h = figure;
bar(Result, 'c');
set(gca, 'xticklabel', [3:16]);

