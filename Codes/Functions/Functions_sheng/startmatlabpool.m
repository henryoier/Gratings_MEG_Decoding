function [] = startmatlabpool(size)
% Start matlab parallel computing pool with input size
% 
%==========================================================================
%   Input:
%       size    -   parallel cpu numbers requested
%--------------------------------------------------------------------------
%   Writtlen by Sheng Qin(shengqin [AT] mit (DOT) edu)
%   
%   Version 1.0 Oct. 2015
%

delete(gcp('nocreate'));    % Delete pool if existed
p = gcp('nocreate');        % Request pool

if isempty(p)             
    poolsize = 0;
else
    poolsize = p.NumWorker;
end

if poolsize == 0
    if nargin == 0
        parpool('local');
    else
        try
            parpool('local', size);
        catch ce
            parpool;
            fail_p = gcp('nocreate');
            fail_size = fail_p.NumWorkers;
            display(ce.message);
            display(strcat('Wrong input argument, adopt default size configuration size=', num2str(fail_size)));
        end
    end
else
    display('parpool start');
    if poolsize ~= size
        closematlabpool();
        startmatlabpool(size);
    end
end
