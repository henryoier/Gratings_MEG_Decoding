function [trial,param_out] = load_trials(brainstorm_db,subject,conditionsA,conditionsB,param,ndx_trials)
%   [DESCRIPTION]
%
%   [trial,param_out] = load_trials(brainstorm_db,subject,conditionsA,conditionsB,param,ndx_trials)
% 
%=============================================
%   input:
%       brainstorm_db   -   brainstorm database
%       subject         -   subject name
%       conditionA/B    -   conditions in brainstorm database, eg: groupA = {'11a' '13a'};
%                           (the function forces equal number of trials in each group)
%       data_type       -   'MEG','GRAD','MAG','EEG', or 'MEG EEG' etc
%       f_lowpass       -   low pass frequency for data filtering
% 
%       SensorMode      -   'all': load 306 channel level trials
%                           'batch': load some channel level trials
%                           'test7': load 7 channel level trials for debug
%                           'scouts': load all source level trials
%       ndx_trials      -   [1:100]; % [1:100]: select first 100 trials; []: select all
%
%----------------------------------------------
%    output:
%       trial           -   trial number
%       param           -   parameters
%        
%============================================== 
%   example:
%
%   brainstorm_db = '/dataslow/sheng/brainstorm_db/sheng/data';
%   subject = 'grating05';
%   conditionsA = {'1'};
%   conditionsB = {'2'};
%   ndx_trials = [];
%   param.data_type = 'MEG';
%   param.f_lowpass = 30;
%   param.SensorMode = 'test7';
%   param.SensorNames = {'MEG2113' 'MEG2111' 'MEG2112' 'MEG1931' 'MEG1932' 'MEG1933' 'MEG2121' };
%
%========================================
%   Adapted from Mingtong
%
%   version 1.0 -- Oct./2015
%
%   written by Sheng Qin(shengqin [AT] mit (DOT) edu)

% handling wrong parameter
if ~exist('ndx_trials')
    ndx_trials = [];
end

data_type = param.data_type;
f_lowpass = param.f_lowpass;
SensorMode = param.SensorMode;
SensorNames = param.SensorNames;

flag_B = str2num(conditionsB{1}); % whether to load the second condition trials

%% find proper channels
if ~strcmp(SensorMode([1:3]),'sco') % if it is not scout(source level)
    
    % get channel index (assume common channel structure per subject)
    
    channelfile = [brainstorm_db, '/', subject, '/@default_study/channel_vectorview306_acc1.mat'];
    file_channel = load(channelfile);
    channel_index = get_channel_index(file_channel,data_type);
    
    % select useful channels
    if length(SensorNames)
        channel_index = [];
        for i_chose_sensor = 1:length(SensorNames)
            for i=1:length(file_channel.Channel)
                if strfind(file_channel.Channel(i).Name, SensorNames{i_chose_sensor})
                    channel_index = [channel_index i];
                    break;
                end
            end
        end
    end
end

%% get filenames
n_conditions = length(conditionsA);
filesA = [];
filesB = [];

for c = 1:n_conditions
    if strcmp(SensorMode([1:3]),'sco')
        fA = dir([brainstorm_db '/' subject '/' conditionsA{c} '/matrix_scout_*.mat']);
    else
        fA = dir([brainstorm_db '/' subject '/' conditionsA{c} '/*trial*.mat']);
    end
    
    %if (~size(fA,1)) error('myError: No files while loading trials A'); end
    
    if(flag_B)
        if strcmp(SensorMode([1:3]),'sco')
            fB = dir([brainstorm_db '/' subject '/' conditionsB{c} '/matrix_scout_*.mat']);
        else
            fB = dir([brainstorm_db '/' subject '/' conditionsB{c} '/*trial*.mat']);
        end
    end
    
    if(flag_B) 
        n(c) = min([length(fA) length(fB)]); %force number of files to be the same
    else
        n(c) = length(fA);
    end
    
    if (length(ndx_trials))
        n(c) = length(ndx_trials);
        fA = fA(ndx_trials);
        if(flag_B)
            fB = fB(ndx_trials); 
        end
    end
    
    for i = 1:n(c)
        fA(i).dir = [brainstorm_db '/' subject '/' conditionsA{c} '/'];
        if(flag_B)
            fB(i).dir = [brainstorm_db '/' subject '/' conditionsB{c} '/']; 
        end
    end
    filesA = [filesA ; fA(1:n(c))];
    if(flag_B) filesB = [filesB ; fB(1:n(c))]; end
end

%% design low pass filter
tempA = load([filesA(1).dir filesA(1).name]);
order = max(100,round(size(tempA.Time,2)/10)); %keep one 10th of the timepoints as model order
Fs = 1000; %hard set sampling frequency 1kHz
h = filter_design('lowpass',f_lowpass,order,Fs,0);

%% load data
for f = 1:length(filesA)
    %disp(['Loading file ' num2str(f) ' of ' num2str(length(filesA))]);
    tempA=load([filesA(f).dir filesA(f).name]);
    if(flag_B) 
        tempB=load([filesB(f).dir filesB(f).name]); 
    end
    if strcmp(SensorMode([1:3]),'sco')
        trial{1}{f} = filter_apply(tempA.Value,h); %smooth over time
    else
        trial{1}{f} = filter_apply(tempA.F(channel_index,:),h); %smooth over time
    end
    trial{1}{f} = single(trial{1}{f});
    if(flag_B)
        if strcmp(SensorMode([1:3]),'sco')
            trial{2}{f} = filter_apply(tempB.Value,h); %smooth over time
        else
            trial{2}{f} = filter_apply(tempB.F(channel_index,:),h); %smooth over time
        end
        trial{2}{f} = single(trial{2}{f});
    end
end

Time = tempA.Time;
if strcmp(SensorMode([1:3]),'sco')
    param.scouts_name = tempA.Description;
end

if(~flag_B)
    trial = trial{1};
end
param.Time = Time;
param_out = param;
