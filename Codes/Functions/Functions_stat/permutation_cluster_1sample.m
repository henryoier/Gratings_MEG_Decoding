function [SignificantTimes, clusters,clustersize,StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, significance_th,StatMapPermPV)
% function [SignificantTimes, clusters,clustersize,StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, significance_th,StatMapPermPV)
%
% Performs one-sided cluster-size test on data values. 
% 
% OUTPUT:
%   Significant Times:  times with significant clusters
%   clusters:           clusters above cluster defining threshold
%   clustersize:        size of identified culsters
%
% Author: Dimitrios Pantazis

ComputerCluster = 0; %openmind cluster?

if ComputerCluster
    matlabpool(5); %how many cpus?
end


%if pvalues have not been precomputed
if ~exist('StatMapPermPV')
    
    %initialize
    [nsamples ntimes] = size(data);
    StatMapPerm = single(zeros(nperm,ntimes));
        
    %first permutation sample is original data
    StatMapPerm(1,:) = mean(data,1) ./ std(data);
    
    %perform permutations
    parfor i = 2:nperm
        if ~rem(i,100)
            disp(['permutation: ' num2str(i) ' out of ' num2str(nperm)]);
        end
        if ~rem(i,1000)
            disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
        end
        perm = single(sign(rand(nsamples,1)-0.5));
        data_perm = diag(perm) * data;
        StatMapPerm(i,:) = mean(data_perm,1) ./ std(data_perm);
    end
    %convert to pvalues
    StatMapPermPV = (nperm+1 - tiedrank(StatMapPerm))/nperm;

end

%find maximum statistic (cluster size)
[clustermax(1),nclusters,clusters,clustersize] = find_clusters_alld(StatMapPermPV(1,:)<=cluster_th,cluster_th);
parfor i = 2:nperm
    if ~rem(i,100)
        disp(['permutation: ' num2str(i) ' out of ' num2str(nperm)]);
    end
    if ~rem(i,1000)
        disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
    end
    [clustermax(i)] = find_clusters_alld(StatMapPermPV(i,:)<=cluster_th,cluster_th);
end
    
clustermax_sorted = sort(clustermax);
th = clustermax_sorted(nperm*(1-significance_th));

SignificantTimes = [clusters{clustersize>th}];

if ComputerCluster
    matlabpool close %only for cluster
end

