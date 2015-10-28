function [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_1sample(data,nResample,alpha,tail,PermMatrix)
% function [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_1sample(data,nResample,alpha,tail,PermMatrix)
%
% One-smaple and paired-sample permutation test based on t-statistics.
%
% Performs permutations of rows of data, randomly multiplying with +/-1, and finds thresholds 
% that control for false positives. 
%
% The statistic used is a t-test. If data has rows x1, x2, ...xn,
% then the t-statistic is: T = mean_i{xi} / (sd/sqrt(n)), where sd is the vector of standard deviations of the
% elements of x.
%
% nResample (typically 1000) permutation samples are created by
% randomly multiplying with +/-1 each row of data. t-statistic maps 
% are created for the permuted data similarly to the original data.
%
% For the permutation threshold, we use the maximum statistic approach. 
% The maximum t-statistic over variables is calculated for each
% permutation sample. This results in nResample maximum statistic values 
% (returned in the variable Perm.MaxStatistic), which are then used to build
% an empirical histogram of the maximum statistic. The value that leaves alpha
% percent of the histogram on the right side is the threshold which is applied
% to the original statistical map, to produce Perm.StatMapTh.
%
% For the False Discovery Rate (FDR) procedure, the same permutation
% samples are used to estimate the local distribution of each variable
% in the StatMap. Using this distribution, we convert the
% t-statistics into p-values, returned in the StatMapPv matrix. The FDR
% procedure is applied to the p-value map to estimate a threshold
% FDR.Threshold, which is applied to the data.
%
% One-tail or two-tail tests can be used. The difference is that in the
% latter case the absolute value of the t-statistics is used for all
% calculations. The one-tail test has as alternative hypothesis condition
% data > 0.
%
% For more information of the permutation approach, see: Pantazis et al.
% "A comparison of random field theory and permutation methods for the 
% statistical analysis of MEG data", Neuroimage 25(2):383-394 
%
% INPUTS:
%   data              Matrix with dimensions nObservations x nVariables. For example, measuring 100 trials from 10 electrodes will have nObservations = 100, nVariables = 10.
%   nResample          (default 1000) Number of permutation samples 
%   alpha              (default 0.05) Control level of false positives
%   tail               (default 'twotail') String with values 'onetail' or 'twotail'. Defines whether to use one-tail (data>0) or two-tail (|data|>0) test.
%                      For the two-tail test, abs(t-statistic) is used.
%   PermMatrix         (optional) Structure in the form PermMatrix{nResample} = [nTrials x 1] containing 1s and -1s.
%                      It defines permutations, where 1 keeps the original, and -1 flips conditions A and B.
%
% OUTPUTS:
%   StatMap            Vector (nVariables x 1) of the t-statistic map
%   StatMapPv          Vector (nVariables x 1) of the uncorrected p-values
%   Perm.Threshold     Permutation threshold (in t-test units)
%       .StatMapTh     Thresholded statistical map
%       .MaxStatistic  Vector (nResample x 1) of the maximum statistic for each permutation sample
%   FDR.Threshold      False Discovery Rate threshold (in pvalue units)
%      .StatMapTh      Thresholded statistical map
%   PermMatrix         Permutations used to create thresholds 
%
% EXAMPLE:
%   clear;clc;
%   nResample = 100;
%   alpha = 0.05;
%   tail = 'twotail';
%   data = rand(11,22); %null data, 100 trials, 10 electrodes
%   [StatMap,StatMapPv,Perm,FDR,PermMatrix] = permutation_paired(data,nResample,alpha,tail);
%
% Author: Dimitrios Pantazis, January 2015

%initialize
nTrials = size(data,1);
if ~exist('nResample')  
    nResample = 1000;  
end
if ~exist('alpha','var')
    alpha = 0.05;
end
if ~exist('tail') || strcmp(tail,'twotail') %if two tail t-test
    func = 'abs';
else %if one tail t-test
    func = '';
end
%Create PermMatrix (1: keep original, -1: exchange group A and group B)
if ~exist('PermMatrix')
    for i=1:nResample
        PermMatrix{i} = sign(rand(1,nTrials)-0.5);
    end
end
PermMatrix{1} = ones(1,nTrials); %make sure first sample is the original data
MaxS = zeros(nResample,1); %maximum statistic

%statistic of original data
M = mean(data);
Std = std(data)/sqrt(nTrials);
StatMap = M./Std;

%maximum of original data (to be included in the permutation samples)
eval(['MaxS(1) = max(' func '(StatMap(:)));']);
StatMapPv = ones(size(StatMap)); % statistic map of pvalues

%perform permutations
for i = 2:nResample %for all permutation samples

    %permute, which is equivalent to multiplying with 1 or -1
    data_perm = diag(PermMatrix{i})*data;

    %compute paired t statistic
    M = mean(data_perm);
    Std = std(data_perm)/sqrt(nTrials);
    StatPerm = M./Std;
    
    %Pvalues for each source (number of counts for now)
    eval(['StatMapPv = StatMapPv + (' func '(StatPerm) >= ' func '(StatMap));']);

    %maximum of permutation
    MaxS(i) = eval(['max(' func '(StatPerm))']);

end

%Fix Pvalues
StatMapPv = StatMapPv / nResample;

%FDR threshold
pv = sort(StatMapPv(:)); %sorted pvalues
N = length(pv); %number of tests
l = (1:N)'/N * alpha; %FDR line
%plot(pv);hold on;plot(l);
crossings = find( pv>l == 0); 
if ~isempty(crossings) %if the two lines cross
    FDR.Threshold = l(max(find( pv>l == 0))); %highest crossing point
else
    FDR.Threshold = 0;
end

%Permutation threshold
Perm.MaxStatistic = sort(MaxS);
Perm.Threshold = Perm.MaxStatistic(floor(nResample*(1-alpha)+1));

%Find significant activation
eval([ 'exceedTh = ' func '(StatMap) > Perm.Threshold;' ]);
Perm.StatMapTh = exceedTh .* StatMap;
eval([ 'exceedTh = ' func '(StatMapPv) <= FDR.Threshold;' ]);
FDR.StatMapTh = exceedTh .* StatMap;






