function RStep0A_RhythmAnalysis(in_subject)
%   Rhythm classifier pre-analysis
%
%   RStep0A_RhythmAnalysis(in_subject) 
%
%=================================================
%   input:
%       in_subject  -   label of subjects
%
%-------------------------------------------------
%   ouput:
%       mat files   -   time-frequency power
%                       frequency * time = 100 Hz * 1901 ms;
%
%==================================================
%   example:
%
%   in_subject = [12]; % [3:16]
%
%===================================================
%   adapted from Mingtong
%
%   version 1.0 -- Oct./2015
%   
%   written by Sheng Qin(shengqin [AT] mit (DOT) edu)
%

clc;
addpath(genpath('Functions'));
results_location = ['Results/sheng/Fig0_Timefreq'];
ProjectName = 'sheng'; 
RhythmMode = '1_100'; 
% conditions = {{'1'}};
conditions = {{'1'} {'2'} {'3'} {'4'} {'5'} {'6'}};
ndx_trials = []; % Index of trials while reading parts of trials; Read all trials if it is '[]';

for i_subject = in_subject
    
    SubjectName = ['grating' num2str(i_subject,'%.2d')];
    
    % Different subject has different sensor with strongest response.
    SubjectReferToSensor = {'','','MEG2113','MEG2011','MEG2032','MEG2113','MEG2123','MEG2023','MEG1912','MEG1923'};
    SubjectReferToSensor = [SubjectReferToSensor 'MEG1923','MEG1923','MEG2032','MEG2032','MEG2342','MEG2321'];
    %SensorMode = 'all';
    SensorMode = SubjectReferToSensor{i_subject};    % 'all' 'single' 'test' 'batch'
    
    clusterflag = 0; % run in local computer, not in openmind computer cluster
    parameters_analysis; % ctrl+D to open this '.m' file
    param.ndx_trials = ndx_trials; % save all parameters in results
    
    for i_condition = 1:length(conditions)
        
        fprintf(1, '\n\n'); display(['Subject: ' SubjectName ' , Condition: ' num2str(i_condition) ]);
        Freqs = OPTIONS.Freqs;
        HZ = [num2str(min(OPTIONS.Freqs)) '-' num2str(max(OPTIONS.Freqs)) 'Hz'];
        filename_tf = ['Timefreq_' SubjectName '_cond' num2str(i_condition) '_' HZ '_' SensorMode];
        
        %% load data
        % structure of 'trials': 196 cells; in each cell, channels * times = 306*1601
        display('Loading trials.');
        
        % The function of load_trials can load one subject, two conditions'
        % data, {'0'} means only to load one condition while ignoring the
        % second condition.
        [trials,param] = load_trials(param.brainstorm_db,SubjectName,conditions{i_condition},{'0'},param,ndx_trials);
        Time = param.Time;
        n_trials = length(trials); % n_trials: number of trials
        p.n_trials = n_trials;
        
        %% correct for baseline standard
        baseline_range = Time<0;
        for i_trial = 1:n_trials
            trials{i_trial} = trials{i_trial} ./ repmat( std(trials{i_trial}(:,baseline_range)')',1,size(Time,2) );
        end
        
        %% evoked -- compute trial_avg, TF_evoked = TF(trial_avg)
        fprintf(1, '\n'); disp('Timefreq Evoked start!');
        evoked_sum = zeros(size(trials{1}));
        for i_trial = 1:n_trials
            evoked_sum = evoked_sum + trials{i_trial};
        end
        trial_avg = evoked_sum / n_trials;
        Timefreq.evoked = grating_timefreq(trial_avg, Time, OPTIONS, RhythmMode);
        
        %% induced -- compute trial_induced{i} = trial{i} - trial_avg, TimeFreq_induced = average[ TimeFreq(trial_induced{i}) ]
        
        fprintf(1, '\n'); disp('Timefreq Induced start!');
        Timefreq_induced_sum = zeros( size( grating_timefreq(trials{1}, Time, OPTIONS, RhythmMode) ) ); % 100_Freqs * 1901_Time
        for i_trial = 1:n_trials
            if rem(i_trial,10)==1
                disp(['Time-Frequency transform: ' num2str(i_trial) ' / ' num2str(n_trials)]);
            end
            trials_induced{i_trial} = trials{i_trial} - trial_avg;
            Timefreq_tmp = grating_timefreq(trials_induced{i_trial}, Time, OPTIONS, RhythmMode);
            Timefreq_induced_sum = Timefreq_induced_sum + Timefreq_tmp;
        end
        Timefreq.induced = Timefreq_induced_sum / n_trials;
        
        %% total -- compute TimeFreq_total = average[ TimeFreq(trial) ]
        fprintf(1, '\n'); disp('Timefreq Total start!');
        Timefreq_total_sum = zeros( size( grating_timefreq(trials{1}, Time, OPTIONS, RhythmMode) ) ); % 100_Freqs * 1901_Time
        for i_trial = 1:n_trials
            if rem(i_trial,10)==1
                disp(['Time-Frequency transform: ' num2str(i_trial) ' / ' num2str(n_trials)]);
            end
            Timefreq_tmp = grating_timefreq(trials{i_trial}, Time, OPTIONS, RhythmMode);
            Timefreq_total_sum = Timefreq_total_sum + Timefreq_tmp;
        end
        Timefreq.total = Timefreq_total_sum / n_trials;
        
        %% percentage change transformation
        baseline.range = find(Time<0);
        baseline.Time = Time(baseline.range);
        baseline.Timefreq.evoked = Timefreq.evoked(:,baseline.range,:);
        baseline.Timefreq.induced = Timefreq.induced(:,baseline.range,:);
        baseline.Timefreq.total = Timefreq.total(:,baseline.range,:);
        for i_trial = 1:length(Freqs)
            baseline.mean.evoked(i_trial,:) = mean(baseline.Timefreq.evoked(i_trial,:), 2);
            baseline.mean.induced(i_trial,:) = mean(baseline.Timefreq.induced(i_trial,:), 2);
            baseline.mean.total(i_trial,:) = mean(baseline.Timefreq.total(i_trial,:), 2);
        end
        base.evoked = repmat(baseline.mean.evoked,size(Time));
        base.induced = repmat(baseline.mean.induced,size(Time));
        base.total = repmat(baseline.mean.total,size(Time));
        Timefreq.evoked_percentage = (Timefreq.evoked - base.evoked) ./ base.evoked;
        Timefreq.induced_percentage = (Timefreq.induced - base.induced) ./ base.induced;
        Timefreq.total_percentage = (Timefreq.total - base.total) ./ base.total;
        
        %% save
        display('Saving Timefreq');
        save( [results_location '/mat/' filename_tf ],'Timefreq','Time','Freqs','param');
    end
end
disp('All finished!');