% add parameters

clusterflag = str2num(clusterflag);
param.num_permutations = str2num(permutations([2:end]));
param.iitt = iitt;
param.clusterflag = clusterflag;
param.group = group;

param.trial_number = 9999; % this number will be changed when loading trials

