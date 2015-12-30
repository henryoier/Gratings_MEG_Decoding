% Morlet wavelets for all signals in brainstorm_db

clear;clc;
ProjectName = 'sheng';   %%%%%
Result_Location = ['Results/sheng/Mat_Time_Frequency'];
RhythmMode={'total', 'evoked','induced'}; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'

% conditions = {{'1'}};
conditions = {{'1'} {'2'} {'3'} {'4'} {'5'} {'6'}};
ndx_trials = []; % Index of trials while reading parts of trials; Read all trials if it is '[]';
Subjects = 3:16;

addpath(genpath('Functions'));

Freqs = 50:1:58;
HZ = [num2str(min(Freqs)) '-' num2str(max(Freqs)) 'Hz'];

%Morlet design (select temporal/spectral resolution by changing FWHM_tc)
fc = 1; %central frequency, never change this
FWHM_tc = 4; %temporal resolution at central frequency
morlet_design(fc,FWHM_tc); %function return resolutions at different frequencies

Time = -0.3:0.001:1.6;

for i_subject = Subject
    SubjectName = ['grating' num2str(i_subject,'%.2d')];
    
    parameters_analysis; % ctrl+D to open this '.m' file
    param.ndx_trials = ndx_trials; 
    
    InverseKernel = randn(15001,306);
    
    for i_condition = 1:length(conditions)
        display(['Subject: ' SubjectName ' , Condition: ' num2str(i_condition) ]);
        
        filename_tf = ['Timefreq_' SubjectName '_cond' num2str(i_condition) '_' HZ];
        
        Coeff = morlet_transform(Trial,Time,f,fc,FWHM_tc,'n');
    end
end