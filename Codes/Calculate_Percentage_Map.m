% Calculate sourcemap data of percentage

clear;clc;
ProjectName = 'sheng';   %%%%%
brainstorm_db = '/dataslow/sheng/Project of Sheng/brainstorm_db/sheng/data/';

files = dir([brainstorm_db 'Group_analysis/@intra/timefreq_average*.mat']);

count = 0;
for i_file=1:length(files)
    if (strfind(files(i_file).name, 'grating') | strfind(files(i_file).name, '_avg'))
        continue;
    end
    
    load([brainstorm_db 'Group_analysis/@intra/' files(i_file).name]);
    Comment = [Comment ' Percentage']
    for row=1:size(TF, 1)
        base = mean(TF(row, 100:300));
        TF(row,:) = (TF(row, :) - base)/base;
    end
    save([brainstorm_db 'Group_analysis/@intra/Percentage ' files(i_file).name]);
end
