% plot time-frequency decoding accuracy
clear;clc;%close all;
%cd C:\Users\Mingtong\OneDrive\Mingtong\RhythmClassifier
ProjectName = 'sheng'; 

SensorMode = 'all'; % 'batch' 'all'
RhythmMode_pre = 'isingle';

single_number_begin = 2;
single_number_step = 2;
single_number_end = 80;

flag_save = 1;
flag_save_mat = 0;
flag_one_only = 1;

stimulate_end_time = 0.8;

for i_subject = [12] SubjectName = ['grating' num2str(i_subject, '%0.2d') ]; ACCYMIN = 20; ACCYMAX = 100;
% for i_subject = [0] SubjectName = '14gratings316'; ACCYMIN = 40; ACCYMAX = 90;
    disp(['Subject: ' SubjectName]);
    
    %% generate
    file_location = [pwd '/Results/' ProjectName ];
    mat_location = [ file_location '/Mat_TFA_' RhythmMode_pre ];
%     mat_location = [ file_location '\Mat_grating12'];
    Freq = [single_number_begin : single_number_step : single_number_end];
    
    if flag_save_mat
        for single_number = Freq
            RhythmMode = [RhythmMode_pre num2str(single_number,'%d')]; % % 'evoked', 'beta', 'gamma'
            
            
            %%
