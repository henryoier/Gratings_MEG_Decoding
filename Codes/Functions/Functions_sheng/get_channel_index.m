function [channel_index] = get_channel_index(file_channel,data_type)
%
%   [channel_index] = get_channel_index(file_channel,data_type)
%
%=================================================
%   input:
%       file_channel    -   the file containing information of channels
%       data_type       -   'MEG','GRAD','MAG','EEG', or 'MEG EEG' etc
%
%--------------------------------------------------
%   output:
%       channel_index   -   indexes of channels that is active        
%    
%==================================================
%   example:
%       file_channel = load( ['/dataslow/sheng/Project of Sheng/brainstorm_db/sheng/data/subject03/@default_study/channel_vectorview306.mat'] );
%       data_type = 'MEG';
%
%==================================================
%   adapted from Mingtong
%
%   version 1.0 -- Oct./2015
%
%   written by Sheng Qin(shengqin [AT] mit (DOT) edu)
%

channel_index = [];

if strfind(data_type,'MEG')
    ndx = find_channels(file_channel.Channel,'MEG');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'GRAD')
    ndx = find_channels(file_channel.Channel,'GRAD');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'MAG')
    ndx = find_channels(file_channel.Channel,'MAG');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'EEG')
    ndx = find_channels(file_channel.Channel,'EEG');
    channel_index = [channel_index ndx];
end
if strfind(data_type,'MAGr74')
    ndx = find_channels(file_channel.Channel,'MAG');
    ndx = sort(ndx(randperm(102,74)));          %select only 74 sensors randomly
    channel_index = ndx;                        %do not keep any other values (aka MAG)
end
if strfind(data_type,'GRADr74')
    ndx = find_channels(file_channel.Channel,'GRAD');
    ndx = sort(ndx(randperm(204,74)));          %select only 74 sensors randomly
    channel_index = ndx                         %do not keep any other values (aka MAG)
end
if strfind(data_type,'GRADr74spaceopt')
    ndx = find_channels(file_channel.Channel,'GRAD');
    if rand>0.5
        ndx = ndx(1:2:end);
    else
        ndx = ndx(2:2:end);
    end
    ndx = sort(ndx(randperm(102,74)));          %select only 74 sensors randomly
    channel_index = ndx;                        %do not keep any other values (aka MAG)
end

channel_index = unique(channel_index);