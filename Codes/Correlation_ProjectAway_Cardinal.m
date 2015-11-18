clear;clc; close all;
addpath(genpath('Functions'));
ProjectName = 'sheng';   %%%%%
RhythmMode = {'evoked','ivectorlow','ivectorhigh'}; % % 'evoked' 'ivectorlow' 'ivectorhigh' 'isingle10' 'vectorlow'
SensorMode = 'all'; % 'batch' 'all' 'scouts'
Compare_Field = 'C';
file_location = [ '/dataslow/sheng/Project of Sheng/Results/' ProjectName ];

%% load file
for cond = 1:3
    %for i_subject = [0]  SubjectName = '14gratings316'; YMIN = 20; YMAX = 100; YMIN_CO = -25; YMAX_CO = 40;
    for i_subject = [3:16]  SubjectName = ['grating' num2str(i_subject, '%0.2d')]; YMIN = 20; YMAX = 100; YMIN_CO = -50; YMAX_CO = 60;
       if (strcmp(RhythmMode{cond},'evoked') || RhythmMode{cond}(2) == 'v')
            mat_location = [ file_location '/Mat_' RhythmMode{cond}];
            SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
            file_load = [ 'II_' SubjectName '_' RhythmMode{cond} '_' SensorMode '.mat'];
            load( [mat_location '/' file_load]);
            Original(i_subject - 2,:,:,:) = Rhythm.AccyAll.matrix;
        else
            mat_location = [ file_location '/Mat_TFA_isingle/Accy_gratings_isingles'];
            SubjectName = ['grating' num2str(i_subject, '%0.2d')]; 
            file_load = [ 'ACCY_' SubjectName '_' RhythmMode{cond} '_' SensorMode '.mat'];
            load( [mat_location '/' file_load]);
            Original(i_subject - 2,:,:,:) = Rhythm.AccyAll.matrix;
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

%% Project matrix to oblique or cardinal
for subject = 1:14
    for t=1:1901
        Projection(subject,:,t) = squareform(Original(subject,:,:,t)) * ProjectAway_Cardinal;
    end
end

for s1 = 1:14 
    CC(:,:,k) = corr(Projection(s1,:,:), 'type','Pearson'); %Msq(:,:,s) should be condxtime
end

imagesc(mean(CC, 1));

end

