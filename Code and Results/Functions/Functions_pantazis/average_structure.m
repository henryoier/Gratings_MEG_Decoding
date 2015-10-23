function Ave = average_structure(Struct)
%function Ave = average_structure(Struct)
% Average structured vector array
%
% Author: Dimitrios Pantazis

Ave = zeros(size(Struct{1}));
for i = 1:length(Struct)
    Ave = Ave + Struct{i};
end
Ave = Ave/length(Struct);    
    






