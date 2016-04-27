% function RStep6B_plot_tt(RhythmMode)
% % plot time-time decoding accuracy

clear;clc;close all;
%cd F:\Mingtong\ToOnedrive\Scripts_RhythmClassifier
ProjectName = 'sheng';   %%%%%
RhythmModes = {'evoked','ivectorlow','ivectorhigh'}; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all'
cluster_th = '';

for i_mode = 1:3
RhythmMode = RhythmModes{i_mode};

file_location = [ pwd '/../../Results/Gratings/' ProjectName ];
% mat_location = [ file_location '\Mat_' RhythmMode];
mat_location = [ file_location '/Mat_' RhythmMode ];
save_location = [file_location '/Final_paper/'];
flag_save = 1;

Result = [];
plot_time = 101:1:1801;
Baseline = 200;

 for i_subject = [0]  SubjectName = '14gratings316'; YMIN = 45; YMAX = 85;
%for i_subject = [3:16]  SubjectName = ['grating' num2str(i_subject, '%0.2d')]; YMIN = 20; YMAX = 100;
    
    file_load = [ 'TT_' SubjectName '_' RhythmMode '_' SensorMode cluster_th '.mat'];
    load( [mat_location '/' file_load]);
    if strcmp(param.SubjectName([1:7]),'grating')   % if individual subject
        TT.mean = AccuracyTT;
    end
    
%     jpg_file_name = [ file_location '/Fig3_IITT/Fig_' RhythmMode '/IITT_' file_load([4:end]) '___'];
    
    %%
    TT.mean = TT.mean(plot_time, plot_time);
    TT.stat_stime = TT.stat_stime(plot_time, plot_time);
    
    Time = param.Time(plot_time);
    h = figure('color', [1 1 1]);
    
    imagesc(Time,Time,TT.mean); 
    %colorbar; 
    set(gca,'YDir','normal');
    colormap(jet);
    axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
    caxis([YMIN YMAX]);

    line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
    line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
    line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
    line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
    %h_title = title([SubjectName '      ' RhythmMode '      ' SensorMode '      Time-Time'], 'FontSize', 15);
    set(gca,'LineWidth', 5);
    set(gca,'xtick',-0.2:0.1:1.5);
    set(gca,'ytick',-0.2:0.1:1.5);
    set(gca,'XTickLabel', {});
    set(gca,'YTickLabel', {});
     
    %Result = [Result (mean(mean(TT.mean(Baseline + [100:150],Baseline + [900:950]) ,1),2) - min_accuracy)/(max_accuracy - min_accuracy)];
    
    if (flag_save)
        %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
        set(h,'Position',[1 1 900 900]);
        set(gca,'looseinset', [0.01 0.01 0.01 0.01]);
        set(h,'PaperPositionMode','auto');
        saveas(h,[save_location 'IITT_' RhythmMode '_' num2str(param.stat.alpha) '_' num2str(param.stat.cluster_th) '_' param.stat.tail '_all.fig']);
        saveas(h,[save_location 'IITT_' RhythmMode '_' num2str(param.stat.alpha) '_' num2str(param.stat.cluster_th) '_' param.stat.tail '_all.jpg']);
            
        %set(gca,'FontSize',25);
        %set(h_title,'FontSize', 20);
        %print(h,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.jpg'],'-djpeg','-r0');
        close(h);
    end
    
    %     set(h,'Position',[100 100 1200 800]);
    %     axis([ -0.2, 1.5, -0.2, 1.5]); % box off;
    
    
    
    if isfield(TT,'stat_stime')
        h = figure('color', [1 1 1]);
        imagesc(Time,Time,TT.stat_stime); set(gca,'YDir','normal');
        axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
             
        line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
        line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
        line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
        line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 5, 'Color',[192 192 192]/255)
        %h_title = title([SubjectName '      ' RhythmMode '      ' SensorMode '      Time-Time'], 'FontSize', 15);
        set(gca,'LineWidth', 5);
        set(gca,'xtick',-0.2:0.1:1.5);
        set(gca,'ytick',-0.2:0.1:1.5);
        set(gca,'XTickLabel', {});
        set(gca,'YTickLabel', {});
        
        if (flag_save)
            %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
            set(h,'Position',[1 1 900 900]);
            set(gca,'looseinset', [0.01 0.01 0.01 0.01]);
            set(h,'PaperPositionMode','auto');
%             set(gca,'FontSize',25);
%             set(h_title,'FontSize', 20);
            saveas(h,[save_location 'IITT_' RhythmMode '_' num2str(param.stat.alpha) '_' num2str(param.stat.cluster_th) '_' param.stat.tail '_stat.fig']);
            saveas(h,[save_location 'IITT_' RhythmMode '_' num2str(param.stat.alpha) '_' num2str(param.stat.cluster_th) '_' param.stat.tail '_stat.jpg']);
            close(h);
        end
    end
end
end

