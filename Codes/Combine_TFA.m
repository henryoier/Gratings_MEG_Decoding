% This function combines AccuracyMatrix of different RhythmMode
% in different frequencies.
%
%=============================================================
%   Input:
%       RhythmMode  -   'isingle','esingle','single'
%
%-------------------------------------------------------------
%   Output:
%       Mat files   -   Which stores a matrix
%                       Frequency * 6 * 6 * Time
%=============================================================
% 
%   Written by Sheng Qin (shengqin [AT] mit (DOT) edu)
%
%   Version 1.0 -- Oct. 2015
%

ProjectName = 'sheng';
RhythmMode = 'single';

AccuracyAll = zeros(80,6,6,1901);

for Frequency = [2:2:80]
    
    file_location = ...
        [ '/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA/Accuracy_gratings_' RhythmMode 's'];
    
    file_name = [];
    file_name = [file_name dir( [file_location '/Accuracy_grating*_RhmMd'...
        num2str(RhythmMode) num2str(Frequency) '_SnsrMdall*.mat'])];
    
    Accuracy_temp = zeros(6,6,1901);
    for Subject = 1:length(file_name)
        load([file_location, '/', file_name(Subject).name]);
        Accuracy_temp = Accuracy_temp + AccuracyMEG;
    end
    
    AccuracyAll(Frequency,:,:,:) =  Accuracy_temp / length(file_name);    
end

clear Accuracy_temp AccuracyMEG file_name frequency 

save( [file_location '/Accuracy_14gratings316_RhmMd' RhythmMode '2-80_SnsrMdall_p100_groupall.mat']);
disp('All finished!');
