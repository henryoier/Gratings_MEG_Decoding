function [CC,P,Pth,fdr_th] = run_between_subject_analysis(M,time)
% function run_between_subject_analysis(M,time)
%
% INPUT:
% M is a matrix (subj,cond,cond,time)
% 
% OUTPUT:
% CC: matrix (time,time,subjectpairs) of correlation coefficients (across representations)
% P: matrix (time,time) of p-values of CC
% Pth: thresholded pvalue map
% fdr_th: FDR threshold (across all time pairs)

%initialize
[nsubj ncond ncond ntime] = size(M); %Assume input is M(subj,cond,cond,time)
if ~exist('time')
    time = 1:ntime;
end

%convert to squareform
for s = 1:nsubj
    for t = 1:ntime
        %M(:,:,s,t) = tril(M(:,:,s,t),-1); %optional, making sure matrix is lower triangular
        Msq(:,t,s) = squareform(tril(squeeze(M(s,:,:,t)),-1)); %Msq(condcond,time,subj)
    end
end

%compute across subject correlations
clear cc
k=1;
for s1 = 1:nsubj
    for s2 = 1:s1-1
        CC(:,:,k) = corr(Msq(:,:,s1), Msq(:,:,s2), 'type','Pearson'); %Msq(:,:,s) should be condxtime
        CC(:,:,k+1) = CC(:,:,k)';
        k = k+2;
        %k=k+1;
    end
end
% 
% %perform ttest (vectorized for fast execution)
% m = mean(CC,3);
% df = size(CC,3)-1;
% ser = std(CC,[],3)/sqrt(size(CC,3));
% tval = m./ser;
% tail=0;
% if tail == 0 % two-tailed test
%     P = 2 * tcdf(-abs(tval), df);
% elseif tail == 1 % right one-tailed test
%     P = tcdf(-tval, df);
% elseif tail == -1 % left one-tailed test
%     P = tcdf(tval, df);
% end

% for t1 = 1:ntime
%     t1
%     for t2 = 1:ntime
%         [h,P(t1,t2)] = ttest(cc(t1,t2,:));
%     end
% end


% figure;imagesc(time,time,mean(CC,3))
% set(gca,'YDir','normal');
% set(gca,'fontsize',15);
% xlabel('time (sec)');
% ylabel('time (sec)');
% set(gcf,'Color','White');
% colormap('jet');
% colorbar
% 
% %apply FDR
% alpha = 0.05;
% pv = sort(P(:)); %sorted pvalues
% N = length(pv); %number of tests
% l = (1:N)'/N * alpha; %FDR line
% %plot(pv);hold on;plot(l);
% crossings = find( pv>l == 0); 
% if ~isempty(crossings) %if the two lines cross
%     fdr_th = l(max(find( pv>l == 0))); %highest crossing point
% else
%     fdr_th = 0;
% end
% Pth = P<fdr_th;
% figure;imagesc(time,time,Pth);
% set(gca,'YDir','normal');
% set(gca,'fontsize',15);
% xlabel('time (sec)');
% ylabel('time (sec)');
% colormap([1 1 1; 1 0 0])






