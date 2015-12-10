function RStep4_AverageSubjectsPost(RhythmMode,FileType,clusterflag)
% RStep7_AverageSubjectsPost('single','TFA','0')
% % average subjects and do statistical analysis

% % for example
% clear;clc;
RhythmMode = 'single'; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle' 'vectorlow'
FileType = 'II';
clusterflag = '0';

addpath(genpath('Functions/Functions_stat'));

clusterflag = str2num(clusterflag);
ProjectName = ['sheng']; % fang02_grating01

files_number = 14;
Subject_Name = [ 'grating'];

nperm = 1000;
alpha = 0.05;
tail = 'twotail';
if strcmp(FileType,'II') cluster_th = 0.05; end
if strcmp(FileType,'TT') cluster_th = 0.05; end
if strcmp(FileType,'TFA') cluster_th = 0.05; end

if clusterflag
    if (length(FileType)==2) file_location = ['/om/user/mfang/RhythmClassifier/TT/Mat_' RhythmMode  ]; end
    if (length(FileType)==3) file_location = ['/om/user/mfang/RhythmClassifier/TT/Mat0_TFA_' RhythmMode  ]; end
else
    if (length(FileType)==2) file_location = ['/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA_' RhythmMode  ]; end
    if (length(FileType)==3) file_location = ['/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA_' RhythmMode  ]; end
end



SensorMode = 'all'; % 'batch' 'all'
permutations = 'p100';

for freq = 2:2:80
    
file_names = dir( [ file_location '/ACCY_gratings_singles/ACCY_grating*_' RhythmMode num2str(freq) '_' SensorMode '.mat'] );
disp([ FileType ': files numbers = ' num2str(length(file_names)) ]);

switch FileType
    % for II
    case 'II'
        if ( length(file_names) == files_number )
            II_tmp = load([file_location, '/ACCY_gratings_singles/', file_names(1).name]);
            Rhythm.param = II_tmp.Rhythm.param;
%            Rhythm.param.SubjectName = SubjectName;
            
            % initialize, for the first file
            % AccyAll
            Data_AccyAll(1,:) = II_tmp.Rhythm.AccyAll.mean;
            Data_AccyAll_matrix(1,:,:,:) = II_tmp.Rhythm.AccyAll.matrix;
            % Diff & Cardinal
            Data_Diff30(1,:) = II_tmp.Rhythm.Diff30.mean;
            Data_Diff60(1,:) = II_tmp.Rhythm.Diff60.mean;
            Data_Diff90(1,:) = II_tmp.Rhythm.Diff90.mean;
            Data_Cardinal(1,:) = II_tmp.Rhythm.Cardinal.mean;
            Data_Cardinal30(1,:) = II_tmp.Rhythm.Cardinal30.mean;
            Data_Cardinal60(1,:) = II_tmp.Rhythm.Cardinal60.mean;
            Data_Cardinal90(1,:) = II_tmp.Rhythm.Cardinal90.mean;
            Data_Oblique(1,:) = II_tmp.Rhythm.Oblique.mean;
            Data_Oblique30(1,:) = II_tmp.Rhythm.Oblique30.mean;
            Data_Oblique60(1,:) = II_tmp.Rhythm.Oblique60.mean;
            Data_Oblique90(1,:) = II_tmp.Rhythm.Oblique90.mean;
            Data_CC(1,:) = II_tmp.Rhythm.CC.mean;
            Data_CO(1,:) = II_tmp.Rhythm.CO.mean;
            Data_OO(1,:) = II_tmp.Rhythm.OO.mean;
            
            % the other files
            for i_file = 2:length(file_names)
                II_tmp = load([file_location, '/ACCY_gratings_singles/', file_names(i_file).name]);
                Data_AccyAll(i_file,:) = II_tmp.Rhythm.AccyAll.mean;
                Data_AccyAll_matrix(i_file,:,:,:) = II_tmp.Rhythm.AccyAll.matrix;
                Data_Diff30(i_file,:) = II_tmp.Rhythm.Diff30.mean;
                Data_Diff60(i_file,:) = II_tmp.Rhythm.Diff60.mean;
                Data_Diff90(i_file,:) = II_tmp.Rhythm.Diff90.mean;
                Data_Cardinal(i_file,:) = II_tmp.Rhythm.Cardinal.mean;
                Data_Cardinal30(i_file,:) = II_tmp.Rhythm.Cardinal30.mean;
                Data_Cardinal60(i_file,:) = II_tmp.Rhythm.Cardinal60.mean;
                Data_Cardinal90(i_file,:) = II_tmp.Rhythm.Cardinal90.mean;
                Data_Oblique(i_file,:) = II_tmp.Rhythm.Oblique.mean;
                Data_Oblique30(i_file,:) = II_tmp.Rhythm.Oblique30.mean;
                Data_Oblique60(i_file,:) = II_tmp.Rhythm.Oblique60.mean;
                Data_Oblique90(i_file,:) = II_tmp.Rhythm.Oblique90.mean;
                Data_CC(i_file,:) = II_tmp.Rhythm.CC.mean;
                Data_CO(i_file,:) = II_tmp.Rhythm.CO.mean;
                Data_OO(i_file,:) = II_tmp.Rhythm.OO.mean;
            end
            
            % Statistic significant analysis
            Rhythm.param.stat.nperm = nperm;
            Rhythm.param.stat.alpha = alpha;
            Rhythm.param.stat.tail = tail;
            Rhythm.param.stat.cluster_th = cluster_th;   %perform cluster size tests
            % AccyAll
