clear all
close all
exp_folder = 'D:\GoogleDrive\retina\Troy''s data\20211029\';

%% Load Sorted Spike
load([exp_folder, '20211029_whole_filed_sorted.mat'])
channel = [12,13,14,15,16,17,21,22,23,24,25,26,27,28,31,32,33,34,35,36,37,38,41,42,43,44,45,46,47,48,51,52,53,54,55,56,57,58,61,62,63,64,65,66,67,68,71,72,73,74,75,76,77,78,82,83,84,85,86,87];
unit_number=2;
merge_Spikes = cell(unit_number,60);
for h=1:60
    adch_channel = eval(['adch_',int2str(channel(h))]);
    %unit_number = length(unique(adch_channel(:,2)'));
    for u = 1:unit_number
        merge_Spikes{u,h} = adch_channel(find(adch_channel(:,2)==u),3); %
    end
end
clearvars -except merge_Spikes unit_number exp_folder
%% Split Data
load([exp_folder,'20211029_whole_filed.mat'])
rate=20000;
split_time=[];

for i=2:2:length(TimeStamps)-2
    if TimeStamps(i+2)-TimeStamps(i)>60
        split_point=TimeStamps(i)+60;
        split_time=[split_time split_point];
    end
end
plot(TimeStamps,zeros(1,length(TimeStamps)),'o');hold on;
plot(split_time,zeros(1,length(split_time)),'+')

t_start = 0;
t = 1/rate:1/rate:size(a_data,2)/rate;
split_time = [split_time t(end)];
input = a_data(1,:);
clearvars a_data
inputset = cell(1,length(split_time));
spikeset = cell(1,length(split_time));
TimeStampset = cell(1,length(split_time));
for j=1:length(split_time)
    t_end = split_time(j);
    
    TimeStampset{j} = TimeStamps(TimeStamps>t_start & TimeStamps<t_end);
    TimeStampset{j} = TimeStampset{j}-t_start;
    inputset{j} = input(t>t_start & t<t_end);
    split_spikes = cell(unit_number,60);
    for k=1:60
        for u = 1:unit_number
            split_spikes{u,k} = merge_Spikes{u,k}(merge_Spikes{u,k}>t_start & merge_Spikes{u,k}<t_end) -t_start;
        end
    end
    spikeset{j} = split_spikes;
    
    t_start = t_end;
end
clearvars input
%%
cd(exp_folder)
mkdir Sorted
cd 'SplitData'
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file);
if n_file==length(spikeset)
    for i =1:n_file;   date{i,1}=all_file(i).date;    end
    [datesort ind] = sort(date);

    for i=1:1:n_file
        stimulus=inputset{i};
        SortedSpikes=spikeset{i};
        TimeStamps=TimeStampset{i};
        save([exp_folder,'\Sorted\',all_file(ind(i)).name],'stimulus','SortedSpikes','TimeStamps')
    end
else
    print('error of the number of files.')
end