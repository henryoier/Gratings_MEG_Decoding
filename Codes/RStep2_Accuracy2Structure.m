%
% Transform original resutls to ACCY structure and save
% Modified in analytical groups
%==========================================================================
% process:
%       one decoding accuracy file
% ouput:
%       one decoding accuracy file with different structure
%==========================================================================
% Written by Sheng Qin (shengqin [AT] mit (DOT) edu)
% 
% Version 1.0 -- Oct. 2015 
%

clear;clc;
iitt = 'ii'; % 'ii'

for single_number = [ 2:2:80 ] RhythmMode = ['single' num2str(single_number)]; % 'evoked', 'beta', 'gamma', 'test',['single' num2str(single_number)]
%for single_number = [0] RhythmMode = 'evectorhigh'; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
    permutations = 'p100';
    ProjectName = ['sheng'];
    
    file_location = [ '/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA_single/Accuracy_gratings_singles'  ];
    
    for i_subject = [3:16];   SubjectName = ['grating' num2str(i_subject, '%0.2d') ];
        disp([ 'Subject: ' SubjectName ' , Rhythm: ' RhythmMode])
        SensorMode = 'all'; % 'batch' 'all' 'scouts'
        
        if strcmp(iitt, 'ii')
            file_name = dir( [ file_location '/Accuracy_' SubjectName '_RhmMd' RhythmMode '_SnsrMd' SensorMode '_' permutations '_groupall*.mat'] );
            if (length(file_name) ~= 1)
                [ file_location '/Accuracy_' SubjectName '_RhmMd' RhythmMode '_SnsrMd' SensorMode '_' permutations '_groupall.mat']
                error('myError: wrong loading!');
            end
            load([file_location, '/', file_name.name]);
            Accuracy = AccuracyMEG;
        else
            load( [ file_location '/II_gratings/II_' SubjectName '_RhmMd' RhythmMode '_SnsrMd' SensorMode '_' permutations '_groupall.mat'] )  %%%%%
            Accuracy = AccuracyII;
        end
        
        if ( strcmp(ProjectName,'face') )
            Accuracy = Accuracy([1+face_attention_mode:face_attention_mode+face_attention_mode],[1+face_attention_mode:face_attention_mode+face_attention_mode],:);
        end
        
        %% transform to ACCY structure
        Rhythm.param = param;
        
        Rhythm.AccyAll.matrix = Accuracy;
        for t = 1:size(Accuracy,3)
            Rhythm.AccyAll.sq(:,t) = squareform(Accuracy(:,:,t));
            if exist('Weight')
                Weight(6,6,1,1) = 0;
                for i_scout = 1:size(Weight,3)
                    Rhythm.AccyAll.Weight_sq(:,i_scout,t) = squareform(Weight(:,:,i_scout,t));
                end
            end
        end
        Rhythm.AccyAll.mean = mean(Rhythm.AccyAll.sq);
        if exist('Weight')
            Rhythm.AccyAll.weight = squeeze(mean(Rhythm.AccyAll.Weight_sq));
            Rhythm.AccyAll = rmfield( Rhythm.AccyAll, 'Weight_sq' );
        end
        
        %% Differences ----- for 6 conditions
        n_conditions = size(Accuracy,1);
        
        if n_conditions == 6
            n_30 = n_conditions - 1;
            selected_30 = [  [ zeros(1,n_30); diag([ones(1,n_30)]) ],  zeros(n_30+1,1)  ];
            n_60 = n_conditions - 2;
            selected_60 = [  [ zeros(2,n_60); diag([ones(1,n_60)]) ],  zeros(n_60+2,2)  ];
            n_90 = n_conditions - 3;
            selected_90 = [  [ zeros(3,n_90); diag([ones(1,n_90)]) ],  zeros(n_90+3,3)  ];
            n_120 = n_conditions - 4;
            selected_120 = [  [ zeros(4,n_120); diag([ones(1,n_120)]) ],  zeros(n_120+4,4)  ];
            n_150 = n_conditions - 5;
            selected_150 = [  [ zeros(5,n_150); diag([ones(1,n_150)]) ],  zeros(n_150+5,5)  ];
            
            selected_30 = selected_30 + selected_150;
            selected_60 = selected_60 + selected_120;
            
            % imagesc(selected_30);axis equal;axis([0.5 6.5 0.5  6.5]);
            
            selected_Cardinal = zeros(n_conditions);
            selected_Cardinal([1,4],:) = 1;
            selected_Cardinal(:,[1,4]) = 1;
            selected_Cardinal = tril(selected_Cardinal,-1);
            selected_Cardinal30 = selected_Cardinal .* selected_30;
            selected_Cardinal60 = selected_Cardinal .* selected_60;
            selected_Cardinal90 = selected_Cardinal .* selected_90;
            
            selected_Oblique = tril(ones(n_conditions),-1) - selected_Cardinal;
            selected_Oblique30 = selected_Oblique .* selected_30;
            selected_Oblique60 = selected_Oblique .* selected_60;
            selected_Oblique90 = selected_Oblique .* selected_90;
            
            % Modified part
            selected_CC = zeros(n_conditions);
            selected_CC(4,1) = 1;
            
            selected_CO = selected_Cardinal - selected_CC;
            
            selected_OO = selected_Oblique;
            
            n_selected_30 = sum(sum(selected_30));                  % 6
            n_selected_60 = sum(sum(selected_60));                  % 6
            n_selected_90 = sum(sum(selected_90));                  % 3
            n_selected_Cardinal = sum(sum(selected_Cardinal));      % 9
            n_selected_Cardinal30 = sum(sum(selected_Cardinal30));  % 4
            n_selected_Cardinal60 = sum(sum(selected_Cardinal60));  % 4
            n_selected_Cardinal90 = sum(sum(selected_Cardinal90));  % 1
            n_selected_Oblique = sum(sum(selected_Oblique));        % 6
            n_selected_Oblique30 = sum(sum(selected_Oblique30));    % 2
            n_selected_Oblique60 = sum(sum(selected_Oblique60));    % 2
            n_selected_Oblique90 = sum(sum(selected_Oblique90));    % 2
            
            n_selected_CC = sum(sum(selected_CC));
            n_selected_CO = sum(sum(selected_CO));
            n_selected_OO = sum(sum(selected_OO));
            
            for t = 1:size(Accuracy,3)
                Rhythm.Diff30.matrix(:,:,t) = Accuracy(:,:,t) .* selected_30;
                Rhythm.Diff60.matrix(:,:,t) = Accuracy(:,:,t) .* selected_60;
                Rhythm.Diff90.matrix(:,:,t) = Accuracy(:,:,t) .* selected_90;
                Rhythm.Cardinal.matrix(:,:,t) = Accuracy(:,:,t) .* selected_Cardinal;
                Rhythm.Cardinal30.matrix(:,:,t) = Accuracy(:,:,t) .* selected_Cardinal30;
                Rhythm.Cardinal60.matrix(:,:,t) = Accuracy(:,:,t) .* selected_Cardinal60;
                Rhythm.Cardinal90.matrix(:,:,t) = Accuracy(:,:,t) .* selected_Cardinal90;
                Rhythm.Oblique.matrix(:,:,t)  = Accuracy(:,:,t) .* selected_Oblique;
                Rhythm.Oblique30.matrix(:,:,t)  = Accuracy(:,:,t) .* selected_Oblique30;
                Rhythm.Oblique60.matrix(:,:,t)  = Accuracy(:,:,t) .* selected_Oblique60;
                Rhythm.Oblique90.matrix(:,:,t)  = Accuracy(:,:,t) .* selected_Oblique90;
                
                Rhythm.Diff30.mean(:,t) = squeeze(sum(sum(Rhythm.Diff30.matrix(:,:,t)))) / n_selected_30;
                Rhythm.Diff60.mean(:,t) = squeeze(sum(sum(Rhythm.Diff60.matrix(:,:,t)))) / n_selected_60;
                Rhythm.Diff90.mean(:,t) = squeeze(sum(sum(Rhythm.Diff90.matrix(:,:,t)))) / n_selected_90;
                Rhythm.Cardinal.mean(:,t) = squeeze(sum(sum(Rhythm.Cardinal.matrix(:,:,t)))) / n_selected_Cardinal;
                Rhythm.Cardinal30.mean(:,t) = squeeze(sum(sum(Rhythm.Cardinal30.matrix(:,:,t)))) / n_selected_Cardinal30;
                Rhythm.Cardinal60.mean(:,t) = squeeze(sum(sum(Rhythm.Cardinal60.matrix(:,:,t)))) / n_selected_Cardinal60;
                Rhythm.Cardinal90.mean(:,t) = squeeze(sum(sum(Rhythm.Cardinal90.matrix(:,:,t)))) / n_selected_Cardinal90;
                Rhythm.Oblique.mean(:,t) = squeeze(sum(sum(Rhythm.Oblique.matrix(:,:,t)))) / n_selected_Oblique;
                Rhythm.Oblique30.mean(:,t) = squeeze(sum(sum(Rhythm.Oblique30.matrix(:,:,t)))) / n_selected_Oblique30;
                Rhythm.Oblique60.mean(:,t) = squeeze(sum(sum(Rhythm.Oblique60.matrix(:,:,t)))) / n_selected_Oblique60;
                Rhythm.Oblique90.mean(:,t) = squeeze(sum(sum(Rhythm.Oblique90.matrix(:,:,t)))) / n_selected_Oblique90;
                
                Rhythm.CC.matrix(:,:,t)  = Accuracy(:,:,t) .* selected_CC;
                Rhythm.CO.matrix(:,:,t)  = Accuracy(:,:,t) .* selected_CO;
                Rhythm.OO.matrix(:,:,t)  = Accuracy(:,:,t) .* selected_OO;
                
                Rhythm.CC.mean(:,t) = squeeze(sum(sum(Rhythm.CC.matrix(:,:,t)))) / n_selected_CC;
                Rhythm.CO.mean(:,t) = squeeze(sum(sum(Rhythm.CO.matrix(:,:,t)))) / n_selected_CO;
                Rhythm.OO.mean(:,t) = squeeze(sum(sum(Rhythm.OO.matrix(:,:,t)))) / n_selected_OO;
            end
            
            clear t n_conditions
            clear n_30 n_60 n_90 n_120 n_150
            clear selected_CC selected_CO selected_OO selected_30 selected_60 selected_90 n_elected_30 n_selected_60 n_selected_90
            clear selected_120 selected_150 n_selected_120 n_selected_150
        end
        
        if strcmp(iitt, 'ii')
            save( [ file_location '/ACCY_' SubjectName '_' RhythmMode '_' SensorMode ], 'SubjectName', 'Rhythm');
        else
            save( [ file_location '/II_' SubjectName '_' RhythmMode '_' SensorMode ], 'SubjectName', 'Rhythm');
        end
    end
    disp('All finished!');
end