%             [StatMap_AccyAll,StatMapPv_AccyAll,Perm_AccyAll,FDR_AccyAll,PermMatrix_AccyAll] = permutation_1sample(Data_AccyAll-50,nperm,alpha,tail);
%             [SignificantTimes_AccyAll, clusters_AccyAll,clustersize_AccyAll,StatMapPermpv_AccyAll] = permutation_cluster_1sample(Data_AccyAll-50, nperm, cluster_th, alpha);
            % Diff
%             [SignificantTimes_Diff30] = permutation_cluster_1sample(Data_Diff30-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Diff60] = permutation_cluster_1sample(Data_Diff60-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Diff90] = permutation_cluster_1sample(Data_Diff90-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Cardinal] = permutation_cluster_1sample(Data_Cardinal-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Cardinal30] = permutation_cluster_1sample(Data_Cardinal30-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Cardinal60] = permutation_cluster_1sample(Data_Cardinal60-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Cardinal90] = permutation_cluster_1sample(Data_Cardinal90-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Oblique] = permutation_cluster_1sample(Data_Oblique-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Oblique30] = permutation_cluster_1sample(Data_Oblique30-50, nperm, cluster_th, alpha);
%             [SignificantTimes_Oblique60] = permutation_cluster_1sample(Data_Oblique60-50, nperm, cluster_th, alpha);
%            [SignificantTimes_Oblique90] = permutation_cluster_1sample(Data_Oblique90-50, nperm, cluster_th, alpha);
            [SignificantTimes_CC] = permutation_cluster_1sample(Data_CC-50, nperm, cluster_th, alpha);
            [SignificantTimes_CO] = permutation_cluster_1sample(Data_CO-50, nperm, cluster_th, alpha);
            [SignificantTimes_OO] = permutation_cluster_1sample(Data_OO-50, nperm, cluster_th, alpha);
            
            % output file
