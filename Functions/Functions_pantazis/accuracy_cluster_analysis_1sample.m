function [SignificantTimes, clusters,clustersize,StatMapPermPV] = accuracy_cluster_analysis_1sample(Accuracy, nperm, cluster_th, significance_th,StatMapPermPV)
% function [SignificantTimes, clusters,clustersize,StatMapPermPV] = accuracy_cluster_analysis_1sample(Accuracy, nperm, cluster_th, significance_th,StatMapPermPV)
%
% Performs one-sided test on Accuracy values. 
%

matlabpool(8);


%if pvalues have not been precomputed
if ~exist('StatMapPermPV')
    
    %initialize
    [nsamples ntimes] = size(Accuracy);
    StatMapPerm = single(zeros(nperm,ntimes));
    
    %make data zero mean (assume expressed as percent, so remove 50% chance level)
    Accuracy = Accuracy - 50;
    
    %first permutation sample is original data
    StatMapPerm(1,:) = mean(Accuracy,1) ./ std(Accuracy);
    
    %perform permutations
    parfor i = 2:nperm
        if ~rem(i,200)
            disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
        end
        perm = single(sign(rand(nsamples,1)-0.5));
        Accuracy_perm = diag(perm) * Accuracy;
        StatMapPerm(i,:) = mean(Accuracy_perm,1) ./ std(Accuracy_perm);
    end
    %convert to pvalues
    [~,StatMapPermPV] = sort(StatMapPerm,1,'descend');
    StatMapPermPV = StatMapPermPV/nperm;

end

%find maximum statistic (cluster size)
[clustermax(1),nclusters,clusters,clustersize] = find_clusters_alld(StatMapPermPV(1,:)<=cluster_th,cluster_th);
parfor i = 2:nperm
    if ~rem(i,200)
        disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
    end
    [clustermax(i)] = find_clusters_alld(StatMapPermPV(i,:)<=cluster_th,cluster_th);
end
    
clustermax_sorted = sort(clustermax);
th = clustermax_sorted(nperm*(1-significance_th));

SignificantTimes = [clusters{clustersize>th}];

matlabpool close

