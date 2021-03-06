% function RStep3A_plot_ii(RhythmMode)
% % plot decoding accuracy

% cd C:\Users\Mingtong\OneDrive\Mingtong\RhythmClassifier
clear;clc; close all;
addpath(genpath('Functions'));
ProjectName = 'sheng';   %%%%%
RhythmModes = {'evoked','ivectorlow','ivectorhigh'}; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all' 'scouts'
iitt = 'iitt';

flag_save = 1;
flag_all = 1;
flag_weight = 0;
flag_weight_movie = 0;
flag_diff = 1;
flag_Cardinal = 1;
flag_CO = 0;
flag_C3 = 0;

in_time = [210:30:901];
flag_smooth = 1;
smooth_vector = ones(1,50)/50;
% x = rand(1,100);xsm = conv(x,ones(1,10)/10,'same');figure;hold on;plot(x);plot(xsm,'r')
stimulate_end_time = 0.8;

for i_mode = 1:3
RhythmMode = RhythmModes{i_mode};
for i_subject = [0]  SubjectName = '14gratings316'; YMIN = 30; YMAX = 100; YMIN_CO = -25; YMAX_CO = 40;
%for i_subject = [3:16]  SubjectName = ['grating' num2str(i_subject, '%0.2d')]; YMIN = 20; YMAX = 100; YMIN_CO = -50; YMAX_CO = 60;

%for freq=2:2:80
    %% load file
    display(['Subject: ' SubjectName]);
    file_location = [ '../../Results/Gratings/' ProjectName];
    mat_location = [ file_location '/Mat_' RhythmMode]; 
    fig_location = [ file_location '/Fig_' RhythmMode];
    save_location = [file_location '/Final_paper/'];
    
    if strcmp(iitt, 'ii')
        file_load = [ 'ACCY_' SubjectName '_' RhythmMode '_' SensorMode];
        jpg_file_name = [ fig_location '/ACCY_' SubjectName '_' RhythmMode '_' SensorMode '___'];
%         jpg_file_name = [ file_location '/Fig3_IITT/Fig_' RhythmMode '/ACCY_' SubjectName '_' RhythmMode '_' SensorMode '___'];
    else
        file_load = [ 'II_' SubjectName '_' RhythmMode '_' SensorMode];
        jpg_file_name = [ fig_location '/IITT_' SubjectName '_' RhythmMode '_' SensorMode '___'];
%         jpg_file_name = [ file_location '/Fig3_IITT/Fig_' RhythmMode '/IITT_' SubjectName '_' RhythmMode '_' SensorMode '___'];
    end
    load( [mat_location '/' file_load]);
    Time = Rhythm.param.Time;
       
    %% mean of all conditions
    if flag_all
        % AccyAll
        clear Data;
        Data{1} = Rhythm.AccyAll;
        Data{1}.color = 'k';
        title_text = [SubjectName '      ' RhythmMode '      ' SensorMode '      All conditions'];
        h = RStep3Z_subfunction_plot(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);
     
        if (flag_save)
            %         saveas(h_AccyAll,[jpg_file_name 'AccyAll__' num2str(max_accuracy,3) '%_' num2str(max_index+min(Time)*1000) 'ms.tiff'])
            saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '-' Rhythm.param.stat.tail '_all.fig']);
            saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '-' Rhythm.param.stat.tail '_all.jpg']);
            close(h);
        end
    end
     
    if flag_weight
        
            % Weight
            plot_time = 400 ;% max_index; % max_index ; 300ms baseline
            plot_weight = Rhythm.AccyAll.weight(:,plot_time)';
            plot_weight = plot_weight / std(plot_weight);
            load 'Cortex/cortex_grating12';
            cortex.vertices = cortex_grating12.Vertices;
            cortex.faces = cortex_grating12.Faces;
            sources = zeros(15002,1);
            for i = 1:68
                tmp = strsplit(Rhythm.param.scouts_name{i},' @');
                scouts_name{i} = tmp{1};
            end
            for i = 1:68
                idx_scout(i) = find(ismember(scouts_name,cortex_grating12.Atlas(2).Scouts(i).Label));
                sources(cortex_grating12.Atlas(2).Scouts(i).Vertices) = plot_weight(idx_scout(i));
            end
            plot_surface(cortex,sources);
            colorbar;
        
            [max_weight, max_weight_index] = max(plot_weight);
            max_name = strsplit( Rhythm.param.scouts_name{max_weight_index} , ' @' );
            max_name = max_name{1};
            disp(['Max:   ' num2str(max_weight) '   No.' num2str(max_weight_index) '   ' max_name]);
        
            [min_weight, min_weight_index] = min(plot_weight);
            min_name = strsplit( Rhythm.param.scouts_name{min_weight_index} , ' @' );
            min_name = min_name{1};
            disp(['Min:   ' num2str(min_weight) '   No.' num2str(min_weight_index) '   ' min_name]);
        
            h_title = title([SubjectName '      ' RhythmMode '      ' SensorMode '      ', num2str(plot_time+min(Time)*1000), 'ms      Weight'], 'FontSize', 15 );
            if (flag_save)
                set(h,'Position',[1 1 1400 900]);
                set(h,'PaperPositionMode','auto');
                set(gca,'FontSize',25);
                set(h_title,'FontSize', 20);
                print(h,[jpg_file_name 'Weight__' num2str(plot_time+min(Time)*1000) 'ms_' max_name '_' min_name '.jpg'],'-djpeg','-r0');
                close(h);
            end
        
    end
    
    if flag_weight_movie
        
        %% Weight movie
        figure;
        lighting gouraud
        axis equal
        axis off
        axis vis3d
        ax = gca;
        h = cameratoolbar('show');
        cameratoolbar('ResetSceneLight');
        
        load 'Cortex/cortex_grating12';
        cortex.vertices = cortex_grating12.Vertices;
        cortex.faces = cortex_grating12.Faces;
        sources = zeros(15002,1);
        colorbar; colormap(jet);caxis([-4 4]);
        material dull
        lighting gouraud
        set(gcf,'color','white');
        hcamlight = camlight;
        view(0,0);
        
        i_source = 1;        
        for i_time = in_time
            plot_weight_movie = Rhythm.AccyAll.weight(:,i_time);
            plot_weight_movie = plot_weight_movie / std(plot_weight_movie);
            
            for i = 1:68
                sources(cortex_grating12.Atlas(2).Scouts(i).Vertices,i_source) = plot_weight_movie(i);
            end
            i_source = i_source + 1;
        end
        clear cortex_grating12;
        for i_time = in_time
            % plot surface
            ndx_source = find(in_time==i_time);
            patch(cortex,'FaceColor','interp','EdgeColor','none','FaceVertexCData',sources(:,ndx_source),'faceAlpha',1);
            title( [RhythmMode '      Time: ' num2str(i_time+min(Time)*1000) 'ms' ]  );
            %pause(0.0001);
            pause;
        end
    end
    
    if (flag_diff)
