% function RStep63D_plot_ttcore(RhythmMode)
% % plot time-time decoding accuracy

clear;clc;close all;
%cd F:\Mingtong\ToOnedrive\Scripts_RhythmClassifier
ProjectName = 'sheng';   %%%%%
RhythmMode = 'ivectorhigh'; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all'
cluster_th = '';

Time = linspace(-0.3, 1.6, 1900);

flag_save = 1;

file_location = [ pwd '/Results/' ProjectName ];
% mat_location = [ file_location '\Mat_' RhythmMode];
mat_location = [ file_location '/Mat_' RhythmMode ];

jpg_file_name = [file_location '/Fig_' RhythmMode '/' ];

addpath(genpath('Functions'));

Result = [];
Baseline = 300;

Counter = 0;

AccuracyTT = zeros(14,6,6,1901);

%for i_subject = [0]  SubjectName = '14gratings316'; %YMIN = 40; YMAX = 90;
for i_subject = [3:16]  
    SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
    
    file_load = [ 'II_' SubjectName '_' RhythmMode '_' SensorMode cluster_th];
    load( [mat_location '/' file_load]);
    
    AccuracyTT(i_subject-2,:,:,:) = Rhythm.AccyAll.matrix;
 
end

[nsubj ncond ncond ntime] = size(AccuracyTT); %Assume input is M(subj,cond,cond,time)
M = AccuracyTT;

%convert to squareform
for s = 1:nsubj
    for t = 1:ntime
        %M(:,:,s,t) = tril(M(:,:,s,t),-1); %optional, making sure matrix is lower triangular
        Msq(:,t,s) = squareform(tril(squeeze(M(s,:,:,t)),-1)); %Msq(condcond,time,subj)
    end
end

%compute across subject correlations
k=1;
for s1 = 1:nsubj
    for s2 = 1:s1-1
        CC1(:,:,k) = corr(Msq(:,:,s1), Msq(:,:,s2), 'type','Spearman'); %Msq(:,:,s) should be condxtime
        CC1(:,:,k+1) = CC1(:,:,k)';
        k = k+2;
        %k=k+1;
    end
end

h = figure;
imagesc(Time,Time,mean(CC1, 3)); colorbar; set(gca,'YDir','normal');
colormap(jet);
axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
%caxis([YMIN YMAX]);

line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
h_title = title('Subjects between in ivectorhigh', 'FontSize', 15);
set(gca,'FontSize',15);
max_accuracy = max(max(mean(CC1, 3)));
min_accuracy = min(min(mean(CC1, 3)));
display([ 'Matrix: ' num2str(min_accuracy,3) '% ~ ' num2str(max_accuracy,3) '%']);

%Result = [Result (mean(mean(TT.mean(Baseline + [100:150],Baseline + [900:950]) ,1),2) - min_accuracy)/(max_accuracy - min_accuracy)];

if (flag_save)
    %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
    set(h,'Position',[1 1 1400 900]);
    set(h,'PaperPositionMode','auto');
    set(gca,'FontSize',25);
    set(h_title,'FontSize', 20);
    print(h,[jpg_file_name 'TT_ivectorhigh_Correlation_between_Spearman' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.jpg'],'-djpeg','-r0');
    close(h);
end

disp('convert');

CC = permute(single(CC1), [3,1,2]);

%     set(h,'Position',[100 100 1200 800]);
%     axis([ -0.2, 1.5, -0.2, 1.5]); % box off;

disp('statistc');

% Statistic significant analysis
    nperm = 1000;
    alpha = 0.05;
    cluster_th = 0.05;   %perform cluster size tests
    
    [TT.clusters.SignificantTimes,TT.clusters.clusters,TT.clusters.clustersize] = permutation_cluster_1sample_2dim(CC, nperm, cluster_th, alpha);
    % imagesc(SignificantTimes);set(gca,'YDir','normal');
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
h_title = title('Subjects between in ivectorhigh', 'FontSize', 15);
set(gca,'FontSize',15);
display([ 'Time-time significant time' ]);

if (flag_save)
    %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
    set(h,'Position',[1 1 1400 900]);
    set(h,'PaperPositionMode','auto');
    set(gca,'FontSize',25);
    set(h_title,'FontSize', 20);
    print(h,[jpg_file_name 'TT_ivectorhigh_Correlation_between_stime_Spearman.jpg'],'-djpeg','-r0');
    close(h);
end

save([mat_location '\Correlation_between_ivectorhigh.mat']);