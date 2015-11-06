%% Initialization
clc;clear;

AccuracyTotal = {};

addpath(genpath('../Functions'));

%% Load data
load('/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA/Accuracy_gratings_esingles/Accuracy_14gratings316_RhmMdesingle2-80_SnsrMdall_p100_groupall.mat');

%startmatlabpool(12);
%% Calculate step
Baseline = 300;
Frequency = 56;
Rhythm = 'evoked';
Time = [900:1000];

Accuracy = zeros(6,6);

for Temp_Time = Time + Baseline
    Accuracy = Accuracy + squeeze(AccuracyAll(Frequency,:,:,Temp_Time));
end
Accuracy = Accuracy / length(Time)

Temp_Object.Frequency = Frequency;
Temp_Object.Rhythm = Rhythm;
Temp_Object.Time = Time;
Temp_Object.Matrix = Accuracy;
AccuracyTotal = [AccuracyTotal Temp_Object]; 

% %% Figure step
% h = figure;
% colormap(jet);
% imagesc([0:80], [0:80], AccuracyTotal);
% colorbar;
% set(gca,'YDir','normal');
% 
% h_title = title(['14gratings      ' 'esingle      ' 'SensorAll      Freq-Freq 0-100ms'], 'FontSize', 15);
% set(gca,'FontSize',15);

% set(h,'Position',[1 1 1400 900]);
% set(h,'PaperPositionMode','auto');
% set(gca,'FontSize',25);
% set(h_title,'FontSize', 20);
% print(h,['14gratings      ' 'esingle      ' 'SensorAll      Freq-Freq 0-100ms' '.jpg'],'-djpeg','-r0');
% close(h);
% 
% save('/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA/Accuracy_gratings_isingles/TT_14gratings316_RhmMdisingle2-80(0-100).mat');
%% Save step
clear Accuracy Baseline file_location Frequency Rhythm RhythmMode Subject Temp_Object Time_Time Time
save('/dataslow/sheng/Project of Sheng/Results/sheng/AccuracyAverage.mat');
%% plot step
h = figure;
Temp_Correlation = zeros(7,7);
Axis_Label = {};
for i = 1:length(AccuracyTotal)
    for j = 1:7
        %if(i > j)
            Temp_Correlation(i,j) = corr2(squareform(AccuracyTotal{i}.Matrix), squareform(AccuracyTotal{j}.Matrix));
            %bar([i j], corr2(squareform(AccuracyTotal{i}.Matrix), squareform(AccuracyTotal{j}.Matrix)));
            %hold on;
        %end
    end 
    Axis_Label = [Axis_Label [AccuracyTotal{i}.Rhythm(1) '@' num2str(AccuracyTotal{i}.Frequency) 'Hz@'...
        num2str(AccuracyTotal{i}.Time(1)) '-' num2str(AccuracyTotal{i}.Time(length(AccuracyTotal{i}.Time))) 'ms ']];
end

colormap(jet);
imagesc(Temp_Correlation);
colorbar;
set(gca,'FontSize', 8);
set(gca,'xticklabel',Axis_Label);
set(gca,'yticklabel',Axis_Label);
set(h,'Position',[1 1 1400 900]);
set(h,'PaperPositionMode','auto');
h_title = title(['Differnt Frequencies At Differnt Time Correlations'], 'FontSize', 15);
print(h,'All Frequency At Differnt Time.jpg','-djpeg','-r0');
