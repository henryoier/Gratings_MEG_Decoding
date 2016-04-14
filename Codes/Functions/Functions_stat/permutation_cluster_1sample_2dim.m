function [SignificantTimes, clusters,clustersize,StatMapPermPV] = permutation_cluster_1sample_2dim(data, nperm, cluster_th, significance_th,clusterflag,StatMapPermPV)
% function [SignificantTimes, clusters,clustersize,StatMapPermPV] = permutation_cluster_1sample(data, nperm, cluster_th, significance_th,StatMapPermPV)
%
% Performs one-sided cluster-size test on data values.
%

% % for example:
%   clear;clc;
%   load data;
%   nperm = 1000;
%   cluster_th = 0.01;
%   significance_th = 0.05;

% OUTPUT:
%   Significant Times:  times with significant clusters
%   clusters:           clusters above cluster defining threshold
%   clustersize:        size of identified culsters
%
% Author: Dimitrios Pantazis

if ~exist('clusterflag')
    clusterflag = 0; %openmind cluster?
end

if clusterflag
    parpool(10); %how many cpus?
end

startmatlabpool(10);

%if pvalues have not been precomputed
if ~exist('StatMapPermPV')
    
    %initialize
    [nsamples ntimes1 ntimes2] = size(data);
    StatMapPerm = single(zeros(nperm,ntimes1,ntimes2));
    %first permutation sample is original data
    StatMapPerm(1,:,:) = mean(data,1) ./ std(data);
    
    
    %perform permutations
    
    parfor i = 2:nperm
    %for i = 2:nperm
        if ~rem(i,100)
            disp(['permutation: ' num2str(i) ' out of ' num2str(nperm)]);
        end
        if ~rem(i,1000)
            disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
        end
        perm = single(sign(rand(nsamples,1)-0.5));
        data_perm = repmat(perm,1,ntimes1,ntimes2) .* data;
        StatMapPerm(i,:,:) = mean(data_perm,1) ./ std(data_perm);
        
    end
    
    %convert to pvalues
    StatMapPermPV = (nperm+1 - tiedrank(StatMapPerm))/nperm;
    
end
clear StatMapPerm;

%find maximum statistic (cluster size)
[clustermax(1),nclusters,clusters,clustersize] = find_clusters_alld(squeeze(StatMapPermPV(1,:,:)<=cluster_th) , cluster_th);
parfor i = 2:nperm
%for i = 2:nperm
    if ~rem(i,100)
        disp(['permutation: ' num2str(i) ' out of ' num2str(nperm)]);
    end
    if ~rem(i,1000)
        disp([num2str(i) ' out of ' num2str(nperm) ' permutations']);
    end
    [clustermax(i)] = find_clusters_alld(StatMapPermPV(i,:,:)<=cluster_th,cluster_th);
end

clustermax_sorted = sort(clustermax);
th = clustermax_sorted(nperm*(1-significance_th));

% SignificantTimes = [clusters{clustersize>th}];
SignificantTimes_raw = [clusters{clustersize>th}];
SignificantTimes = zeros( [size(data,2),size(data,3)] );
for i = 1:length(SignificantTimes_raw )
    v = ind2sub_v( [size(data,2),size(data,3)] ,SignificantTimes_raw(i));
    SignificantTimes(v(1),v(2)) = 1;
end

% imagesc(SignificantTimes);set(gca,'YDir','normal');

closematlabpool;
