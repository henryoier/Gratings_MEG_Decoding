function RStep1_RhythmClassifierApplyParallel(SubjectNum)
%function RStep1_RhythmClassifierApplyParallel(SubjectNum)
% SVM Decoding, parallel part
%
%===================================================================
%   Input:
%       SubjectNum      -   subject number(3 - 16)
%--------------------------------------------------------------------
%   Output:
%       mat files       -   decoding accuracy & SVM weight distribution & parameters
%       AccuracyMEG     -   decoding accuracy, condition * condition * time = 6 * 6 * 1901ms
%                           / AccuracyIITT: decoding accuracy, condition * condition * time * time = 6 * 6 * 1901ms * 1901ms
%       Weight          -   SVM parameter, condition * condition * time (* time) = 6 * 6 * 1901ms (* 1901ms)
% 
%====================================================================
%   Version 2.0 -- Oct./2015
%   
%   Writtlen by Sheng Qin(shengqin [AT] mit (DOT) edu)
%

ProjectName = 'sheng';
RhythmMode = 'evoked';      % 'evoked' 'vectorlow' 'vectorhigh' 'single30'
SensorMode = 'all';         % 'all' 'test7' 'batch' 'scouts'
iitt = 'ii';                % 'ii' 'iitt' --- image-image-time-time mode off/on
permutations = 'p10';       % 'p10'
group = 'groupall';    	% 'groupall' 'grouptest' 'group1'
clusterflag = '0';

addpath(genpath('Functions')); % add path of functions

param.trial_bin_size = 87;  % SVM parameter, group size

if SubjectNum < 10
    SubjectName = strcat('grating0', num2str(SubjectNum));
else
    SubjectName = strcat('grating', num2str(SubjectNum));
end

%% parameters
parameters_classifer;
parameters_analysis;

switch ProjectName
    case {'sheng'}
        if strcmp(group,'group1');    CONDA = [2:3];     end
        if strcmp(group,'group2');    CONDA = 4;         end
        if strcmp(group,'group3');    CONDA = 5;         end
        if strcmp(group,'group4');    CONDA = 6;         end
        if strcmp(group,'groupall');  CONDA = [2:6];     end
        if strcmp(group,'grouptest'); CONDA = 2;         end
end

%% Run SVM clissifer
tic
disp(['Subject = ' SubjectName]);
for condA = CONDA
    for condB = 1:(condA-1)
        disp(['Conditions = ' num2str(condA) ' & ' num2str(condB)]);
        if(strcmp(iitt,'ii')) 
            [AccuracyMEG(condA,condB,:),Weight(condA,condB,:,:),param] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
        end
        if(strcmp(iitt,'iitt')) 
            [AccuracyIITT(condA,condB,:,:),Weight(condA,condB,:,:),param] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
        end
    end
end


%% save
file_number = num2str(randi(1000)); % generate a random number
if(strcmp(iitt,'ii'))
    filename = ['Results/' ProjectName '/Accuracy_' SubjectName '_RhmMd' param.RhythmMode '_SnsrMd' param.SensorMode '_' permutations '_' group '_' nowstring '_' file_number];
    param.filename = filename;
    AccuracyMEG(max(CONDA),max(CONDA),1) = 0; % to make dimention of AccuracyMEG be quadrate
    Weight(max(CONDA),max(CONDA),1) = 0;
    save(filename,'AccuracyMEG','Weight','param');
end

if(strcmp(iitt,'iitt'))
    filename = ['Results/' ProjectName '/IITT_' SubjectName '_RhmMd' param.RhythmMode '_SnsrMd' param.SensorMode '_' permutations '_' group '_' nowstring '_' file_number];
    param.filename = filename;
    AccuracyIITT(max(CONDA),max(CONDA),1,1) = 0;
    Weight(max(CONDA),max(CONDA),1,1) = 0;
    save(filename,'AccuracyIITT','Weight','param');
end
disp('All finished!');

toc
