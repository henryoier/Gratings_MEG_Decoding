clear;clc; close all;
addpath(genpath('Functions'));
ProjectName = 'sheng';   %%%%%
RhythmMode = {'evoked','isingle28','isingle56'}; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all' 'scouts'
Compare_Field = 'C';
file_location = [ '/dataslow/sheng/Project of Sheng/Results/' ProjectName ];
flag_save = 1;

Fig_location = [file_location '/Fig_ProjectAway/'];

%% load file
for condA = 2:2
    for condB = 3:3
    %for i_subject = [0]  SubjectName = '14gratings316'; YMIN = 20; YMAX = 100; YMIN_CO = -25; YMAX_CO = 40;
    for i_subject = [3:16]  SubjectName = ['grating' num2str(i_subject, '%0.2d')]; YMIN = 20; YMAX = 100; YMIN_CO = -50; YMAX_CO = 60;
       if (strcmp(RhythmMode{condA},'evoked') || RhythmMode{condA}(2) == 'v')
            mat_location = [ file_location '/Mat_' RhythmMode{condA}];
            SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
            file_load = [ 'II_' SubjectName '_' RhythmMode{condA} '_' SensorMode '.mat'];
            load( [mat_location '/' file_load]);
            Original1(i_subject - 2,:,:,:) = Rhythm.AccyAll.matrix;
        else
            mat_location = [ file_location '/Mat_TFA_isingle/Accy_gratings_isingles'];
            SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
            file_load = [ 'ACCY_' SubjectName '_' RhythmMode{condA} '_' SensorMode '.mat'];
            load( [mat_location '/' file_load]);
            Original1(i_subject - 2,:,:,:) = Rhythm.AccyAll.matrix;
       end
       
       if (strcmp(RhythmMode{condB},'evoked') || RhythmMode{condB}(2) == 'v')
            mat_location = [ file_location '/Mat_' RhythmMode{condB}];
            SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
            file_load = [ 'II_' SubjectName '_' RhythmMode{condB} '_' SensorMode '.mat'];
            load( [mat_location '/' file_load]);
            Original2(i_subject - 2,:,:,:) = Rhythm.AccyAll.matrix;
        else
            mat_location = [ file_location '/Mat_TFA_isingle/Accy_gratings_isingles'];
            SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
            file_load = [ 'ACCY_' SubjectName '_' RhythmMode{condB} '_' SensorMode '.mat'];
            load( [mat_location '/' file_load]);
            Original2(i_subject - 2,:,:,:) = Rhythm.AccyAll.matrix;
       end
    end


    Time = Rhythm.param.Time;

    Cardinal = zeros(6);
    Cardinal([1,4],:) = 1;
    Cardinal(:,[1,4]) = 1;
    Cardinal = tril(Cardinal,-1);
    Oblique = tril(ones(6),-1) - Cardinal;

    Cardinal = squareform(Cardinal);
    Cardinal = Cardinal - mean(Cardinal);
    Cardinal = Cardinal';

    Oblique = squareform(Oblique);
    Oblique = Oblique - mean(Oblique);

    ProjectAway_Cardinal = eye(15) - (Cardinal * Cardinal') / (Cardinal' * Cardinal); 

