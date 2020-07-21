function TheFileNames = ChooseWantedfile(folder, Requirement)
TheFileNames = [];
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
pass = true;
for i = 1:length(all_file)
    for requirement = Requirements
        if ~contains(all_file(i).name, requirement)
            pass = false;
            break
        end
    end
    if pass
        TheFileNames = [TheFileNames string(all_file(i).name)];
    end
end
end
