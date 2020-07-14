%% Code for analyzing 0718 grating
close all;
clear all;
code_folder = pwd;
sorted = 0;
unit = 0;
videoworkspace = '\\192.168.0.100\Experiment\Retina\2020Videos\0219v\videoworkspace\';
exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0708';
file_name = '0617_Grating_0-6.5mW';
Vedio = load([videoworkspace, file_name, '.mat'])
save_photo = 0;%0 is no save grating photo, 1 is save
%trial = (find(bar_real_width==width)-1)*3+find(temporal_frequency==frequency);
displaychannel = [1:60];%Choose which channel to display
cd(exp_folder)
direction_order = [0,7,6,5,4,3,2,1];%It will be multiplied by pi/4
theta = [0,7:-1:0]*0.25*pi;
%0 is right 4 is left 2 is up 6 is down 
%7 is right down 3 is left up
% 1 is rigtht up 5 is left down
%Notice it is direction on monitor

if sorted
    load(['data\', file_name, '.mat'])
    load(['sort\', file_name, '.mat'])
    analyze_spikes = get_multi_unit(exp_folder,Spikes,unit);
else
    load(['data\', file_name, '.mat'])
    analyze_spikes = Spikes;
end

[i j k] = ind2sub([length(Vedio.bar_real_width_set) length(Vedio.temporal_frequency_set) length(Vedio.theta_set)], Vedio.Order);

trial_num = length(Vedio.Order) ;%0820 is 96, 0718 is 40, 0827 is 64
analyze_spikes{31} = [0];
num_direction = 8;
display_trial = 1:trial_num;
fps = 60;
channel_number = 1:60;
diode_start = zeros(1,trial_num);
num = 1;
pass = 0;
Samplingrate=20000; %fps of diode in A3

%% Create directory
mkdir FIG
cd FIG
mkdir grating
cd grating
if save_photo
    if strcmp(file_name(end),'1')
        order = 'first_';
    elseif strcmp(file_name(end),'2')
        order = 'second_';
    elseif strcmp(file_name(end),'3')
        order = 'third_';
    else
        order = '';
    end
end
mkdir sort
mkdir unsort
%% Determine time of start and end
lumin=a_data(3,:);   %Careful: cant subtract a value to the lumin series, or the correspondent  Spike time would be incorrect!
plateau_n=200;  %least number of point for plateau
last_gray = max(lumin)*0.25+min(lumin)*0.75;
thre_up = max(lumin)*0.7+min(lumin)*0.3;
thre_down = max(lumin)*0.2+min(lumin)*0.8;
%Find when it starts
for i = 1:length(lumin)-100
    if (lumin(i+50)-lumin(i))/50 > 10*5/16 && (lumin(i+100)-lumin(i))/100 > 6*5/16 && (lumin(i+10)-lumin(i))/10 > 7*5/16 && pass < 200
        diode_start(num) = i;
        num = num + 1;
        pass = 3500;
    end
    pass = pass - 1;
end

if is_complete == 0
    disp('There are no normal signal')
    pass = 0;
    return
end
%% Plot when each grating start
figure(1);plot(lumin)
hold on; plot(diode_start,lumin(diode_start),'r*');
xlabel('time')
ylabel('lumin')
title('start and end')


%% Seperate orientation 
diode_start = [diode_start./20000. ]+4/3;
trial_length = diff(diode_start)-3;%Minus 1.33 sec for adaptation and minus 1.67 sec for mean luminance interval
trial_spikes = cell(trial_num,60);

for k = channel_number% k is the channel number
    for j = 1:trial_num
        trial_spikes{j,k} = [];
        for m = 1:length(analyze_spikes{k})
            if analyze_spikes{k}(m) < diode_start(j)+trial_length(j) && analyze_spikes{k}(m) > diode_start(j) %Minus first 1.33 sec for adaptation
                trial_spikes{j,k} = [trial_spikes{j,k}  analyze_spikes{k}(m)-diode_start(j)];
            end
        end
    end
end


%% Plot PSTH for each directions
BinningInterval = 1/fps;  %s
conter2D= zeros(trial_num/num_direction,num_direction, 60);%It stores sum of total spikes from eight directions
All_BinningSpike2D = cell(1,trial_num/num_direction);%It stores 8 directions of all trial spikes of varity of width and temporal freguency
for j = 1:length(display_trial)
    BinningTime = [0 : BinningInterval : round(trial_length(j)*6)/6];%~binning 'trial_length'
    %All_BinningSpike2D{ceil(display_trial(j)/num_direction)} = zeros(num_direction,60,length(BinningTime)-1);%It stores 8 directions of all trial spikes
    for k = channel_number % i is the channel number
        [n, ~] = histcounts(trial_spikes{display_trial(j),k},BinningTime) ;
        All_BinningSpike2D{ceil(display_trial(j)/num_direction)}(mod(display_trial(j)-1,8)+1,k,:) = reshape(n,1,1,[]);
        conter2D(ceil(display_trial(j)/num_direction), mod(display_trial(j)-1,8)+1, k) = sum(n);
    end
end
% disp(['Temporal frequency is ',num2str(frequency),' Hz'])
% disp(['Bar real width is ',num2str(width),' um'])

%% Calculate DSI
DSI =zeros(trial_num/num_direction,60,2);
direction_vector = exp((direction_order)*pi/4*1j);
for i = trial%:trial_num/num_direction
for k = channel_number % k is the channel number
    if sum(conter2D(i,:,k))/sum(trial_length) >= 0.1%Only mean firing rate greater than 0.1 HZ is considered
        DSI(i,k,1) = abs(dot(direction_vector, conter2D(i,:,k)))/sum(conter2D(i,:,k)); %DSI in number of spikes
        DSI(i,k,2) = sum(conter2D(i,:,k)); %total firing spikes
%         disp(['Channel ',int2str(k),' has mean firing rate of ',num2str(sum(conter2D(i,:,k))/sum(trial_length)),' HZ'])
%         disp(['DSI of Channel ',int2str(k),' is ',num2str(DSI(i,k,1))])
        if DSI(i,k,1) > 0.3%Check whether it is DS cell
%             disp(['Channel ',int2str(k),' is directional selective cell'])
%             disp(' ')
            %Polar plot of DS cell
            if ismember(k,displaychannel)
                figure(k+i*100);
                polar(theta',[conter2D(i,:,k)';conter2D(i,1,k)]/max(conter2D(i,:,k)))%normalization by division by most spikes
                hold on;
                %For fixed radius of 1
                max_lim = 1;
                x_fake=[0 max_lim 0 -max_lim];
                y_fake=[max_lim 0 -max_lim 0];
                h_fake=compass(x_fake,y_fake);
                
                h = compass(direction_vector*conter2D(i,:,k)'/sum(conter2D(i,:,k)));
                title(['Polar plot of channel ',int2str(k)])
                set(h_fake,'Visible','off');
                hold off;
                if save_photo
                     if sorted
                         saveas(gcf,[exp_folder, '\FIG\grating\sort\',order,'polarplot_channel', num2str(k)  '.tiff'])
                     else
                         saveas(gcf,[exp_folder, '\FIG\grating\unsort\',order,'polarplot_channel', num2str(k)  '.tiff'])
                     end
                end
            end
        end
    end
end
end
DScell = DSI(:,:,1)>=0.3;
sum(DScell, 2)

%% rastplot
% displaychannel = [2 12 21];
% for i = trial%1:trial_num/num_direction
%     figure(900+i);
%     ha = tight_subplot(num_direction,1,[0 0],[0.05 0.05],[.02 .01]);
%     for j = 1:num_direction
%         BinningTime = [BinningInterval/2 : BinningInterval : round(trial_length((i-1)*8+j)*6)/6-BinningInterval/2];
%         axes(ha(j)); 
%         imagesc(BinningTime,displaychannel,reshape(All_BinningSpike2D{i}(j,displaychannel,:),[length(displaychannel),length(BinningTime)]));
%     end
% end
% cd(code_folder)