%         %% matric figure
%         % figure at some time point
%         % clear clc
%         plot_time = max_index; % 100-min(Time)*1000 : 100 : 100-min(Time)*1000;
%         plot_Matrix = Rhythm.AccyAll.matrix;
%         % plot_matrix = Rhythm.Diff15.matrix;
%         
%         for i = 1:length(plot_time)
%             h = figure;imagesc(plot_Matrix(:,:,plot_time(i)));colorbar;caxis([YMIN YMAX])
%             [z1,z2] = size(plot_Matrix(:,:,plot_time(i)));
%             axis equal; axis([0.5 z1+0.5 0.5 z2+0.5]);
%             h_title = title([SubjectName '      ' RhythmMode '      ' SensorMode '      Time = ', num2str(plot_time(i)+min(Time)*1000), 'ms'], 'FontSize', 15 );
%             set(gca,'FontSize',15);
%             max_accuracy  = max( nonzeros( plot_Matrix(:,:,plot_time(i)) ) );
%             min_accuracy  = min( nonzeros( plot_Matrix(:,:,plot_time(i)) ) );
%             display([ 'Matrix: ' num2str(min_accuracy,3) '% ~ ' num2str(max_accuracy,3) '%']);
%             if (flag_save)
% %                 saveas(h,[jpg_file_name 'Matrix__' num2str(max_accuracy,3) '%_' num2str(min_accuracy,3) '%.tiff'])
%                 set(h,'Position',[1 1 1400 900]);
%                 set(h,'PaperPositionMode','auto');
%                 set(gca,'FontSize',25);
%                 set(h_title,'FontSize', 20);
%                 saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '_diff.fig']);
%                 close(h);
%             end
%         end
%         
%         
%         
%         %% two condition
%         CONDA = 1;
%         CONDB = 2;
%         condA = max(CONDA,CONDB); condB = min(CONDA,CONDB);
%         clear Data;
%         Data{1}.mean = squeeze( Rhythm.AccyAll.matrix(condA,condB,:) )';
%         Data{1}.color = 'k';
%         title_text = [SubjectName '      ' RhythmMode '      ' SensorMode '      Condition ' num2str(condB) ' & Condition ' num2str(condA)];
%         
%         h_TwoCond = RStep3Z_subfunction_plot(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);
%         
%         [max_accuracy_TwoCond, max_index_TwoCond] = max(Data{1}.mean);
%         if (flag_save)
%             %     saveas(h_TwoCond,[jpg_file_name 'TwoCond__' num2str(condB) '&' num2str(condA) '.tiff'])
%             close(h_TwoCond);
%         end
%         
%         
        %% different orientation differences
        clear Data;
        Data{1} = Rhythm.Diff90;
        Data{1}.color = 'r-';
        Data{2} = Rhythm.Diff60;
        Data{2}.color = 'b-';
        Data{3} = Rhythm.Diff30;
        Data{3}.color = 'g-';
        title_text = [SubjectName '      ' RhythmMode '      ' SensorMode '      Differences'];
        
        [h, legend_line] = RStep3Z_subfunction_plot(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);
        
        %l = legend (legend_line(1:3),'Diff90','Diff60','Diff30');
        %set(l, 'box', 'off','FontSize',30,'Position',[0.65 0.7 0.6 0.2]);
        
        if (flag_save)
