% parameters_analysis;

if strcmp(RhythmMode, 'evoked')
    param.f_lowpass = 30;   % low-pass filter for evoked
else
    param.f_lowpass = 200;
end

if clusterflag
    param.brainstorm_db = ['[CLUSTER PATH]' ProjectName '/data'];
else
    param.brainstorm_db = ['/dataslow/sheng/Project of Sheng/brainstorm_db/' ProjectName '/data'];
end

param.data_type = 'MEG';
param.SensorMode = SensorMode;
param.ProjectName = ProjectName;
param.SubjectName = SubjectName;
param.RhythmMode = RhythmMode;


% RhythmMode Method =  
%       'evoked':
%                   raw 352 trials -> 30Hz low-pass filter -> standardize -> average every 87 trials -> SVM (3 train, 1 test)
%       'vectorhigh' / 'vectorlow' / 'single30' (50~58Hz / 24~32Hz / 30Hz): 
%                   352 trials -> 200Hz LP filter -> std -> time-frequency (SVM vector *5 / *5 / *1) -> average every 87 trials -> percentage -> SVM (3 train, 1 test)
%       'evectorhigh' / 'evectorlow' / 'esingle30': 
%                   352 trials -> 200Hz LP filter -> std -> average every 87 trials -> time-frequency (SVM vector *5 / *5 / *1) -> percentage  -> SVM (3 train, 1 test)
%       'ivectorhigh' / 'ivectorlow' / 'isingle30': 
%                   352 trials -> 200Hz LP filter -> std -> induced -> time-frequency (SVM vector *5 / *5 / *1) -> average every 87 trials -> percentage -> SVM (3 train, 1 test)

switch RhythmMode
    case {'evoked', 'total', 'induced'}
        OPTIONS.Freqw = [50:1:58];
    case {'1_100'}  % for RStep0 ryhthm analysis, 1~100Hz
        OPTIONS.Freqs = [1:100];
    case {'vectorlow', 'ivectorlow', 'evectorlow'}      % total/induced/evoked low vector gamma frequency
        OPTIONS.Freqs = [24:2:32];
    case {'vectorhigh', 'ivectorhigh', 'evectorhigh'}   % total/induced/evoked high vector gamma frequency
        OPTIONS.Freqs = [50:2:58];
    case {'test'}
        OPTIONS.Freqs = [40 41];
    otherwise
        singleNumber = strsplit(RhythmMode,'single');   % total/induced/evoked individual frequency
        OPTIONS.Freqs = str2num( singleNumber{2} );
end
    

switch SensorMode
    case {'all', 'scouts'}	% read all 306 sensors / read all 68 scouts
        SensorNames = {};   
    case {'batch'}          % read some sensors
        if strcmp(SubjectName,'grating03')
            SensorNames = {'MEG1931' 'MEG1932' 'MEG1933'...
                'MEG1731' 'MEG1732' 'MEG1733'   'MEG2121' 'MEG2122' 'MEG2123'...
                'MEG2111' 'MEG2112' 'MEG2113'   'MEG1921' 'MEG1922' 'MEG1923'...
                'MEG2321' 'MEG2322' 'MEG2323'   'MEG1721' 'MEG1722' 'MEG1723'}; 
        end
    case 'test'             % for debugging
        SensorNames = {'MEG2113'};
    case 'test7'
        SensorNames = {'MEG2113' 'MEG2111' 'MEG2112' 'MEG1931' 'MEG1932' 'MEG1933' 'MEG2121' };
    otherwise               % only read individual sensor
        SensorNames = {SensorMode};
end
param.SensorNames = SensorNames;

if ( ~strcmp(RhythmMode, 'evoked') )
    OPTIONS.MorletFc = 1;
    OPTIONS.MorletFwhmTc = 3;
    OPTIONS.Measure = 'power';
    OPTIONS.Output = 'average';
    OPTIONS.Method = 'morlet';
    OPTIONS.SensorTypes = 'MEG';
    param.OPTIONS = OPTIONS;
end