%     %% Check partial correlation
%     Check_Subject = 4;  %3:14
%     Check_Time = 600;   %1:1901
%     
%     % using partial correlation
%     X = [squareform(squeeze(Original1(Check_Subject,:,:,Check_Time)))'];
%     X = [X squareform(squeeze(Original2(Check_Subject,:,:,Check_Time)))'];
%     Z = Cardinal;
%     
%     RHO = partialcorr(X, Z)
%     ProjZhat = eye(size(Z, 1)) - Z * Z' / (Z' * Z);
%     X_zhat = ProjZhat * X;
%     
%     RHO = partialcorr(X_zhat, Z)
%     RHO = partialcorr([ProjZhat * X(:,1) X(:,2)],  Z)
%    
    %% Project matrix to oblique or cardinal
    for subject = 1:14
        for t=1:1901
            Projection1(:,t,subject) = squareform(squeeze(Original1(subject,:,:,t))) * ProjectAway_Cardinal;
            Projection2(:,t,subject) = squareform(squeeze(Original2(subject,:,:,t))) * ProjectAway_Cardinal;
        end
    end

    k=1;

    %Calculate Between
    for s1 = 1:14
        for s2 = 1:14
            CC(:,:,k) = corr(Projection1(:,:,s1), Projection2(:,:,s2), 'type','Spearman'); %Msq(:,:,s) should be condxtime
            %CC(:,:,k+1) = CC(:,:,k)';
            %k = k+2;
            k=k+1;
        end
    end

    clear projection1 projection2;
    
    %Calculate within
    % k = 1;
    % for s1 = 1:14
    %     CC(:,:,k) = corr(Projection(:,:,s1), Projection(:,:,s1), 'type','Pearson'); %Msq(:,:,s) should be condxtime
    %     k=k+1;
    % end

    
    %% Draw Time-Time graph
    h = figure;
    imagesc(Time,Time,mean(CC, 3)); colorbar; set(gca,'YDir','normal');
    colormap(jet);
    axis equal; axis([min(Time) max(Time) min(Time) max(Time)])
    %caxis([YMIN YMAX]);

    line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    h_title = title(['Subjects between ' RhythmMode{condA} ' versus ' RhythmMode{condB} ' Spearman' ], 'FontSize', 13);
    set(gca,'FontSize',15);

    %Result = [Result (mean(mean(TT.mean(Baseline + [100:150],Baseline + [900:950]) ,1),2) - min_accuracy)/(max_accuracy - min_accuracy)];

    if (flag_save)
        %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
        set(h,'Position',[1 1 1400 900]);
        set(h,'PaperPositionMode','auto');
        set(gca,'FontSize',25);
        set(h_title,'FontSize', 20);
        print(h,[Fig_location 'TT__Correlation_Between_' RhythmMode{condA} '_versus_' RhythmMode{condB} '_PCB_Spearman.jpg'],'-djpeg','-r0');
        close(h);
    end
    
    CC = permute(single(CC), [3,1,2]);

    %     set(h,'Position',[100 100 1200 800]);
    %     axis([ -0.2, 1.5, -0.2, 1.5]); % box off;

    disp('statistc');

    %% Statistic significant analysis
        nperm = 1000;
        alpha = 0.05;
        cluster_th = 0.05;   %perform cluster size tests

        [TT.clusters.SignificantTimes,TT.clusters.clusters,TT.clusters.clustersize] = permutation_cluster_1sample_2dim(CC, nperm, cluster_th, alpha);
        % imagesc(SignificantTimes);set(gca,'YDir','normal');
    %     CC = reshape(CC,[14,1901*1901,1]);
    %     [TT.ttest.StatMap, TT.ttest.StatMapPv, TT.ttest.Perm, TT.ttest.FDR] = permutation_1sample(CC,nperm,alpha);
    %     CC = reshape(CC,[14,1901,1901]);
    %     TT.ttest.Perm.StatMapTh = reshape(TT.ttest.Perm.StatMapTh,[1901,1901]);
    %     TT.ttest.FDR.StatMapTh = reshape(TT.ttest.FDR.StatMapTh,[1901,1901]);
    %     % imagesc(TT.ttest.FDR_TT.StatMapTh>0);set(gca,'YDir','normal');


    %% figure significant time
    h = figure;
    imagesc(Time,Time,TT.clusters.SignificantTimes); set(gca,'YDir','normal');
    axis equal; axis([min(Time) max(Time) min(Time) max(Time)])

    line('XData', [min(Time),max(Time)], 'YData', [0 0], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
    line('XData', [min(Time),max(Time)], 'YData', [0.8 0.8], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
    line('XData', [0 0], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
    line('XData', [0.8 0.8], 'YData', [min(Time),max(Time)], 'LineStyle', '-', 'LineWidth', 1.5, 'Color','r')
    h_title = title(['Subject between ' RhythmMode{condA} ' versus ' RhythmMode{condB} ' siginificant time Spearman'], 'FontSize', 13);
    set(gca,'FontSize',14);

    if (flag_save)
        %         saveas(h_TT,[jpg_file_name 'TT__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff']);
        set(h,'Position',[1 1 1400 900]);
        set(h,'PaperPositionMode','auto');
        set(gca,'FontSize',25);
        set(h_title,'FontSize', 20);
        print(h,[Fig_location 'TT__Correlation_Between_' RhythmMode{condA} ' versus ' RhythmMode{condB} '_SignificantTimes_PCB_Spearman.jpg'],'-djpeg','-r0');
        close(h);
    end
    
    clear cc;
    end
end

