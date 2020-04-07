clear all;
close all;
code_folder = pwd;
exp_folder = 'D:\Leo\0119exp';
save_photo =0;%0 is no save on off photo and data, 1 is save
cd(exp_folder)
% p_channel = [25,33,34,45,46];%Green is predictive
% n_channel = [52,53,57,58,59,60];%Purple is non-predictive
p_channel = [];%Green is predictive
n_channel = [];%Purple is non-predictive

SamplingRate=20000; %fps of diode in A1
lumin = '';
sorted = 1;
%% For unsorted spikes
load([exp_folder, '\data\Gonoff',lumin,'.mat']);
analyze_spikes = Spikes;
%% For sorted spikes
if sorted
    load([exp_folder, '\sort\Gonoff',lumin,'.mat']);
    unit = [4 5];
    
    complex_channel = [];
    if unit == 0
        fileID = fopen([exp_folder, '\Analyzed_data\unit_a.txt'],'r');
        formatSpec = '%c';
        txt = textscan(fileID,'%s','delimiter','\n');
        for m = 1:size(txt{1}, 1)
            complex_channel = [complex_channel str2num(txt{1}{m}(1:2))];
        end
    end
    for i = 1:60  % i is the channel number
        analyze_spikes{i} =[];
        if unit == 0
            if any(complex_channel == i)
                unit_a = str2num(txt{1}{find(complex_channel==i)}(3:end));
                for u = unit_a
                    analyze_spikes{i} = [analyze_spikes{i} Spikes{u,i}'];
                end
            else
                analyze_spikes{i} = [analyze_spikes{i} Spikes{1,i}'];
            end
        else
            for u = unit
                analyze_spikes{i} = [analyze_spikes{i} Spikes{u,i}'];
            end
        end
        analyze_spikes{i} = sort(analyze_spikes{i});
    end
end
%%

name = ['LED_Gollish_OnOff', lumin];%Name that used to save photo and data
num_cycle =20;
lumin=a_data(3,:);   %Careful: cant subtract a value to the lumin series, or the correspondent  Spike time would be incorrect!
rr =[9,17,25,33,41,49,...
    2,10,18,26,34,42,50,58,...
    3,11,19,27,35,43,51,59,...
    4,12,20,28,36,44,52,60,...
    5,13,21,29,37,45,53,61,...
    6,14,22,30,38,46,54,62,...
    7,15,23,31,39,47,55,63,...
    16,24,32,40,48,56];

cc = hsv(3);
roi = [1:60];
p_channel = [];%Green is predictive
n_channel = [];%Purple is non-predictive
%% Create directory
if save_photo
    mkdir Analyzed_data
    mkdir Analyzed_data unsort
    mkdir Analyzed_data sort
    mkdir FIG
    cd FIG
    mkdir ONOFF
    cd ONOFF
    mkdir sort
    mkdir unsort
end

%%
bin = 10;  BinningInterval = bin*10^-3;  %ms
TriggerData = a_data(1,TimeStamps(1)*SamplingRate:TimeStamps(length(TimeStamps))*SamplingRate);% figure;plot(isi);
TriggerData2 = a_data(2,TimeStamps(1)*SamplingRate:TimeStamps(length(TimeStamps))*SamplingRate);% figure;plot(isi);
inten = downsample(TriggerData,SamplingRate*BinningInterval);
inten2 = downsample(TriggerData2,SamplingRate*BinningInterval);
plot((inten-mean(inten))*10);
hold on; plot(inten2- mean(inten2));
hold on; plot((TimeStamps-TimeStamps(1))/BinningInterval , 0,'g*');

diode_on_start = TimeStamps(2:2:end-1);
diode_off_start = TimeStamps(3:2:end-1);
diode_end = TimeStamps(end);
[cut_onspikes,cut_offspikes] = seperate_Gollishtrials(analyze_spikes,diode_on_start,diode_off_start,diode_end); % Cut spikes and merge each trial spikes in one trial

%On binning
onDataTime=mean(diff(diode_on_start))/2;%Average each stimulus length
onBinningTime = [ 0 : BinningInterval : onDataTime];
onBinningSpike = zeros(60,length(onBinningTime));
for i = 1:60  % i is the channel number
    [n,~] = hist(cut_onspikes{i},onBinningTime) ;
    onBinningSpike(i,:) = n ;
end

%Off binning
offBinningTime = [ 0 : BinningInterval : onDataTime];
offBinningSpike = zeros(60,length(offBinningTime));
for i = 1:60  % i is the channel number
    [n,~] = hist(cut_offspikes{i},offBinningTime) ;
    offBinningSpike(i,:) = n ;
end
figure(3)
on_off = zeros(1,length(onBinningTime));
on_off(1,1:50) = 1;
subplot(3,1,1),imagesc(onBinningTime,[1:60],onBinningSpike);
title(' OnOff / BinningInterval=10ms')
xlabel('On---time(s)');   ylabel('channel ID');
subplot(3,1,2),imagesc(offBinningTime,[1:60],offBinningSpike);
xlabel('Off---time(s)');   ylabel('channel ID');
subplot(3,1,3),plot(onBinningTime,on_off)
ylim([0 2])

%% Subplot sum of all channels  On and Off  PSTH
on_s=0;
off_s = 0;
for channelnumber=1:60
    on_s= on_s+ onBinningSpike(channelnumber,:);
    off_s= off_s+ offBinningSpike(channelnumber,:);
end
figure(4);
subplot(3,1,1),plot(onBinningTime,on_s);
xlabel('On---time(s)');
subplot(3,1,2),plot(offBinningTime,off_s);
xlabel('Off---time(s)');
subplot(3,1,3),plot(onBinningTime,on_off)
ylim([0 2])

%% Delete useless spikes (not in 50ms~550ms interval) and Calculate on-off index
on_spikes = zeros(1,60);%It stores sum of on response spike
off_spikes = zeros(1,60);%It stores sum of off response spike
on_off_index = ones(1,60)*-10000000;
useless_channel = [];
for channelnumber=1:60
    on_ss = cut_onspikes{channelnumber};
    off_ss = cut_offspikes{channelnumber};
    %Exclude channels that mean firing rate is lower than one
    if (length(on_ss)+length(off_ss))/(onDataTime*num_cycle*2) < 1
        useless_channel = [useless_channel channelnumber];
        %disp(['Channel ',int2str(channelnumber),'  mean firing rate is lower than one'])
        continue
    end
    %Remove useless spikes
    on_ss(on_ss<0.05) = [];
    on_ss(on_ss>0.55)=[];
    off_ss(off_ss<0.05) = [];
    off_ss(off_ss>0.55)=[];
    on_spikes(channelnumber) = length(on_ss);
    off_spikes(channelnumber) =  length(off_ss);
    on_off_index(channelnumber) = (on_spikes(channelnumber)-off_spikes(channelnumber))/(on_spikes(channelnumber)+off_spikes(channelnumber));
    if ~isnan(on_off_index(channelnumber))
        if on_off_index(channelnumber)>0.3%Criteria from 'Causal evidence for retina-dependent and -independent visual motion computations in mouse cortex'
            disp(['Channel ',int2str(channelnumber),' is on cell '])
            disp(['Channel ',int2str(channelnumber),' on_off index is ',num2str(on_off_index(channelnumber))])
        elseif on_off_index(channelnumber)<-0.3
            disp(['Channel ',int2str(channelnumber),' is off cell '])
            disp(['Channel ',int2str(channelnumber),' on_off index is ',num2str(on_off_index(channelnumber))])
        else
            disp(['Channel ',int2str(channelnumber),' is on-off cell '])
            disp(['Channel ',int2str(channelnumber),' on_off index is ',num2str(on_off_index(channelnumber))])
        end
    end
end
on_off_index (find(on_off_index == -10000000)) = NaN;
%% Plot all channels on off response
figure('units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);

for channelnumber=1:60
    axes(ha(rr(channelnumber)));
    if ~ismember(channelnumber,useless_channel)%If spikes are not enough
        plot(onBinningTime,onBinningSpike(channelnumber,:),'b');hold on;%Blue is on
        plot(offBinningTime,offBinningSpike(channelnumber,:),'r');%Red is off
        plot(onBinningTime,on_off*max([onBinningSpike(channelnumber,:),offBinningSpike(channelnumber,:)]),'k-')
        if ismember(channelnumber,p_channel)
            set(gca,'Color',[0.8 1 0.8])
        elseif ismember(channelnumber,n_channel)
            set(gca,'Color',[0.8 0.8 1])
        else
            
        end
    end
    xlim([0 2])
    
    if ~isnan(on_off_index(channelnumber))
        if on_off_index(channelnumber)>0.3%Criteria from 'Causal evidence for retina-dependent and -independent visual motion computations in mouse cortex'
            title([int2str(channelnumber),'ON'])
        elseif on_off_index(channelnumber)<-0.3
            title([int2str(channelnumber),'OFF'])
        else
            title([int2str(channelnumber),'ON-OFF'])
        end
    end
end
set(gcf,'units','normalized','outerposition',[0 0 1 1])
fig = gcf;
fig.PaperPositionMode = 'auto';
if save_photo
    if sorted
        saveas(fig,[exp_folder, '\FIG\ONOFF\','\sort\', name,'.tiff'])
        saveas(fig,[exp_folder, '\FIG\ONOFF\','\sort\', name,'.fig'])
        cd([exp_folder, '\FIG\ONOFF\','\sort'])
        save([exp_folder,'\Analyzed_data\sort\',name,'.mat'],'on_off_index','onBinningSpike','offBinningSpike','onBinningTime','offBinningTime')
    else
        saveas(fig,[exp_folder, '\FIG\ONOFF\','\unsort\', name,'.tiff'])
        saveas(fig,[exp_folder, '\FIG\ONOFF\','\unsort\', name,'.fig'])
        cd([exp_folder, '\FIG\ONOFF\','\unsort'])
        save([exp_folder,'\Analyzed_data\unsort\',name,'.mat'],'on_off_index','onBinningSpike','offBinningSpike','onBinningTime','offBinningTime')
    end
    %save([exp_folder,'\Analyzed_data\',name,'.mat'],'on_off_index','onBinningSpike','offBinningSpike','onBinningTime','offBinningTime')
end
figure('units','normalized','outerposition',[0 0 1 1])
hist(on_off_index);
xlim([-1 1])
set(gcf,'units','normalized','outerposition',[0 0 1 1])
fig = gcf;
fig.PaperPositionMode = 'auto';
if save_photo
    if sorted
        saveas(fig,[exp_folder, '\FIG\ONOFF\','\sort\', name,'on_off_index.tiff'])
        cd([exp_folder, '\FIG\ONOFF\','\sort'])
    else
        saveas(fig,[exp_folder, '\FIG\ONOFF\','\unsort\', name,'on_off_index.tiff'])
        cd([exp_folder, '\FIG\ONOFF\','\unsort'])
    end
    %save([exp_folder,'\Analyzed_data\',name,'.mat'],'on_off_index','onBinningSpike','offBinningSpike','onBinningTime','offBinningTime')
end
