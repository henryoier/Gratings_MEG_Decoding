addpath(genpath('Functions'));

Baseline = 300;

%% Evoked All

file_prefix = '/dataslow/sheng/Project of Sheng/Results/sheng/Mat_evoked/II_grating';
file_suffix = '_evoked_all.mat';

Result = [];

for subject = 16:16
    if subject < 10 
        load([file_prefix '0' num2str(subject) file_suffix]);
    else
        load([file_prefix num2str(subject) file_suffix]);
    end
    
    disp(['Subject = ' num2str(subject)]);
    
     Accuracy1 = mean(Rhythm.AccyAll.matrix(:,:,Baseline + [100:150]), 3)
     Accuracy2 = mean(Rhythm.AccyAll.matrix(:,:,Baseline + [900:950]), 3)

    Result = [Result corr2(squareform(Accuracy1), squareform(Accuracy2))];
end
    
%% Evoked versus induced 

% file_prefix = '/dataslow/sheng/Project of Sheng/Results/sheng/Mat_evoked/II_grating';
% file_suffix = '_evoked_all.mat';
% 
% Result = [];
% 
% for subject = 3:16
%     if subject < 10 
%         load([file_prefix '0' num2str(subject) file_suffix]);
%     else
%         load([file_prefix num2str(subject) file_suffix]);
%     end
%     
%     disp(['Condition = ' num2str(subject)]);
%     Accuracy1 = mean(Rhythm.AccyAll.matrix(:,:,Baseline + [100:150]), 3)
%     Accuracy2 = mean(Rhythm.AccyAll.matrix(:,:,Baseline + [900:950]), 3)
%     
%     if subject == 3
%         figure;
%         plot(Rhythm.AccyAll.mean);
%     end
%     Result = [Result corr2(squareform(Accuracy1), squareform(Accuracy2))];
% end

%% Bar chart
h = figure;
bar(Result, 'c');
set(gca, 'xticklabel', [3:16]);
g = figure;
bar(mean(Result), 'c');
hold on;
errorb(mean(Result), std(Result)/sqrt(14));
