function [Accuracy,Weight,param_out] = svm_contrast_conditions_perm(subject,conditionsA,conditionsB,param)
% function [Accuracy,Weight,param_out] = svm_contrast_conditions_perm(subject,conditionsA,conditionsB,param)
%
% Apply SVM classifier on MEG trials with supervised learning. Uses trial subaverages and permutations
%
% RhythmMode Method =  
%       'evoked':
%                   raw 352 trials -> 30Hz low-pass filter -> standardize -> average every 87 trials -> SVM (3 train, 1 test)
%       'vectorhigh' / 'vectorlow' / 'single30' (50~58Hz / 24~32Hz / 30Hz): 
%                   352 trials -> 200Hz LP filter -> std -> time-frequency (SVM vector *5 / *5 / *1) -> average every 87 trials -> percentage -> SVM (3 train, 1 test)
%       'evectorhigh' / 'evectorlow' / 'esingle30': 
%                   352 trials -> 200Hz LP filter -> std -> average every 87 trials -> time-frequency (SVM vector *5 / *5 / *1) -> percentage  -> SVM (3 train, 1 test)
%       'ivectorhigh' / 'ivectorlow' / 'isingle30': 
%                   352 trials -> 200Hz LP filter -> std -> induced -> time-frequency (SVM vector *5 / *5 / *1) -> average every 87 trials -> percentage -> SVM (3 train, 1 test)
%
% % Example:
%   clear; clc;
%   subject = 'grating05';
%   conditionsA = {'1'};
%   conditionsB = {'2'};
%   param.brainstorm_db = 'I:\Mingtong\MEG_data\brainstorm_db/fang02/data';
%   param.data_type = 'MEG';
%   param.num_permutations = 3;
%   param.trial_bin_size = 87;
%   param.f_lowpass = 30;
%   param.RhythmMode = 'evoked';
%   param.SensorMode = 'test7';
%   param.SensorNames = {'MEG2113' 'MEG2111' 'MEG2112' 'MEG1931' 'MEG1932' 'MEG1933' 'MEG2121' };
%   param.iitt = 'ii';
%   param.trial_number = 9999;
%
% Author: Dimitrios Pantazis & Mingtong Fang


% initialize
num_permutations = param.num_permutations;
brainstorm_db = param.brainstorm_db;
RhythmMode = param.RhythmMode;
trial_bin_size = param.trial_bin_size;

%% load data (force equal number of trials per condition) (single float)
[trial_raw,param] = load_trials(brainstorm_db,subject,conditionsA,conditionsB,param);
Time = param.Time;

ntimes = size(trial_raw{1}{1},2);
ntrials = min([length(trial_raw{1}) length(trial_raw{2})]);
if ntrials < param.trial_number
    param.trial_number = ntrials;
end


