% Morlet wavelets for all signals in brainstorm_db

clear;clc;
ProjectName = 'sheng';   %%%%%
brainstorm_db = '/dataslow/sheng/Project of Sheng/brainstorm_db/sheng/data';
Result_Location = ['Results/sheng/Mat_Time_Frequency/'];
Rhythms = {'total','induced', 'evoked'}; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'

% conditions = {{'1'}};
conditions = {{'1'} {'2'} {'3'} {'4'} {'5'} {'6'}};
ndx_trials = []; % Index of trials while reading parts of trials; Read all trials if it is '[]';

addpath(genpath('Functions'));

Freqs = 50:2:58;
Freq_num = size(Freqs ,2);

HZ = [num2str(min(Freqs)) '-' num2str(max(Freqs)) 'Hz'];

%Morlet design (select temporal/spectral resolution by changing FWHM_tc)
fc = 1; %central frequency, never change this
FWHM_tc = 4; %temporal resolution at central frequency
morlet_design(fc,FWHM_tc); %function return resolutions at different frequencies

Time = -0.3:0.001:1.6;
Time_num = size(Time, 2);

for i_Rhythms = 2:2
    RhythmMode = Rhythms{i_Rhythms};
    
    for i_subject = 10:16
        if i_subject == 4
            continue;
        end;
        
        SubjectName = ['grating' num2str(i_subject,'%.2d')]

        InverseKernel = load_inverse_kernel(brainstorm_db,SubjectName);
        cortex_num = size(InverseKernel, 1);

        for i_condition = 1:length(conditions)
            condition = num2str(i_condition);

            display(['Subject: ' SubjectName ' , Condition: ' condition]);
            filename_tf = ['Timefreq_' SubjectName '_cond' num2str(i_condition) '_' RhythmMode '_' HZ '.mat'];

            [trials trial_num] = load_trials_TF(brainstorm_db, SubjectName, condition, RhythmMode);

            sourcemap = zeros(cortex_num, Time_num);

            disp('start calculating sourcemap');
            parfor i_trial = 1:trial_num
                if ~rem(i_trial, 10);
                    disp(['Calculating sourcemap ' num2str(i_trial) ' of ' num2str(trial_num)]);
                end

                sourcemap_temp = zeros(cortex_num, Time_num);
                coeff = morlet_transform(trials{i_trial}, Time, Freqs, fc, FWHM_tc, 'n');
                coeff = permute(coeff, [1 3 2]);
                for i_Freq = 1:Freq_num
                    sourcemap_temp =  sourcemap_temp + abs(InverseKernel * coeff(:,:,i_Freq)).^2;
                end
                sourcemap_temp = sourcemap_temp / Freq_num;
                sourcemap = sourcemap + sourcemap_temp;
            end
            sourcemap = sourcemap / trial_num;
            
            save([Result_Location filename_tf ],'sourcemap')
        end
    end
end