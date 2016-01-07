% creating sourcemap files for all subjects and conditios

clear;clc;
ProjectName = 'sheng';   %%%%%
brainstorm_db = '/dataslow/sheng/Project of Sheng/brainstorm_db/sheng/data/';
InverseKernelType = 'wMNE';

sourcemap_db = '/dataslow/sheng/Project of Sheng/Results/sheng/Mat_Time_Frequency/';

for i_subject = 3:16
    if i_subject == 4
        continue;
    end
    
    example_file = dir([brainstorm_db 'grating' num2str(i_subject, '%.2d') '/1/*time*160105*']);
    load([brainstorm_db 'grating' num2str(i_subject, '%.2d') '/1/' example_file(1).name]);
    for i_condition = 1:6
        disp(['Subject' num2str(i_subject) ' Condition' num2str(i_condition)]);
        load([sourcemap_db 'Timefreq_grating' num2str(i_subject, '%.2d')...
            '_cond' num2str(i_condition) '_induced_24-32Hz_' InverseKernelType '.mat']);
        Comment = ['Induced 24-32Hz_' InverseKernelType];
        DataFile = [];
        TF = sourcemap;
        save([brainstorm_db 'grating' num2str(i_subject, '%.2d') '/' num2str(i_condition) '/' InverseKernelType '__' example_file(1).name ]);
    end
end
%% changing names
for i_subject = 3:16
    if i_subject == 4
        continue;
    end
    
    for i_condition = 1:6
        disp(['Subject' num2str(i_subject) ' Condition' num2str(i_condition)]);
        file = dir([brainstorm_db 'grating' num2str(i_subject, '%.2d') '/' num2str(i_condition) '/*average*']);
        load([brainstorm_db 'grating' num2str(i_subject, '%.2d') '/' num2str(i_condition) '/' file(1).name]);
        Comment = 'Evoked';
        save([brainstorm_db 'grating' num2str(i_subject, '%.2d') '/' num2str(i_condition) '/' file(1).name]);
    end
end