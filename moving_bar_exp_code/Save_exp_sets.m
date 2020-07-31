close all;
clear all;
%code_folder = pwd;
exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0729';
cd(exp_folder)
mkdir Analyzed_data
cd Analyzed_data
Gs_Sets = cell(1,4);
%% 
Gs_Sets{1} = CompareSet;
Gs_Sets{1}.Including = [ "OUsmooth" "UL_DR" "0727" "Bright"];
Gs_Sets{1}.Excluding = ["re"];
Gs_Sets{1}.fig_name = 'Gs_DB_6.5';
Gs_Sets{1}.file_name = 'Gs_DB_6.5';

%%
Gs_Sets{2} = CompareSet;
Gs_Sets{2}.Including = ["OUsmooth" "UL_DR" "re" "0727" "Bright"];
Gs_Sets{2}.Excluding = [];
Gs_Sets{2}.fig_name = 'Gs_BB_6.5_re';
Gs_Sets{2}.file_name = 'Gs_BB_6.5_re';
% %%
% Gs_Sets{3} = CompareSet;
% Gs_Sets{3}.Including = ["OUsmooth" "UR_DL" "Bright" "right" "0609"];
% Gs_Sets{3}.Excluding = ["left"];
% Gs_Sets{3}.fig_name = 'Gs_BB_6.5_right';
% Gs_Sets{3}.file_name = 'Gs_BB_6.5_right';
% 
% %%
% Gs_Sets{4} = CompareSet;
% Gs_Sets{4}.Including = ["OUsmooth" "UR_DL" "Bright" "left" "0609"];
% Gs_Sets{4}.Excluding = [];
% Gs_Sets{4}.fig_name = 'Gs_BB_6.5_left';
% Gs_Sets{4}.file_name = 'Gs_BB_6.5_left';
% 
% %%
% Gs_Sets{5} = CompareSet;
% Gs_Sets{5}.Including = ["OUsmooth" "UR_DL" "0224"];
% Gs_Sets{5}.Excluding = ["Dark"];
% Gs_Sets{5}.fig_name = 'Gs_BB_6.5';
% Gs_Sets{5}.file_name = 'Gs_BB_6.5';

%%
save('Gs_Sets.mat', 'Gs_Sets')

