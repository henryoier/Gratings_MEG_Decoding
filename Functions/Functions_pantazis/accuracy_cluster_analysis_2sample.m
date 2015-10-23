function [SignificantTimes, clusters,clustersize,StatMapPermPV] = accuracy_cluster_analysis_2sample(Accuracy1,Accuracy2, nperm, cluster_th, significance_th,StatMapPermPV)
% function [SignificantTimes, clusters,clustersize,StatMapPermPV] = accuracy_cluster_analysis_2sample(Accuracy, nperm, cluster_th, significance_th,StatMapPermPV)
%
% Performs one-sided test on Accuracy values. 
%

matlabpool(8);

%if pvalues have not been precomputed
if ~exist('StatMapPermPV')

    %initialize
    [nsamples1 ntimes] = size(Accuracy1);
    [nsamples2 ntimes] = size(Accuracy2);
    StatMapPerm = single(zeros(nperm,ntimes));
    
    %first permutation sample is original data
    M = mean(Accuracy1,1) - mean(Accuracy2,1);
    var1 = var(Accuracy1);
    var2 = var(Accuracy2);
    Std = sqrt( var1/nsamples1 + var2/nsamples2 );
    StatMapPerm(1,:) = M./Std;
    
    %combine data
    Accuracy12 = [Accuracy1 ; Accuracy2];
    clear Accuracy1 Accuracy2;
    
    %perform permutations
    parfor i = 2:nperm
        if ~rem(i,1000)
            disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
        end
        permndx = randperm(nsamples1 + nsamples2);
        Accuracy1_perm = Accuracy12(permndx(1:nsamples1),:);
        Accuracy2_perm = Accuracy12(permndx(1 + nsamples1:nsamples1 + nsamples2),:);
        
        %compute unpaired t-statistic
        M = mean(Accuracy1_perm,1) - mean(Accuracy2_perm,1);
        var1 = var(Accuracy1_perm);
        var2 = var(Accuracy2_perm);
        Std = sqrt( var1/nsamples1 + var2/nsamples2 );
        StatMapPerm(i,:) = M./Std;
    end
    %convert to pvalues
    [~,StatMapPermPV] = sort(StatMapPerm,1,'descend');
    StatMapPermPV = StatMapPermPV/nperm;

end

%find maximum statistic (cluster size)
[clustermax(1),nclusters,clusters,clustersize] = find_clusters_alld(StatMapPermPV(1,:)<=cluster_th,cluster_th);
parfor i = 2:nperm
    if ~rem(i,1000)
        disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
    end
    [clustermax(i)] = find_clusters_alld(StatMapPermPV(i,:)<=cluster_th,cluster_th);
end
    
clustermax_sorted = sort(clustermax);
th = clustermax_sorted(nperm*(1-significance_th));

SignificantTimes = [clusters{clustersize>th}];

matlabpool close

