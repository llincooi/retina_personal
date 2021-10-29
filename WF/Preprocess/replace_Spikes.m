% replace Spikes by sorted data
clear 
cd('E:\Chou\20200707\SplitData\'); % open original data
path_sort=['E:\Chou\20200707\SplitData\sort\']; % sorted spikes data
savepath=['F:\§Úªº¶³ºÝµwºÐ\Retina exp\exp data\Sorted_final_data\20200707\']; % new data
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file); 
unit_number=3;  

for z = 1:n_file
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    load([filename]);
    name(name=='_')='-';
    
    for u=1:unit_number
        clearvars Spikes
        try
            load([path_sort,filename(1:end-4),'_unit',num2str(u),ext])
        catch
            continue
        end
        save([savepath,filename(1:end-4),'_sort_unit',num2str(u),'.mat'],'a_data','Spikes','TimeStamps')
    end
end
    
    