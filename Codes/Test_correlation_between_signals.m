% function RStep63D_plot_ttcore(RhythmMode)
% % plot time-time decoding accuracy

clear;clc;close all;
ProjectName = 'sheng';   %%%%%
RhythmMode={'evoked','ivectorlow','ivectorhigh'}; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all'
cluster_th = '';

Time = linspace(-0.3, 1.6, 1900);

flag_save = 0;

file_location = [ pwd '/Results/' ProjectName ];
% mat_location = [ file_location '\Mat_' RhythmMode];

jpg_file_name = [file_location '/Fig_Between_Rhythm/' ];

addpath(genpath('Functions'));

Result = [];
Baseline = 300;

Counter = 0;

AccuracyTT1 = zeros(14,6,6,1901);
AccuracyTT2 = zeros(14,6,6,1901);


for condA = 1:1
    for condB = 2:2
%for i_subject = [0]  SubjectName = '14gratings316'; %YMIN = 40; YMAX = 90;
disp([RhythmMode{condA} ' versus ' RhythmMode{condB}]);
for i_subject = [3:16]
    %if strcmp(RhythmMode{condA},'evoked')
        mat_location = [ file_location '/Mat_' RhythmMode{condA}];
        SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
        file_load = [ 'II_' SubjectName '_' RhythmMode{condA} '_' SensorMode '.mat'];
        load( [mat_location '/' file_load]);
        AccuracyTT1(i_subject-2,:,:,:) = Rhythm.AccyAll.matrix;
%     else
%         mat_location = [ file_location '/Mat_TFA_isingle/ACCY_gratings_ivector'];
%         SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
%         file_load = [ 'ACCY_' SubjectName '_' RhythmMode{condA} '_' SensorMode '.mat'];
%         load( [mat_location '/' file_load]);
%         AccuracyTT1(i_subject-2,:,:,:) = Rhythm.AccyAll.matrix;
%     end
    
    %if strcmp(RhythmMode{condB},'evoked')
        mat_location = [ file_location '/Mat_' RhythmMode{condB}];
        SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
        file_load = [ 'II_' SubjectName '_' RhythmMode{condB} '_' SensorMode '.mat'];
        load( [mat_location '/' file_load]);
        AccuracyTT2(i_subject-2,:,:,:) = Rhythm.AccyAll.matrix;
%     else
%         mat_location = [ file_location '/Mat_TFA_isingle/ACCY_gratings_isingles'];
%         SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
%         file_load = [ 'ACCY_' SubjectName '_' RhythmMode{condB} '_' SensorMode '.mat'];
%         load( [mat_location '/' file_load]);
%         AccuracyTT2(i_subject-2,:,:,:) = Rhythm.AccyAll.matrix;
%     end
end

CC = run_between_subject_signals(AccuracyTT1,AccuracyTT2,Time);

h = figure;
imagesc(Time,Time,mean(CC, 3)); colorbar; set(gca,'YDir','normal');
colormap(jet);
axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
%caxis([YMIN YMAX]);

line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
h_title = title([RhythmMode{condA} ' versus ' RhythmMode{condB}], 'FontSize', 15);
set(gca,'FontSize',15);

%Result = [Result (mean(mean(TT.mean(Baseline + [100:150],Baseline + [900:950]) ,1),2) - min_accuracy)/(max_accuracy - min_accuracy)];

if (flag_save)
    %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
    set(h,'Position',[1 1 1400 900]);
    set(h,'PaperPositionMode','auto');
    set(gca,'FontSize',25);
    set(h_title,'FontSize', 20);
    print(h,[jpg_file_name RhythmMode{condA} ' versus ' RhythmMode{condB} '.jpg'],'-djpeg','-r0');
    close(h);
end
    

%     set(h,'Position',[100 100 1200 800]);
%     axis([ -0.2, 1.5, -0.2, 1.5]); % box off;
%% statistic analysis
CC = permute(CC, [3 1 2]);

% Statistic significant analysis
    nperm = 1000;
    alpha = 0.05;
    cluster_th = 0.05;   %perform cluster size tests
    tail = 'onsided';
    
    [TT.clusters.SignificantTimes,TT.clusters.clusters,TT.clusters.clustersize] = permutation_cluster_1sample_alld(CC, nperm, cluster_th, alpha, tail);
%     % imagesc(SignificantTimes);set(gca,'YDir','normal');
%     CC = reshape(CC,[14,1901*1901,1]);
%     [TT.ttest.StatMap, TT.ttest.StatMapPv, TT.ttest.Perm, TT.ttest.FDR] = permutation_1sample(CC,nperm,alpha);
%     CC = reshape(CC,[14,1901,1901]);
%     TT.ttest.Perm.StatMapTh = reshape(TT.ttest.Perm.StatMapTh,[1901,1901]);
%     TT.ttest.FDR.StatMapTh = reshape(TT.ttest.FDR.StatMapTh,[1901,1901]);
%     % imagesc(TT.ttest.FDR_TT.StatMapTh>0);set(gca,'YDir','normal');
    

%% figure significant time
h = figure;
imagesc(Time,Time,TT.clusters.SignificantTimes); set(gca,'YDir','normal');
axis equal; axis([min(Time) max(Time) min(Time) max(Time)])

line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
h_title = title(['Subjects between ' RhythmMode{condA} ' versus ' RhythmMode{condB} ], 'FontSize', 15);
set(gca,'FontSize',15);
display([ 'Time-time significant time']);

if (flag_save)
    %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
    set(h,'Position',[1 1 1400 900]);
    set(h,'PaperPositionMode','auto');
    set(gca,'FontSize',25);
    set(h_title,'FontSize', 20);
    print(h,[jpg_file_name 'TT__Correlation_stime_' RhythmMode{condA} '_versus_' RhythmMode{condB} '_0.05.jpg'],'-djpeg','-r0');
    close(h);
end
end
end
% save([mat_location '\Correlation_between.mat']);