%             Rhythm.AccyAll.mean = mean(Data_AccyAll);
%             Rhythm.AccyAll.matrix = squeeze(mean(Data_AccyAll_matrix));
%             Rhythm.AccyAll.stat_stime = SignificantTimes_AccyAll;
%             Rhythm.AccyAll.stat_ttest = Perm_AccyAll.StatMapTh;
%             Rhythm.AccyAll.stat_pvalue = FDR_AccyAll.StatMapTh;
%             
%             Rhythm.Diff30.mean = mean(Data_Diff30);
%             Rhythm.Diff30.stat_stime = SignificantTimes_Diff30;
%             Rhythm.Diff60.mean = mean(Data_Diff60);
%             Rhythm.Diff60.stat_stime = SignificantTimes_Diff60;
%             Rhythm.Diff90.mean = mean(Data_Diff90);
%             Rhythm.Diff90.stat_stime = SignificantTimes_Diff90;
%             Rhythm.Cardinal.mean = mean(Data_Cardinal);
%             Rhythm.Cardinal.stat_stime = SignificantTimes_Cardinal;
%             Rhythm.Cardinal30.mean = mean(Data_Cardinal30);
%             Rhythm.Cardinal30.stat_stime = SignificantTimes_Cardinal30;
%             Rhythm.Cardinal60.mean = mean(Data_Cardinal60);
%             Rhythm.Cardinal60.stat_stime = SignificantTimes_Cardinal60;
%             Rhythm.Cardinal90.mean = mean(Data_Cardinal90);
%             Rhythm.Cardinal90.stat_stime = SignificantTimes_Cardinal90;
%             Rhythm.Oblique.mean = mean(Data_Oblique);
%             Rhythm.Oblique.stat_stime = SignificantTimes_Oblique;
%             Rhythm.Oblique30.mean = mean(Data_Oblique30);
%             Rhythm.Oblique30.stat_stime = SignificantTimes_Oblique30;
%             Rhythm.Oblique60.mean = mean(Data_Oblique60);
%             Rhythm.Oblique60.stat_stime = SignificantTimes_Oblique60;
%             Rhythm.Oblique90.mean = mean(Data_Oblique90);
%             Rhythm.Oblique90.stat_stime = SignificantTimes_Oblique90;
            Rhythm.CC.mean = mean(Data_CC);
            Rhythm.CC.stat_stime = SignificantTimes_CC;
            Rhythm.CO.mean = mean(Data_CO);
            Rhythm.CO.stat_stime = SignificantTimes_CO;
            Rhythm.OO.mean = mean(Data_OO);
            Rhythm.OO.stat_stime = SignificantTimes_OO;
            
            
            save( [ file_location '/ACCY_single/TFA_14gratings316_' RhythmMode num2str(freq) '_' SensorMode '.mat'], 'Rhythm');
        else
            error('myError: wrong loading!')
        end
        
        
    % for TT
    case 'TT'
        if ( length(file_names) == files_number )
            TT_tmp = load([file_location, '/', file_names(1).name]);
            param = TT_tmp.param;
            param.SubjectName = SubjectName;
            
            % initialize, for the first file
            % TT
            Data_TT(1,:,:) = TT_tmp.AccuracyTT;
            
            % the other files
            for i_file = 2:length(file_names)
                TT_tmp = load([file_location, '/', file_names(i_file).name]);
                Data_TT(i_file,:,:) = TT_tmp.AccuracyTT;
            end
            
            % Statistic significant analysis
            param.stat.nperm = nperm;
            param.stat.alpha = alpha;
            param.stat.tail = tail;
            param.stat.cluster_th = cluster_th;   %perform cluster size tests
            [TT.clusters.SignificantTimes,TT.clusters.clusters,TT.clusters.clustersize] = permutation_cluster_1sample_2dim(Data_TT-50, nperm, cluster_th, alpha);
            % imagesc(SignificantTimes);set(gca,'YDir','normal');
            Data_TT = reshape(Data_TT,[14,1901*1901,1]);
            [TT.ttest.StatMap, TT.ttest.StatMapPv, TT.ttest.Perm, TT.ttest.FDR] = permutation_1sample(Data_TT-50,nperm,alpha,tail);
            Data_TT = reshape(Data_TT,[14,1901,1901]);
            TT.ttest.Perm.StatMapTh = reshape(TT.ttest.Perm.StatMapTh,[1901,1901]);
            TT.ttest.FDR.StatMapTh = reshape(TT.ttest.FDR.StatMapTh,[1901,1901]);
            % imagesc(TT.ttest.FDR_TT.StatMapTh>0);set(gca,'YDir','normal');

            % output file
            TT.mean = squeeze(mean(Data_TT));
            TT.stat_stime = TT.clusters.SignificantTimes;
            TT.stat_tmap = TT.ttest.Perm.StatMapTh;
            TT.stat_pmap = TT.ttest.FDR.StatMapTh;
            
            
            save( [ file_location '/TT_' SubjectName '_' RhythmMode '_' SensorMode ], 'param', 'TT','-v7.3');
        else
            error('myError: wrong loading!')
        end
        
    case 'TFA'
        if ( length(file_names) == files_number )
            TFA_tmp = load([file_location, '/', file_names(1).name]);
            param = TFA_tmp.TFA.param;
            param.SubjectName = SubjectName;
            
            % initialize, for the first file
            % 14_Subjects * 40_Freq * 1901_Time
            Data_TFA.AccyAll(1,:,:) = TFA_tmp.TFA.AccyAll.mean;
            
            % the other files
            for i_file = 2:length(file_names)
                TFA_tmp = load([file_location, '/', file_names(i_file).name]);
                Data_TFA.AccyAll(i_file,:,:) = TFA_tmp.TFA.AccyAll.mean;
            end
            
            % Statistic significant analysis
            param.stat.nperm = nperm;
            param.stat.alpha = alpha;
            param.stat.tail = tail;
            param.stat.cluster_th = cluster_th;   %perform cluster size tests
            [SignificantTimes_AccyAll] = permutation_cluster_1sample_2dim(Data_TFA.AccyAll-50, nperm, cluster_th, alpha);
            % imagesc(SignificantTimes_AccyAll);set(gca,'YDir','normal');

            % output file
            TFA.AccyAll.mean = squeeze(mean(Data_TFA.AccyAll,1));
            TFA.AccyAll.stat_stime = SignificantTimes_AccyAll;
            TFA.param = param;
            
            % save
            save( [ file_location '/TFA_' SubjectName '_' RhythmMode '_' SensorMode '.mat'], 'TFA');
        else
            error('myError: wrong loading!')
        end
        
        
    % for Accy
    case 'ACCY'
        
        file_names = dir( [ file_location '/' FileType '_grating*_' RhythmMode '_' SensorMode '.mat'] );
        if (length(file_names) ~= files_number)
            error('myError: wrong loading!')
        end
        ACCY_tmp = load([file_location, '/', file_names(1).name]);
        
        
        AccuracyMEG_sum = ACCY_tmp.AccuracyMEG;
        param = ACCY_tmp.param;
        %     param.SubjectName = [ num2str(length(file_names)) 'gratings' Accy_tmp.param.SubjectName(end-1:end)];
        param.SubjectName = SubjectName;
        
        for i_file = 2:length(file_names)
            ACCY_tmp = load([file_location, '/', file_names(i_file).name]);
            AccuracyMEG_sum = AccuracyMEG_sum + ACCY_tmp.AccuracyMEG;
            %         param.SubjectName = [ param.SubjectName  Accy_tmp.param.SubjectName(end-1:end) ];
        end
        AccuracyMEG = AccuracyMEG_sum / length(file_names);
        
        save( [ file_location '/Accuracy_' param.SubjectName '_' RhythmMode '_' SensorMode '.mat'], 'param', 'AccuracyMEG');
        
end
end
disp([ 'Finished!' ]);
