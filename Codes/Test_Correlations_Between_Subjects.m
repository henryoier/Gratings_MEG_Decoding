% function RStep63D_plot_ttcore(RhythmMode)
% % plot time-time decoding accuracy

clear;clc;close all;
%cd F:\Mingtong\ToOnedrive\Scripts_RhythmClassifier
ProjectName = 'sheng';   %%%%%
RhythmMode = 'evoked'; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
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

[CC,P,Pth,fdr_th] = run_between_subject_analysis(AccuracyTT,Time);

h = figure;
imagesc(Time,Time,mean(CC, 3)); colorbar; set(gca,'YDir','normal');
colormap(jet);
axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
%caxis([YMIN YMAX]);

line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
h_title = title('Subjects betwwen Time-Time Correlation', 'FontSize', 15);
set(gca,'FontSize',15);
max_accuracy = max(max(mean(CC, 3)));
min_accuracy = min(min(mean(CC, 3)));
display([ 'Matrix: ' num2str(min_accuracy,3) '% ~ ' num2str(max_accuracy,3) '%']);

%Result = [Result (mean(mean(TT.mean(Baseline + [100:150],Baseline + [900:950]) ,1),2) - min_accuracy)/(max_accuracy - min_accuracy)];

if (flag_save)
    %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
    set(h,'Position',[1 1 1400 900]);
    set(h,'PaperPositionMode','auto');
    set(gca,'FontSize',25);
    set(h_title,'FontSize', 20);
    print(h,[jpg_file_name 'TT__Correlation' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.jpg'],'-djpeg','-r0');
    close(h);
end

%     set(h,'Position',[100 100 1200 800]);
%     axis([ -0.2, 1.5, -0.2, 1.5]); % box off;

%apply FDR
alpha = 0.001;
pv = sort(P(:)); %sorted pvalues
N = length(pv); %number of tests
l = (1:N)'/N * alpha; %FDR line
%plot(pv);hold on;plot(l);
crossings = find( pv>l == 0); 
if ~isempty(crossings) %if the two lines cross
    fdr_th = l(max(find( pv>l == 0))); %highest crossing point
else
    fdr_th = 0;
end
Pth = P<fdr_th;


h = figure;
imagesc(Time,Time,Pth); set(gca,'YDir','normal');
axis equal; axis([min(Time) max(Time) min(Time) max(Time)])

line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
h_title = title('Subjects betwwen Time-Time Correlation Significant Time', 'FontSize', 15);
set(gca,'FontSize',15);
display([ 'Time-time significant time' ]);

if (flag_save)
    %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
    set(h,'Position',[1 1 1400 900]);
    set(h,'PaperPositionMode','auto');
    set(gca,'FontSize',25);
    set(h_title,'FontSize', 20);
    print(h,[jpg_file_name 'TT__Correlation_stime.jpg'],'-djpeg','-r0');
    close(h);
end
