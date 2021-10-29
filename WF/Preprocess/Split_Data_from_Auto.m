% split file
clear all
close all
path='D:\GoogleDrive\retina\Exps\2021\1028\';
load([path,'20211028_whole_filed'])
rate=20000;
i=1;
split_time=[];

for i=2:2:length(TimeStamps)-2
    if TimeStamps(i+2)-TimeStamps(i)>60
        split_point=TimeStamps(i)+60;
        split_time=[split_time split_point];
    end
    
end
plot(TimeStamps,zeros(1,length(TimeStamps)),'o');hold on;plot(split_time,zeros(1,length(split_time)),'+')

t_start=0;
t=1/rate:1/rate:size(a_data,2)/rate;
split_time=[split_time t(end)];
adata1=a_data(1,:);
adata2=a_data(2,:);
clearvars a_data
dataset=cell(1,length(split_time));
spikeset=cell(1,length(split_time));
TimeStampset=cell(1,length(split_time));
for j=1:length(split_time)
    t_end=split_time(j);
    TimeStampset{j}=TimeStamps(TimeStamps>t_start & TimeStamps<t_end);
    TimeStampset{j}=TimeStampset{j}-t_start;
    a1split=adata1(t>t_start & t<t_end);
    a2split=adata2(t>t_start & t<t_end);
    dataset{j}=[a1split;a2split];
    split_spikes=cell(1,60);
    for k=1:60
        split_spikes{k}=Spikes{k}(Spikes{k}>t_start & Spikes{k}<t_end);
        split_spikes{k}=split_spikes{k}-t_start;
    end
    spikeset{j}=split_spikes;
    t_start=t_end;
end
clearvars adata1 adata2

cd(path)
mkdir SplitData
cd([path,'\SplitData'])
for n=1:length(dataset)
    a_data=[];
    Spikes=[];
    TimeStamps=[];
    a_data=dataset{n};
    Spikes=spikeset{n};
    TimeStamps=TimeStampset{n};
    save([num2str(n),'.mat'],'a_data','Spikes','TimeStamps')
end



