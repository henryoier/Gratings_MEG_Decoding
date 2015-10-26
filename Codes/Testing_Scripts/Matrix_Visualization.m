%% Part1: Matrix Visualization
figure;
imagesc(AccuracyMEG(:,:,1));
colormap(jet);
colorbar;
set(gca,'FontSize',13);
%% Part2: TimeSeries Visualization
figure;
for i = 1:1900
    
plot(squeeze(AccuracyMEG(2,1,:)));