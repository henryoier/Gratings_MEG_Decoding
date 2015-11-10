% function RStep63D_plot_ttcore(RhythmMode)
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

Counter = 0;

CC = zeros(14, 1901,1901);

%for i_subject = [0]  SubjectName = '14gratings316'; %YMIN = 40; YMAX = 90;
for i_subject = [3:16]  
    SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
    
    file_load = [ 'II_' SubjectName '_' RhythmMode '_' SensorMode cluster_th];
    load( [mat_location '/' file_load]);
    
    for ntime=1:1901
        AccuracyTT(:, ntime) = squareform(Rhythm.AccyAll.matrix(:,:,ntime));
    end
    Accuracy = corrcoef(AccuracyTT);
    
    CC(i_subject-2,:,:) = Accuracy;
end
%     for j_subject = 3:16 
%         
%         %Counter = Counter + 1;
%         
%         disp(['subject ' num2str(i_subject) ' & ' num2str(j_subject)]);
%         
%         SubjectName = ['grating' num2str(j_subject, '%0.2d')];
%         
%         file_load = [ 'II_' SubjectName '_' RhythmMode '_' SensorMode cluster_th];
%         load( [mat_location '/' file_load]);
% 
%         AccuracyTT = Rhythm.AccyAll.matrix;
%         Accuracy2 = [];
%         for time = 1:1901
%             Accuracy2 = [Accuracy2; squareform(AccuracyTT(:,:,time))];
%         end
% 
%         TempTT = corrcoef([Accuracy1;Accuracy2]'); 
%         TT.mean = TempTT(1:1901,1902:3802);
    %end
%end    

    %TT.mean = TT.mean / Counter;
    %save([mat_location 'TT_' num2str(i_subject) '&' num2str(j_subject) '_SubjectsBetween_Correlations.mat'], 'TT');
    
    jpg_file_name = [ file_location '/Fig_' RhythmMode '/IITT_corr_SubjectsBetween2___'];
%     jpg_file_name = [ file_location '/Fig3_IITT/Fig_' RhythmMode '/IITT_' file_load([4:end]) '___'];
    
    
    %%
    Time = linspace(-0.3, 1.6, 1900);
    h = figure;
    imagesc(Time,Time,squeeze(mean(CC, 1))); colorbar; set(gca,'YDir','normal');
    colormap(jet);
    axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
    %caxis([YMIN YMAX]);
    
    line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    h_title = title(['Within 14subjects Time-Time Correlation'], 'FontSize', 15);
    set(gca,'FontSize',15);
    max_accuracy = max(max(mean(CC, 1)));
    min_accuracy = min(min(mean(CC, 1)));
    display([ 'Matrix: ' num2str(min_accuracy,3) '% ~ ' num2str(max_accuracy,3) '%']);
    
    %Result = [Result (mean(mean(TT.mean(Baseline + [100:150],Baseline + [900:950]) ,1),2) - min_accuracy)/(max_accuracy - min_accuracy)];
    
    if (flag_save)
        %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
        set(h,'Position',[1 1 1400 900]);
        set(h,'PaperPositionMode','auto');
        set(gca,'FontSize',25);
        set(h_title,'FontSize', 20);
        print(h,[jpg_file_name 'TT_within_14subjects_' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.jpg'],'-djpeg','-r0');
        close(h);
    end
    
    %     set(h,'Position',[100 100 1200 800]);
    %     axis([ -0.2, 1.5, -0.2, 1.5]); % box off;
    
    % Statistic significant analysis
    nperm = 1000;
    alpha = 0.05;
    cluster_th = 0.05;   %perform cluster size tests
    
    [TT.clusters.SignificantTimes,TT.clusters.clusters,TT.clusters.clustersize] = permutation_cluster_1sample_2dim(CC, nperm, cluster_th, alpha);
    % imagesc(SignificantTimes);set(gca,'YDir','normal');
    CC = reshape(CC,[14,1901*1901,1]);
    [TT.ttest.StatMap, TT.ttest.StatMapPv, TT.ttest.Perm, TT.ttest.FDR] = permutation_1sample(CC,nperm,alpha,tail);
    CC = reshape(CC,[14,1901,1901]);
    TT.ttest.Perm.StatMapTh = reshape(TT.ttest.Perm.StatMapTh,[1901,1901]);
    TT.ttest.FDR.StatMapTh = reshape(TT.ttest.FDR.StatMapTh,[1901,1901]);
    % imagesc(TT.ttest.FDR_TT.StatMapTh>0);set(gca,'YDir','normal');
    
    h = figure;
    imagesc(Time,Time,TT.clusters.SignificantTimes); set(gca,'YDir','normal');
    axis equal; axis([min(Time) max(Time) min(Time) max(Time)])

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
        print(h,[jpg_file_name 'TT_with_14subjects_stime.jpg'],'-djpeg','-r0');
        close(h);
    end
    
    %end


