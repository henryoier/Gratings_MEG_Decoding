function [ trials file_num ] = load_trials(brainstorm_db,subject,condition,RhythmMode)
%   [DESCRIPTION]
%
%   [trials] = load_trials(brainstorm_db,subject,conditions)
% 
%=============================================
%   input:
%       brainstorm_db   -   brainstorm database
%       subject         -   subject name
%       condition       -   conditions in brainstorm database, eg: groupA = {'11a' '13a'};
%                           (the function forces equal number of trials in each group)
%       RhythmMode      -   signal type ('Total', 'Evoked', 'Induced')
%----------------------------------------------
%    output:
%       trial           -   trial number
%        
%============================================== 
%   example:
%
%   brainstorm_db = '/dataslow/sheng/brainstorm_db/sheng/data';
%   subject = 'grating05';
%   condition = '1';
%   ndx_trials = [];
%========================================
%   version 1.0 -- Dec./2015
%
%   written by Sheng Qin(shengqin [AT] mit (DOT) edu)

% handling wrong parameter

addpath(genpath('Functions'));
if strcmp(RhythmMode, 'Evoked')
    f_lowpass = 30;
else
    f_lowpass = 200;
end

%% get channel index
channelfile = [brainstorm_db, '/', subject, '/@default_study/channel_vectorview306_acc1.mat'];
file_channel = load(channelfile);
channel_index = get_channel_index(file_channel,'MEG');
     
%% get filenames
switch RhythmMode
    case {'total'}
        files = dir([brainstorm_db '/' subject '/' condition '/data*trial*.mat']);
    case {'evoked'}
        files = dir([brainstorm_db '/' subject '/' condition '/data*average*.mat']);
    case {'induced'}
        files = dir([brainstorm_db '/' subject '/' condition '/data*1512*.mat']);
end
file_num = size(files, 1);

for i=1:file_num
    files(i).dir = [brainstorm_db '/' subject '/' condition '/'];
end

%% design low pass filter
tempA = load([files(1).dir files(1).name]);
order = max(100,round(size(tempA.Time,2)/10)); %keep one 10th of the timepoints as model order
Fs = 1000; %hard set sampling frequency 1kHz
h = filter_design('lowpass',f_lowpass,order,Fs,0);

%% load data
parfor f = 1:length(files)
    if ~rem(f, 10);
        disp(['Loading file ' num2str(f) ' of ' num2str(length(files))]);
    end
    temp = load([files(f).dir files(f).name]);
    trials{f} = single(filter_apply(temp.F(channel_index,:),h)); %smooth over time);
end