%             saveas(h_Diff,[jpg_file_name 'Diff.tiff']);
            saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '-' Rhythm.param.stat.tail '_diff.fig']);
            saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '-' Rhythm.param.stat.tail '_diff.jpg']);
            close(h);
        end
    end
    
    
    if flag_Cardinal
        %% Cardinal & Oblique
        clear Data;
        Data{1} = Rhythm.Cardinal;
        Data{1}.color = 'k-';
        Data{2} = Rhythm.Oblique;
        Data{2}.color = 'k--';
        title_text = [SubjectName '      ' RhythmMode '      ' SensorMode '      Cardinal'];
        
        [h, legend_line] = RStep3Z_subfunction_plot(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);
        
        %l = legend (legend_line(1:2),'Cardinal', 'Oblique');
        %set(l, 'box', 'off','FontSize',30,'Position',[0.65 0.7 0.6 0.2]);
        
        if (flag_save)
%             saveas(h,[jpg_file_name 'Cardinal.tiff'])
            saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '-' Rhythm.param.stat.tail '_cardinal.fig']);
            saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '-' Rhythm.param.stat.tail '_cardinal.jpg']);
            close(h);
        end
        
        %% Cardinal 30 60 90
        clear Data;
        Data{1} = Rhythm.Cardinal90;
        Data{1}.color = 'r-';
        Data{2} = Rhythm.Cardinal60;
        Data{2}.color = 'b-';
        Data{3} = Rhythm.Cardinal30;
        Data{3}.color = 'g-';
        Data{4} = Rhythm.Oblique90;
        Data{4}.color = 'r--';
        Data{5} = Rhythm.Oblique60;
        Data{5}.color = 'b--';
        Data{6} = Rhythm.Oblique30;
        Data{6}.color = 'g--';
        
        title_text = [SubjectName '      ' RhythmMode '      ' SensorMode '      Cardinal & Differences'];
        
        h = RStep3Z_subfunction_plot(Data, Time, YMIN, YMAX, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);
        
        legend ('Cardinal90','Cardinal60','Cardinal30','Oblique90','Oblique60','Oblique30');
        
%         if (flag_save)
%             saveas(h,[jpg_file_name 'Cardinal369.tiff'])
%             saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '_cardinal369.fig']);
%             saveas(h,[save_location RhythmMode '_' num2str(Rhythm.param.stat.alpha) '_' num2str(Rhythm.param.stat.cluster_th) '_cardinal369.jpg']);        
%             close(h);
%         end
        
    end
    
    
    
    %%
    if flag_CO
        %% Cardinal - Oblique
        clear Data;
        Data{1}.mean = Rhythm.Cardinal.mean  - Rhythm.Oblique.mean;  % Rhythm.Cardinal.mean  - Rhythm.Oblique.mean;
        Data{1}.color = 'k-';
        title_text = [SubjectName '      ' RhythmMode '      ' SensorMode '      Cardinal - Oblique'];
        
        h = RStep3Z_subfunction_plot(Data, Time, YMIN_CO, YMAX_CO, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);
        legend ('CO');
        
        [max_accuracy_CO, max_index_CO] = max(Data{1}.mean);
        display([ 'CO_max: ' num2str(max_accuracy_CO,3) '% , ' num2str(max_index_CO+min(Time)*1000) 'ms' ]);
        
        if (flag_save)
%             saveas(h,[jpg_file_name 'CO__' num2str(max_accuracy_CO,3) '%_' num2str(max_index_CO+min(Time)*1000) 'ms.tiff'])
            print(h,[jpg_file_name 'CO__' num2str(max_accuracy_CO,3) '%_' num2str(max_index_CO+min(Time)*1000) 'ms.jpg'],'-djpeg','-r0');
            close(h);
        end
        
        %% Cardinal 30 60 90
        clear Data;
        Data{1}.mean = Rhythm.Cardinal90.mean - Rhythm.Oblique90.mean;
        Data{1}.color = 'r-';
        Data{2}.mean = Rhythm.Cardinal60.mean - Rhythm.Oblique60.mean;
        Data{2}.color = 'b-';
        Data{3}.mean = Rhythm.Cardinal30.mean - Rhythm.Oblique30.mean;
        Data{3}.color = 'g-';
        
        title_text = [SubjectName '      ' RhythmMode '      ' SensorMode '      Cardinal - Oblique'];
        
        h = RStep3Z_subfunction_plot(Data, Time, YMIN_CO, YMAX_CO, stimulate_end_time,title_text,flag_smooth,smooth_vector,flag_save);
        
        legend ('CO90','CO60','CO30');
        
        if (flag_save)
%             saveas(h,[jpg_file_name 'CO369.tiff'])
            print(h,[jpg_file_name 'CO369.jpg'],'-djpeg','-r0');
            close(h);
        end
    end
end
end