%             file_load = [ mat_location '/Accy_gratings_' RhythmMode_pre 's/ACCY_' SubjectName '_' RhythmMode '_' SensorMode];
            file_load = [ mat_location '/ACCY_' SubjectName '_' RhythmMode '_' SensorMode];
            file_tmp = load( file_load );
            if (single_number == single_number_begin)           % initial
                TFA.AccyAll.mean = file_tmp.Rhythm.AccyAll.mean;
                TFA.param = file_tmp.Rhythm.param;
                if size(file_tmp.Rhythm.AccyAll.matrix,1) == 6
                    for condA = [6:-1:2]
                        for condB = [condA-1 : -1 : 1]
                            TFA.TwoCond{condA,condB}.mean = squeeze(file_tmp.Rhythm.AccyAll.matrix(condA,condB,:))';
                        end
                    end
                    TFA.Diff30.mean = file_tmp.Rhythm.Diff30.mean;
                    TFA.Diff60.mean = file_tmp.Rhythm.Diff60.mean;
                    TFA.Diff90.mean = file_tmp.Rhythm.Diff90.mean;
                    TFA.Cardinal.mean = file_tmp.Rhythm.Cardinal.mean;
                    TFA.Cardinal30.mean = file_tmp.Rhythm.Cardinal30.mean;
                    TFA.Cardinal60.mean = file_tmp.Rhythm.Cardinal60.mean;
                    TFA.Cardinal90.mean = file_tmp.Rhythm.Cardinal90.mean;
                    TFA.Oblique.mean = file_tmp.Rhythm.Oblique.mean;
                    TFA.Oblique30.mean = file_tmp.Rhythm.Oblique30.mean;
                    TFA.Oblique60.mean = file_tmp.Rhythm.Oblique60.mean;
                    TFA.Oblique90.mean = file_tmp.Rhythm.Oblique90.mean;
                    TFA.param = file_tmp.Rhythm.param;
                end
            else
                TFA.AccyAll.mean = [ TFA.AccyAll.mean; file_tmp.Rhythm.AccyAll.mean ];
                if size(file_tmp.Rhythm.AccyAll.matrix,1) == 6
                    for condA = [6:-1:2]
                        for condB = [condA-1 : -1 : 1]
                            TFA.TwoCond{condA,condB}.mean = [ TFA.TwoCond{condA,condB}.mean; squeeze(file_tmp.Rhythm.AccyAll.matrix(condA,condB,:))' ];
                        end
                    end
                    TFA.Diff30.mean = [ TFA.Diff30.mean; file_tmp.Rhythm.Diff30.mean ];
                    TFA.Diff60.mean = [ TFA.Diff60.mean; file_tmp.Rhythm.Diff60.mean ];
                    TFA.Diff90.mean = [ TFA.Diff90.mean; file_tmp.Rhythm.Diff90.mean ];
                    TFA.Cardinal.mean = [ TFA.Cardinal.mean; file_tmp.Rhythm.Cardinal.mean ];
                    TFA.Cardinal30.mean = [ TFA.Cardinal30.mean; file_tmp.Rhythm.Cardinal30.mean ];
                    TFA.Cardinal60.mean = [ TFA.Cardinal60.mean; file_tmp.Rhythm.Cardinal60.mean ];
                    TFA.Cardinal90.mean = [ TFA.Cardinal90.mean; file_tmp.Rhythm.Cardinal90.mean ];
                    TFA.Oblique.mean = [ TFA.Oblique.mean; file_tmp.Rhythm.Oblique.mean ];
                    TFA.Oblique30.mean = [ TFA.Oblique30.mean; file_tmp.Rhythm.Oblique30.mean ];
                    TFA.Oblique60.mean = [ TFA.Oblique60.mean; file_tmp.Rhythm.Oblique60.mean ];
                    TFA.Oblique90.mean = [ TFA.Oblique90.mean; file_tmp.Rhythm.Oblique90.mean ];
                end
            end
        end
        
        file_save = [  'TFA_' SubjectName '_' RhythmMode_pre '_' SensorMode ];
        save([ mat_location '/' file_save], 'TFA');
    else
        file_save = [  'TFA_' SubjectName '_' RhythmMode_pre '_' SensorMode ];
%         file_save = [  'TFA_' SubjectName '_' RhythmMode_pre '_' SensorMode '_2-190'];
        load([ mat_location '/' file_save ]);
    end
    
    
    
    %% plot time-frequency accuracy
    Time = TFA.param.Time;
    
    %% AccyAll
    plot_TFA = TFA.AccyAll.mean; 
    h = figure;imagesc(Time,Freq,plot_TFA);set(gca,'YDir','normal');
    axis([min(Time), max(Time), 12, 80]);
    colormap(jet);
    colorbar; caxis([ACCYMIN ACCYMAX]);
    h_title = title([SubjectName '     Rhythm: ' RhythmMode_pre '     Accuracy     All conditons'], 'FontSize', 15);
    set(gca,'FontSize',15);
    line('XData', [0 0], 'YData', [0,500], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    line('XData', [stimulate_end_time stimulate_end_time], 'YData', [0,500], 'LineStyle', '-', 'LineWidth', 3, 'Color',[204/255 102/255 0])
    
    max_accuracy = max(max(plot_TFA));
    min_accuracy = min(min(plot_TFA));
    display([ 'TFA: ' num2str(min_accuracy,3) '% ~ ' num2str(max_accuracy,3) '%']);
    
    if (flag_save)
%         saveas(h,[ file_location '/Fig3_IITT/' file_save '__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff'])
        set(h,'Position',[1 1 1400 900]);
        set(h,'PaperPositionMode','auto');
        set(gca,'FontSize',25);
        set(h_title,'FontSize', 20);
        print(h,[ file_location '/Fig_TFA_' RhythmMode_pre '/' file_save '__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.jpg'],'-djpeg','-r0');
        close(h);
    end
    
%     set(h,'Position',[100 100 1200 800]);
%     axis([ -0.2, 1.5, 14, 80]); % box off;
    
    % AccyAll significant time
    if isfield(TFA.AccyAll, 'stat_stime')
        plot_TFA = TFA.AccyAll.stat_stime;
        h = figure;imagesc(Time,Freq,plot_TFA);set(gca,'YDir','normal');
        %     colorbar; caxis([ACCYMIN ACCYMAX]);
        h_title = title([SubjectName '     Rhythm: ' RhythmMode_pre '     Accuracy     All conditons'], 'FontSize', 15);
        set(gca,'FontSize',15);
        line('XData', [0 0], 'YData', [0,500], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
        line('XData', [stimulate_end_time stimulate_end_time], 'YData', [0,500], 'LineStyle', '-', 'LineWidth', 1.5, 'Color',[204/255 102/255 0])
        
        display([ 'TFA significant time.' ]);
        
        if (flag_save)
            %         saveas(h,[ file_location '/Fig3_IITT/' file_save '__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff'])
            set(h,'Position',[1 1 1400 900]);
            set(h,'PaperPositionMode','auto');
            set(gca,'FontSize',25);
            set(h_title,'FontSize', 20);
            print(h,[ file_location '/Fig_TFA_' RhythmMode_pre '/' file_save '__stime.jpg'],'-djpeg','-r0');
            close(h);
        end
    end
    
    %% Two conditions
    if (~flag_one_only)
        
        h = figure;
        for condA = [6:-1:2]
            for condB = [condA-1 : -1 : 1]
                subplot(5,5,(condA-2)*5 + condB);
                plot_TFA = TFA.TwoCond{condA,condB}; % .AccyAll
                imagesc(Time,Freq,plot_TFA);set(gca,'YDir','normal');
                axis([min(Time) max(Time) min(Freq) max(Freq)]);
                caxis([ACCYMIN ACCYMAX]);
                axis off;
                %             if ~(condA==6 & condB==1) axis off; set(gca,'FontSize',15); end
                if (condB==1)
                    if (condA==2) text(-1.4,45,'30^o','FontSize',18);; end
                    if (condA==3) text(-1.4,45,'60^o','FontSize',18);; end
                    if (condA==4) text(-1.4,45,'90^o','FontSize',18);; end
                    if (condA==5) text(-1.4,45,'120^o','FontSize',18);; end
                    if (condA==6) text(-1.4,45,'150^o','FontSize',18);; end
                end
                if (condA==6)
                    if (condB==1) text(0.5,-15,'0^o','FontSize',18);; end
                    if (condB==2) text(0.5,-15,'30^o','FontSize',18);; end
                    if (condB==3) text(0.5,-15,'60^o','FontSize',18);; end
                    if (condB==4) text(0.5,-15,'90^o','FontSize',18);; end
                    if (condB==5) text(0.5,-15,'120^o','FontSize',18);; end
                end
                if (condA==2 & condB==1)
                    text(2,100,['Time-Frequency-Accuracy, ' SubjectName], 'FontSize', 15);
                end
            end
        end
    end
end