%% correct for baseline std
baseline_range = Time<0;
for i = 1:2 %for both groups
    for j = 1:ntrials
        trial_raw{i}{j} = trial_raw{i}{j} ./ repmat( std(trial_raw{i}{j}(:,baseline_range)')',1,ntimes );
    end
end
clear i j;



%% convert total response to induced response
if strcmp(param.RhythmMode(1),'i')
    param.is_induced = 'yes';
    for i = 1:2 %for both groups
        trial_sum = zeros(size(trial_raw{i}{1}));
        for j = 1:ntrials
            trial_sum = trial_sum + trial_raw{i}{j};
        end
        trial_avg = trial_sum / ntrials;
        
        for j = 1:ntrials
            trial_induced{i}{j} = trial_raw{i}{j} - trial_avg;
        end
    end
    trial_raw = trial_induced;
    clear trial_induced i j;
else
    param.is_induced = 'no';
end


%% transform to frequency series or not change
if ( strcmp(param.RhythmMode, 'evoked') | strcmp(param.RhythmMode(1), 'e') )
    param.is_onetrial_rhythm = 'no';
else
    param.is_onetrial_rhythm = 'yes'; % total or induced
    trial_raw = trial2trial_g(trial_raw,Time,param.OPTIONS,param.RhythmMode);
end
nchannels = size(trial_raw{1}{1},1);



%% get labels for train and test groups
nsamples = floor(ntrials/param.trial_bin_size);
param.trial_cluster_number = nsamples;
samples = reshape([1:nsamples*trial_bin_size],trial_bin_size,nsamples)';
train_label = [ones(1,nsamples-1) 2*ones(1,nsamples-1)];
test_label = [1 2];

if strcmp(param.iitt,'ii') AccuracyMEG_sum = zeros(1,ntimes); end
if strcmp(param.iitt,'iitt') AccuracyIITT_sum = zeros(ntimes,ntimes); end
Weight_sum = zeros(nchannels,ntimes);
rng('shuffle'); % seeds the random number generator based on the current time

%% perform decoding
for p = 1:num_permutations
    if rem(p,10)==1
        disp(['permutaions: ' num2str(p) ' / ' num2str(num_permutations)]);
    end

    %randomize samples
    perm_ndxA = randperm(nsamples*trial_bin_size);
    perm_ndxB = randperm(nsamples*trial_bin_size);
    perm_samplesA = perm_ndxA(samples);
    perm_samplesB = perm_ndxB(samples);
    
    %create train samples: 6_train_number * 306_sensors * 1901_Time
    train_trialsA = average_structure2(trial_raw{1}(perm_samplesA(1:nsamples-1,:)));
    train_trialsB = average_structure2(trial_raw{2}(perm_samplesB(1:nsamples-1,:)));
    train_trials = [train_trialsA;train_trialsB];
    %create test samples
    test_trialsA = double(average_structure(trial_raw{1}(perm_samplesA(end,:))));
    test_trialsB = double(average_structure(trial_raw{2}(perm_samplesB(end,:))));
    test_trials = reshape([test_trialsA test_trialsB],[nchannels,ntimes,2]);
    test_trials = permute(test_trials,[3 1 2]);
    
    
    % evoked rhythm transformation
    if ( strcmp(RhythmMode(1:4),'evec') | strcmp(RhythmMode(1:4),'esin') )
        param.is_avgtrial_rhythm = 'yes';
        for i = 1:size(train_trials,1)
            z = size(train_trials(i,:,:));
            Data = reshape(train_trials(i,:,:),[z(2:end) 1]);
            train_trials_new(i,:,:) = grating_timefreq(Data, Time, param.OPTIONS, RhythmMode);
        end
        train_trials = train_trials_new; clear train_trials_new i z Data;
        
        for i = 1:size(test_trials,1)
            z = size(test_trials(i,:,:));
            Data = reshape(test_trials(i,:,:),[z(2:end) 1]);
            test_trials_new(i,:,:) = grating_timefreq(Data, Time, param.OPTIONS, RhythmMode);
        end
        test_trials = test_trials_new; clear test_trials_new i z Data;
    else
        param.is_avgtrial_rhythm = 'no';
    end
    
    
    % percentage change
    if strcmp(param.RhythmMode,'evoked')  % do not change
        param.is_percentage = 'no';
    else
        param.is_percentage = 'yes';
        for i_sample = 1:size(train_trials,1)
            for i_vector = 1:size(train_trials,2)
                baseline_mean = repmat( mean(train_trials(i_sample,i_vector,baseline_range),3), 1, 1, ntimes );
                train_trials(i_sample,i_vector,:) = (train_trials(i_sample,i_vector,:) - baseline_mean ) ./ baseline_mean;
            end
        end
        for i_sample = 1:size(test_trials,1)
            for i_vector = 1:size(test_trials,2)
                baseline_mean = repmat( mean(test_trials(i_sample,i_vector,baseline_range),3), 1, 1, ntimes );
                test_trials(i_sample,i_vector,:) = (test_trials(i_sample,i_vector,:) - baseline_mean ) ./ baseline_mean;
            end
        end
    end

        
    if (p == 1) param.SVM_vector_length = size(train_trials,2); end
    for tndx_train = 1:ntimes
        
        if strcmp(param.iitt,'ii')  % ncondtitions-ncondtitions-time matric
            % libsvm-3.18
            model = svmtrain(train_label',train_trials(:,:,tndx_train),'-s 0 -t 0 -q');
            [predicted_label, Accuracy_tmp, decision_values] = svmpredict(test_label', test_trials(:,:,tndx_train), model);
            AccuracyMEG_sum(tndx_train) = AccuracyMEG_sum(tndx_train) + Accuracy_tmp(1);
        end
        
        if strcmp(param.iitt,'iitt') % ncondtitions-ncondtitions-time-time matric
            model = svmtrain(train_label',train_trials(:,:,tndx_train),'-s 0 -t 0 -q');
            for tndx_test = 1:ntimes
                [predicted_label, Accuracy_tmp, decision_values] = svmpredict(test_label', test_trials(:,:,tndx_test), model);
                AccuracyIITT_sum(tndx_train,tndx_test) = AccuracyIITT_sum(tndx_train,tndx_test) + Accuracy_tmp(1);
            end
        end

        % save weight parameters of SVM
        Weight_sum(:,tndx_train) = Weight_sum(:,tndx_train) + (model.sv_coef' * model.SVs)';
%         model.sv_coef' * model.SVs * test_trials(:,:,tndx_train)' - 1; % group 1 if value < 1;
    end
end


if strcmp(param.iitt,'ii') Accuracy = AccuracyMEG_sum / num_permutations; end
if strcmp(param.iitt,'iitt') Accuracy = AccuracyIITT_sum / num_permutations; end
Weight = Weight_sum / num_permutations;
param_out = param;
