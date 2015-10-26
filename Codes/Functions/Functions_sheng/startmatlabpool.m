function [] = startmatlabpool(size)

delete(gcp('nocreate'));
p = gcp('nocreate');

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
