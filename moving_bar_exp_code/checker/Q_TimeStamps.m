%% 
clear all;
TimeStamps(2) = [];
%% 
TimeStamps = [TimeStamps 336]
TimeStamps(1) = TimeStamps(3);
TimeStamps(2) = TimeStamps(22);
TimeStamps(2:17) = [];
%% 

n = 'HMM_G4.5_lumin1.mat';
save(n,'Spikes','TimeStamps','a_data','Infos')