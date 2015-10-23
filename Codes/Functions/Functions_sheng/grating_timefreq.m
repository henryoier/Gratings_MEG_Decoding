function [output_TF] = grating_timefreq(Data, Time, OPTIONS,RhythmMode)
%   Using morlet transformation to compute time-frequency decompositions of the signals.
%   
%   [output_TF] = grating_timefreq(Data, Time, OPTIONS,RhythmMode)
%
%============================================================
%   input:
%       Data        -   Signal data
%       Time        -   Time series with 0.001s as resolution
%       OPTIONS     -   Option of frequency
%       RhythmMode  -   'evoked' 'vectorlow' 'vectorhigh' 'single30' etc.
% 
%-------------------------------------------------------------
%   output:
%       output_TF   -   time-frequency decomposion of the signal
% 
%=============================================================
%   adapted from Mingtong
%
%   version 1.0 -- Oct./2015
% 
%   written by Sheng Qin(shengqin [AT] mit (DOT) edu)

%  Remove mean of the signal
Data = Data - repmat( mean(Data,2), 1, size(Data,2));

% Compute wavelet decompositions
% Timefreq_tmp = 306_sensors * 1901_Time * 2_Freqs
OPTIONS.TimeVector = Time;
Timefreq_tmp = morlet_transform(Data, OPTIONS.TimeVector, OPTIONS.Freqs, OPTIONS.MorletFc, OPTIONS.MorletFwhmTc, 'y');


% Timefreq_tmp = 712_vector (306_sensors * 2_Freqs) * 1901_Time
if ( strcmp(RhythmMode(1:4),'mean')  )
    output_TF  = mean(Timefreq_tmp,3);
else
    output_TF  = [];
    for i_freq = 1:length(OPTIONS.Freqs)
        output_TF  = [ output_TF; Timefreq_tmp(:,:,i_freq) ];
    end
end
