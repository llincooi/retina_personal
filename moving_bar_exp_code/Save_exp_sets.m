close all;
clear all;
%code_folder = pwd;
exp_folder = 'D:\Leo\0409';
exp_folder = 'C:\Users\llinc\GitHub\retina_personal\0409';
cd(exp_folder)
mkdir Analyzed_data
cd Analyzed_data
%% 
set_number = 1;
name = '5G_BB_sOU'; %start with Independant variables and then the controlled ones
filename = '5G_BB_sOU_properties';
direction = 'RL';
HMM_former_name = ['0224_OUsmooth_',direction, '_G'];
HMM_post_name = '_5min_Q100_6.5mW_1Hz';
OU_former_name = ['0224_OU_', direction, '_G'];
OU_post_name = '_5min_Q100_6.5mW';
OU_different_G =  [2.5,4.5,9,12,20];
HMM_different_G =[2.5,4.5,9,12,20];
save([num2str(set_number), ';', name, '.mat']);

%%
set_number = 2;
name = '5G_BB_sOU_0.3covered'; %start with Independant variables and then the controlled ones
filename = '5G_BB_sOU__0.3covered_properties';
direction = 'RL';
HMM_former_name = ['0224_OUsmooth_',direction, '_G'];
HMM_post_name = '_5min_Q100_6.5mW_1Hz_0.3covered';
OU_former_name = ['0224_OU_', direction, '_G'];
OU_post_name = '_5min_Q100_6.5mW';
OU_different_G =  [2.5,4.5,9,12,20];
HMM_different_G = [2.5,4.5,9,12,20];
save([num2str(set_number), ';', name, '.mat']);
%%
set_number = 3;
name = '5G_BB_sOU_0.15covered'; %start with Independant variables and then the controlled ones
filename = '5G_BB_sOU__0.15covered_properties';
direction = 'RL';
HMM_former_name = ['0224_OUsmooth_',direction, '_G'];
HMM_post_name = '_5min_Q100_6.5mW_1Hz_0.15covered';
OU_former_name = ['0224_OU_', direction, '_G'];
OU_post_name = '_5min_Q100_6.5mW';
OU_different_G =  [2.5,4.5,9,12,20];
HMM_different_G = [2.5,4.5,9,12,20];
save([num2str(set_number), ';', name, '.mat']);

%%
set_number = 4;
name = '5G_BB_HMM'; %start with Independant variables and then the controlled ones
filename = '5G_BB_HMM_properties';
direction = 'RL';
HMM_former_name = ['0224_HMM_',direction, '_G'];
HMM_post_name = '_5min_Q100_6.5mW';
OU_former_name = ['0224_OU_', direction, '_G'];
OU_post_name = '_5min_Q100_6.5mW';
OU_different_G =  [2.5,4.5,9,12,20];
HMM_different_G = [2.5,4.5,9,12,20];
save([num2str(set_number), ';', name, '.mat']);
%%
set_number = 6;
name = '5G_BB_OU';%start with Independant variables and then the controlled ones
filename = '5G_BB_OU_properties'
direction = 'RL';
HMM_former_name = ['0224_OU_',direction, '_G'];
HMM_post_name = '_5min_Q100_6.5mW';
OU_former_name = ['0224_OU_', direction, '_G'];
OU_post_name = '_5min_Q100_6.5mW';
OU_different_G =  [2.5,4.5,9,12,20];
HMM_different_G = [2.5,4.5,9,12,20];
save([num2str(set_number), ';', name, '.mat']);

%%
% set_number = 6;
% name = '5G_BB_sOU_0.03interupted'; %start with Independant variables and then the controlled ones
% filename = '5G_BB_sOU__0.03interupted_properties';
% direction = 'RL';
% HMM_former_name = ['0224_OUsmooth_',direction, '_G'];
% HMM_post_name = '_5min_Q100_6.5mW_1Hz_0.03interrupt';
% OU_former_name = ['0224_OU_', direction, '_G'];
% OU_post_name = '_5min_Q100_6.5mW';
% OU_different_G =  [2.5,9];
% HMM_different_G = [2.5,4.5,9,12,20];
% save([num2str(set_number), ';', name, '.mat']);

 %%
% set_number = 7;
% name = '5G_BB_sOU_0.09interupted'; %start with Independant variables and then the controlled ones
% filename = '5G_BB_sOU__0.09interupted_properties';
% direction = 'RL';
% HMM_former_name = ['0224_OUsmooth_',direction, '_G'];
% HMM_post_name = '_5min_Q100_6.5mW_1Hz_0.09interrupt';
% OU_former_name = ['0224_OU_', direction, '_G'];
% OU_post_name = '_5min_Q100_6.5mW';
% OU_different_G =  [2.5,9];
% HMM_different_G = [2.5,4.5,9,12,20];
% save([num2str(set_number), ';', name, '.mat']);

%% 
