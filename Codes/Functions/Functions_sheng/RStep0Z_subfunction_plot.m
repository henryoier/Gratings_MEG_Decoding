function h = RStep0_RhythmAnalysis_plot(Timefreq,Time,Freqs,flag_save_jpg,title_text,cmax)
%   plot time-frequency power
% 
%   h = RStep0_RhythmAnalysis_plot(Timefreq, Time, Freqs, flay_save_jpg, title_text, cmax)
%==========================================================
%   Input:
%       Timefreq        -   Result of TF decomposition
%       Time            -   Time series in 0.001s resolution 
%       Freqs           -   Freqency series, eg:[1:1:100]
%       flag_save_jpg   -   save image when flag_save_jpg == 1
%       title_text      -   text on graph title
%       cmax            -   color range, 
%                           eg:max(max(abs(Timefreq.evoked_percentage)))
%-----------------------------------------------------------
%   Output:
%        h               -   Time-Frequence-Power Image
%===========================================================
%   
%   Version 1.0 -- Oct. 2015 
%  
%   Written by Sheng Qin(shengqin [AT] mit (DOT) edu)
%

h = figure;
text_size = 13;
if (flag_save_jpg) 
    set(h,'Position',[1 1 1400 900]); 
    set(h,'PaperPositionMode','auto');
    text_size = 25;
end

imagesc(Time,Freqs,Timefreq);
colorbar;
colormap(jet);
set(gca,'YDir','normal');
line('XData', [0 0], 'YData', [min(Freqs),max(Freqs)], 'LineStyle', '-', 'LineWidth', 1, 'Color',[0.5 0.5 0.5])
line('XData', [0.8 0.8], 'YData', [min(Freqs),max(Freqs)], 'LineStyle', '-', 'LineWidth', 1, 'Color',[0.5 0.5 0.5])
set(gca,'FontSize',13);

%caxis([-cmax,cmax]);

title(title_text, 'FontSize', text_size)
set(gca,'FontSize',text_size);

