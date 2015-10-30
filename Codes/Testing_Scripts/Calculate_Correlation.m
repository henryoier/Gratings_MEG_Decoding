load('/dataslow/sheng/Project of Sheng/Results/sheng/Mat_ivectorlow/II_14gratings316_ivectorlow_all.mat');
Low = Rhythm.AccyAll.matrix;
load('/dataslow/sheng/Project of Sheng/Results/sheng/Mat_ivectorhigh/II_14gratings316_ivectorhigh_all.mat');
High = Rhythm.AccyAll.matrix;

for t = 1:size(squeeze(Low(1,1,:)))
    Correlation(:,t) = corr2(squareform(Low(:,:,t)),squareform(High(:,:,t)));
end

plot(Correlation);