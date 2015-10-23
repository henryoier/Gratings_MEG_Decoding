function [clustermax,nclusters,clusters,clustersize] = find_clusters_alld(rf,th)
% function [clustermax,nclusters,clusters,clustersize] = find_clusters_alld(rf,th)
%
% Finds clusters in random fields of any dimension
% 
% INPUTS:
%   rf: random field (array of any dimension)
%   th: cluster defining threshold  
%
% Author: Dimitrios Pantazis, 7/9/2014

%initialize
dim = length(size(rf)); %random field dimension
nvoxels = prod(size(rf)); %number of voxels
ndx = find(rf>=th); %index of suprathreshold voxels
nsupvoxels = length(ndx); %number of suprathreshold voxels
i = 0; %no clusters at the begining
clear clusters;
clusters{1} = []; %empty cluster
supvoxelfound = zeros(nvoxels,1); %no voxels assigned to clusters yet

%if no suprathreshold voxels exist
if isempty(ndx)
    clustermax = 0;
    nclusters = 0;
    clusters = {[]};
    clustersize = 0;
    return
end

%template neighbour coordinates for suprathreshold voxels
expndx = rem(floor([0:3^dim-1]' * 3.^(-dim+1:0)),3) - 1; %build a list of neighbor indexes
s = sum(abs(expndx),2);
expndx(s == 0 | s == dim,:) = []; %remove points with no common edge (all dimensions change) or same point
nv = size(expndx,1); %number of neighbours


for k = 1:nsupvoxels %for all supratheshold voxels

    svox_ndx = ndx(k); %index of suprathreshold voxel
    
    %if voxel already belongs to a cluster 
    if supvoxelfound(svox_ndx) == 1
        continue
    end

    %create new cluster
    i = i+1;
    clusters{i} = svox_ndx; %new cluster
    supvoxelfound(svox_ndx) = 1; %found this voxel
    cluster_exp = svox_ndx; %expand cluster
    
    while ~isempty(cluster_exp) %while the cluster keeps expanding

        %find neighbours
        v = ind2sub_v(size(rf),cluster_exp); %index of new points
        vexp = reshape(repmat(v,1,nv)',size(v,2),size(v,1)*nv)'; %repeat points nv times rowwise
        vexp = vexp + repmat(expndx,size(v,1),1); %coordinates of new points
        vexp = unique(vexp,'rows'); %keep unique points
        
        %remove outside points
        [ndx1,~] = find(vexp==0); %at 0
        [ndx2,~] = find(vexp - ones(size(vexp,1),1)*(size(rf)+1)==0); %above max dim
        vexp([ndx1; ndx2],:) = [];
        
        %expand cluster
        cluster_exp = sub2ind_v(size(rf),vexp'); %convert to linear index
        cluster_exp(supvoxelfound(cluster_exp)==1)=[]; %remove already found voxels
        cluster_exp = cluster_exp(find(rf(cluster_exp)>=th)); %keep only suprathreshold voxels
        cluster_exp = setdiff(cluster_exp,clusters{i}); %keep only voxels that don't already exist in cluster
        clusters{i} = [clusters{i} cluster_exp]; %expand cluster
        supvoxelfound(cluster_exp) = 1; %found voxels
        
    end
end

%get max cluster size
nclusters = size(clusters,2);
clustermax = size(clusters{1},2);
clustersize(1) = length(clusters{1});
for i = 2:nclusters
    clustermax = max(clustermax,size(clusters{i},2));
    clustersize(i) = length(clusters{i});
end


