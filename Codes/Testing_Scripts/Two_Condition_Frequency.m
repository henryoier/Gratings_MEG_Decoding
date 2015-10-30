load('/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA/Accuracy_gratings_isingles/Accuracy_14gratings316_RhmMdisingle2-80_SnsrMdall_p100_groupall.mat');

Accuracy = zeros(40,40,1901);

addpath(genpath('../Functions'));

startmatlabpool(24);

for time = [1:1901]
    for fq1 = [2:2:80]
        for fq2 = [2:2:80]
            Accuracy(fq1/2,fq2/2,time) = corr2(squareform(squeeze(AccuracyAll(fq1,:,:,time))),squareform(squeeze(AccuracyAll(fq2,:,:,time))));
        end
    end
end

figure;
colorbar;
colormap(jet);
imagesc(squeeze(Accuracy(:,:,300)));

save('/dataslow/sheng/Project of Sheng/Results/sheng/Mat_TFA/Accuracy_gratings_isingles/TT_14gratings316_RhmMdisingle2-80.mat');
