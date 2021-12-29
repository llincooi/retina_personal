%cd('0704');
clear all
code_folder = pwd;
exp_folder = 'D:\GoogleDrive\retina\Chou''s data\211217';
% exp_folder = 'D:\GoogleDrive\retina\Troy''s data\20211126';
cd(exp_folder)
all_file = dir('*.mcd') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ; 
for m = 1
    file = all_file(m).name ;
    [pathstr, name, ext] = fileparts(file);
    filename = [exp_folder,'\',name,ext];
    
    cd(code_folder)
    [Spikes,TimeStamps,a_data,Infos] = analyze_MEA_data_revised(filename,1,'','Leo','all',10^5);
    %save_data = 1 means save data
    %analog_type sets to 'all'
    %r_interval is the interval that calculates std,if none,it calculate total interval
end
% c = 0;
% for i = 1:60
%     c = c+ size(Spikes{i});
% end
% c