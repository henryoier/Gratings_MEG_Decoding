%   RStep0B_RhythmAnalysis_CombineSubjects
%
%   This function works after running RStep0A 
%================================================
%   usage:
%       1. Combine subjects;
%           output  -   mat files
%       2. Plot time-frequency power map;
%           output  -   figures
%================================================
%   Adapted from Mingtong
%
%   Version 1.0 -- Oct./2015
%
%   written by Sheng Qin(shengqin [AT] mit (DOT) edu)
%

clear; clc; close all;
ProjectName = 'sheng';

flag_combine = 0;  % flag '1': combine subjects and save mat;
flag_plot = 1;      % flag '1': plot time-frequency-power;
flag_save_jpg = 1;

files_number = 14; % how many files to be loaded/combined. (To make sure the script runs correctly)
in_condition = [1:6];   % [1:6]: 1~6 conditions will be analyzed
results_location = ['/dataslow/sheng/Project of Sheng/Results/sheng/Fig0_Timefreq'];

% for i_subject = [0]  SubjectName = '14gratings';
for i_subject = [3:16]  SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
    
    for i_condition = in_condition
        filename_tf = [ 'Timefreq_' SubjectName '_cond' num2str(i_condition) '_1-100Hz' ];
%         filename_tf = [ 'Timefreq_' SubjectName '_condall_1-100Hz' ];

        %% combine subjects
        if flag_combine
            if ~strcmp(SubjectName([1:7]),'grating') error('Wrong subject name!'); end
            files = dir([results_location '/mat/Timefreq_grating*_cond' num2str(i_condition) '_1-100Hz_MEG*']);
            disp(['Condition: ' num2str(i_condition) ' , Files: ' num2str(length(files)) ]);
            if length(files)==files_number
                % initialize
                file_tmp = load([ results_location '/mat/' files(1).name ]);
                param = file_tmp.param;
                Time = file_tmp.Time;
                Freqs = file_tmp.Freqs;
                Timefreq_sum.evoked = file_tmp.Timefreq.evoked;
                Timefreq_sum.induced = file_tmp.Timefreq.induced;
                Timefreq_sum.total = file_tmp.Timefreq.total;
                Timefreq_sum.evoked_percentage = file_tmp.Timefreq.evoked;
                Timefreq_sum.induced_percentage = file_tmp.Timefreq.induced;
                Timefreq_sum.total_percentage = file_tmp.Timefreq.total;
                % other files
                for i_file = 2:files_number
                    file_tmp = load([ results_location '/mat/' files(i_file).name ]);
                    Timefreq_sum.evoked = Timefreq_sum.evoked + file_tmp.Timefreq.evoked;
                    Timefreq_sum.induced = Timefreq_sum.induced + file_tmp.Timefreq.induced;
                    Timefreq_sum.total = Timefreq_sum.total + file_tmp.Timefreq.total;
                    Timefreq_sum.evoked_percentage = Timefreq_sum.evoked_percentage + file_tmp.Timefreq.evoked_percentage;
                    Timefreq_sum.induced_percentage = Timefreq_sum.induced_percentage + file_tmp.Timefreq.induced_percentage;
                    Timefreq_sum.total_percentage = Timefreq_sum.total_percentage + file_tmp.Timefreq.total_percentage;
                end
                Timefreq.evoked = Timefreq_sum.evoked / files_number;
                Timefreq.induced = Timefreq_sum.induced / files_number;
                Timefreq.total = Timefreq_sum.total / files_number;
                Timefreq.evoked_percentage = Timefreq_sum.evoked_percentage / files_number;
                Timefreq.induced_percentage = Timefreq_sum.induced_percentage / files_number;
                Timefreq.total_percentage = Timefreq_sum.total_percentage / files_number;
                
                save( [results_location '/mat/' filename_tf ],'Timefreq','Time','Freqs','param');
            else
                error('Wrong file numbers!');
            end
        else
            file = dir([results_location '/mat/Timefreq_' SubjectName '_cond' num2str(i_condition) '_1-100Hz_MEG*']);
            if length(file)==1
                filename_tf = file.name;
            else
                error('Wrong loading!');
            end
            load([results_location '/mat/' filename_tf ]);
        end
        
        %% plot
        if flag_plot
            % evoked, percentage change
            title_text = [SubjectName '     Condition: ' num2str(30*(i_condition-1)) '^{\circ}     Power     Evoked (P)'];
            cmax = max(max(abs(Timefreq.evoked_percentage)));
