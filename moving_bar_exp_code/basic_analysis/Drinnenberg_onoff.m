%% This code analyze on off response of retina(Gollish version)
%load on off data first
clear all;
close all;
load('rr.mat');
code_folder = pwd;
exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0729';
%exp_folder = 'C:\Users\llinc\OneDrive\Documents\GitHub\retina_personal\0503'
save_photo =0;%0 is no save on off photo and data, 1 is save
cd(exp_folder)
p_channel = [];%Green is predictive
np_channel = [];%Purple is non-predictive
%load('predictive_channel\0602_HMM_RL_5G_7min_Br50_Q100_1.mat')
name = '0609_Drinnenberg_OnOff_movie_5min_Br50_Q100_6.5mW';%Name that used to save photo and data
brightness_series = [0.65, 0.375, 0.75, 0.25, 0.875, 0.125, 1, 0, 0.5]; % rest_lumin included
Samplingrate=20000; %fps of diode in A3
sorted = 0;
%% load
if sorted
    load(['data\',name,'.mat'])
    load(['sort\',name,'.mat'])
    sort_directory = 'sort';
    Spikes = get_multi_unit(exp_folder,Spikes,0);
else
    load(['data\',name,'.mat'])
    sort_directory = 'unsort';
end
num_cycle = 90;
lumin=a_data(3,:);%Careful: cant subtract a value to the lumin series, or the correspondent  Spike time would be incorrect!

%% Create directory
if save_photo
    mkdir Analyzed_data
    mkdir Analyzed_data sort 
    mkdir Analyzed_data unsort
    mkdir FIG
    cd FIG
    mkdir ONOFF
    cd ONOFF
    mkdir sort
    mkdir unsort
end

%%  Find when is its final end
useful_lumin = lumin;
%% Calculate threhold
plateau_n=200;  %least number of point for plateau
last_gray = max(lumin)*0.25+min(lumin)*0.75;

thre_up = max(useful_lumin)*0.15+mode(useful_lumin)*0.85;%On threhold
thre_down = min(useful_lumin)*0.15+mode(useful_lumin)*0.85;%Off threhold

%% Find when on starts
diode_on_start =zeros(1,num_cycle);%It stores when on starts
num = 1;
pass = 0;
for i = 1:length(useful_lumin)-100
    if(useful_lumin(i+80)-useful_lumin(i))/80 > 0.3 && pass < 200 &&  useful_lumin(i)>thre_up
        diode_on_start(num) = i;
        num = num + 1;
        pass = 20000;
    end
    pass = pass - 1;
end
if length(diode_on_start) ~= num_cycle
    disp('There are some problems of finding diode start')
end

%% Plot when on off start
figure(101);plot(useful_lumin)
hold on; plot(diode_on_start(1:end),useful_lumin(diode_on_start(1:end)),'g*');
xlabel('time')
ylabel('lumin')
title('on start start')

%% Cut spikes and merge spikes, then binning spikes
diode_on_start = diode_on_start./Samplingrate;
SSpikes = seperate_DrinnenbergTrials(Spikes,diode_on_start,brightness_series);
BinningInterval = 0.01;
BinningTime = [ 0 : BinningInterval : 2]; %stimulation time for a lumin
sti = imresize(brightness_series(1:end-1), [1  (length(BinningTime)-1)*(length(brightness_series)-1)], 'nearest');
BinningSpike = [];
for i = 1:size(SSpikes,2)
    BS = [];
    for k = 1:size(SSpikes,1)
        [n,~] = histcounts(SSpikes{k,i},BinningTime);
        BS = [BS n];
    end
    BinningSpike = [BinningSpike ; BS];
end

%% Subplot sum of all channels  On and Off  PSTH
figure(100);
plot(sum(BinningSpike, 1)); hold on;
plot(sti*max(sum(BinningSpike, 1)));
%%  Heat Map / all channels
figure(103)
subplot(2,1,1),imagesc([BinningInterval : BinningInterval : 16],[1:60],BinningSpike);
subplot(2,1,2),plot(sti);

%%  each channels 
% close all
for i = 1:size(SSpikes,2)
    if sum(BinningSpike(i,:))/16 <= 7 || i == 4 %firing rate > 3Hz
        continue
    end
    figure(i)
    plot(BinningSpike(i,:)); hold on;
    plot(sti*max(sum(BinningSpike(i,:), 1)));
end

%%
sumSpike = sum(BinningSpike, 1);
sumsumSpike = zeros(1,length(brightness_series)-1);
maxsumSpike = zeros(1,length(brightness_series)-1);
for i = 1:length(brightness_series)-1
    sumsumSpike(i) = sum(sumSpike((length(BinningTime)-1)*(i-1)+1:(length(BinningTime)-1)*(i-1)+(length(BinningTime)-1)));
    maxsumSpike(i) = max(sumSpike((length(BinningTime)-1)*(i-1)+1:(length(BinningTime)-1)*(i-1)+(length(BinningTime)-1)));
end
lumdiff = diff([brightness_series(end), brightness_series(1:end-1)]);
%%
figure;
% plot(sumsumSpike(2:2:end)/sumsumSpike(2)); hold on;
% plot(sumsumSpike(1:2:end)/sumsumSpike(1)); hold on;
plot(maxsumSpike(2:2:end)/maxsumSpike(2) ); hold on;
plot(maxsumSpike(1:2:end)/maxsumSpike(1) );
% plot(lumdiff(2:2:end)/lumdiff(2));
% plot(brightness_series(2:2:end)/brightness_series(end));