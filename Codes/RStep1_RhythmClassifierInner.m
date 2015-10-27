function [AccuracyMEG, Weight, paramout] = RStep1_RhythmClassifierInner(condA, condB, iitt, SubjectName, param)

disp(['Conditions = ' num2str(condA) ' & ' num2str(condB)]);
if(strcmp(iitt,'ii')) 
    [AccuracyMEG(condA,condB,:),Weight(condA,condB,:,:),paramout] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
end
if(strcmp(iitt,'iitt')) 
    [AccuracyIITT(condA,condB,:,:),Weight(condA,condB,:,:),paramout] = svm_contrast_conditions_perm(SubjectName,{num2str(condA)},{num2str(condB)},param); 
end