%             cmax = 311;
            h.evoked_percentage = RStep0Z_subfunction_plot(Timefreq.evoked_percentage,Time,Freqs,flag_save_jpg,title_text,cmax);
            if flag_save_jpg
                print(h.evoked_percentage,[results_location '/fig/' filename_tf '_evoked___max' num2str(cmax,3) '.jpg'],'-djpeg','-r0');
                close(h.evoked_percentage);
            end
            
            % induced, percentage change
            title_text = [SubjectName '     Condition: ' num2str(30*(i_condition-1)) '^{\circ}     Power     Induced (P)'];
            cmax = max(max(abs(Timefreq.induced_percentage)));
%             cmax = 2.1;
            h.induced_percentage = RStep0Z_subfunction_plot(Timefreq.induced_percentage,Time,Freqs,flag_save_jpg,title_text,cmax);
            if flag_save_jpg
                print(h.induced_percentage,[results_location '/fig/' filename_tf '_induced___max' num2str(cmax,3) '.jpg'],'-djpeg','-r0');
                close(h.induced_percentage);
            end
            
            % total, percentage change
            title_text = [SubjectName '     Condition: ' num2str(30*(i_condition-1)) '^{\circ}     Power     Total (P)'];
            cmax = max(max(abs(Timefreq.total_percentage)));
%             cmax = 2.5;
            h.total_percentage = RStep0Z_subfunction_plot(Timefreq.total_percentage,Time,Freqs,flag_save_jpg,title_text,cmax);
            if flag_save_jpg
                print(h.total_percentage,[results_location '/fig/' filename_tf '_total___max' num2str(cmax,3) '.jpg'],'-djpeg','-r0');
                close(h.total_percentage);
            end
            
%             % total raw
%             h.total = RStep0_RhythmAnalysis_plot(Timefreq.total,Time,Freqs);
%             title_text = [SubjectName '     Condition: ' num2str(30*(i_condition-1)) '^{\circ}     Power     Total'];
%             cmax = max(max(abs(Timefreq.total)));
%             % cmax = 310;
%             h.evoked_percentage = RStep0Z_subfunction_plot(Timefreq.total,Time,Freqs,flag_save_jpg,title_text,cmax);
%             if flag_save_jpg
%                 print(h.evoked_percentage,[file_location '/' filename_tf '_total_raw___max' num2str(cmax,3) '.jpg'],'-djpeg','-r0');
%                 close(h.evoked_percentage);
%             end
        end
    end
end
disp('All finished!');


%% Combine conditions: average all conditions
% clear;clc;
% file_location = 'C:\Users\Mingtong\OneDrive\Mingtong\RhythmClassifier\Results\fang02\Fig2_Timefreq';
% filename_tf = [ 'Timefreq_14gratings_condall_1-100Hz' ];
% files = dir([file_location '/mat/Timefreq_14gratings_cond*_1-100Hz.mat']);
% files_number = 6;
%
% if length(files)==files_number
%     % initialize
%     file_tmp = load([ file_location '/mat/' files(1).name ]);
%     param = file_tmp.param;
%     Time = file_tmp.Time;
%     Freqs = file_tmp.Freqs;
%     Timefreq_sum.evoked = file_tmp.Timefreq.evoked;
%     Timefreq_sum.induced = file_tmp.Timefreq.induced;
%     Timefreq_sum.total = file_tmp.Timefreq.total;
%     Timefreq_sum.evoked_percentage = file_tmp.Timefreq.evoked;
%     Timefreq_sum.induced_percentage = file_tmp.Timefreq.induced;
%     Timefreq_sum.total_percentage = file_tmp.Timefreq.total;
%     % others
%     for i_file = 2:files_number
%         file_tmp = load([ file_location '/mat/' files(i_file).name ]);
%         Timefreq_sum.evoked = Timefreq_sum.evoked + file_tmp.Timefreq.evoked;
%         Timefreq_sum.induced = Timefreq_sum.induced + file_tmp.Timefreq.induced;
%         Timefreq_sum.total = Timefreq_sum.total + file_tmp.Timefreq.total;
%         Timefreq_sum.evoked_percentage = Timefreq_sum.evoked_percentage + file_tmp.Timefreq.evoked_percentage;
%         Timefreq_sum.induced_percentage = Timefreq_sum.induced_percentage + file_tmp.Timefreq.induced_percentage;
%         Timefreq_sum.total_percentage = Timefreq_sum.total_percentage + file_tmp.Timefreq.total_percentage;
%     end
%     Timefreq.evoked = Timefreq_sum.evoked / files_number;
%     Timefreq.induced = Timefreq_sum.induced / files_number;
%     Timefreq.total = Timefreq_sum.total / files_number;
%     Timefreq.evoked_percentage = Timefreq_sum.evoked_percentage / files_number;
%     Timefreq.induced_percentage = Timefreq_sum.induced_percentage / files_number;
%     Timefreq.total_percentage = Timefreq_sum.total_percentage / files_number;
%
%     save( [file_location '/mat/' filename_tf ],'Timefreq','Time','Freqs','param');
% end
