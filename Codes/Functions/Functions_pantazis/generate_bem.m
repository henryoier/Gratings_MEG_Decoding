function sFiles = generate_bem(SubjectNames);

sFiles = bst_process(...
    'CallProcess', 'process_generate_bem', ...
    [], [], ...
    'subjectname', SubjectNames{1}, ...
    'nscalp', 1922, ...
    'nouter', 1922, ...
    'ninner', 1922, ...
    'thickness', 4);