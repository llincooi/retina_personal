%variables that you can and should tune
close all
clear all;

%load('D:\Leo\0712exp\sort_merge_spike\sort_merge_0502Dark_Reversal_moving_UR_DL_201.6s_Br50_Q100.mat')
%load('D:\Leo\0712exp\sort_merge_spike\sort_merge_0415_Reversal_moving_UR_DL_201.6s_Br50_Q100.mat')
%load('D:\Leo\0712exp\sort_merge_spike\sort_merge_0711_Reversal_moving_UR_DL_252s_Br50_Q100.mat')
load('D:\Leo\0620exp\sort_merge_spike\sort_merge_0415_Reversal_moving_RL_201.6s_Br50_Q100_re.mat')

load('D:\Leo\0620exp\data\RFcenter.mat')
load('boundary_set.mat')
load('channel_pos.mat')
trial_num = 12;
fps = 60;
display_trial = [1 2 3 4 5 6 7 8 9 10 11 12];
analyze_spikes = sorted_spikes;
%analyze_spikes = reconstruct_spikes;
channel_number = 1:60;
type = 'UD';
BinningInterval = 0.005;  %s

stimulus_length = TimeStamps(2)-TimeStamps(1);


%%for stimuli
start_frame = zeros(trial_num+1,1);
trial_length = zeros(trial_num,1);
trial_num_counter = 1;
start_frame(trial_num+1,1) = length(bin_pos);
on_ornot = 0;
start_frame = zeros(trial_num+1,1);
trial_length = zeros(trial_num,1);
trial_num_counter = 1;
start_frame(trial_num+1,1) = length(bin_pos);
trial_pos = zeros(trial_num,ceil(length(bin_pos)/trial_num));
for i = 2:length(bin_pos)-1
    if bin_pos(i) > leftx_bar + re_bar_wid && bin_pos(i) < rightx_bar - re_bar_wid && bin_pos(i+1) >= bin_pos(i) && bin_pos(i) >= bin_pos(i-1)
        if on_ornot ~= 1
            start_frame(trial_num_counter) = i;
        end
        on_ornot = 1;
        trial_pos(trial_num_counter, i+1-start_frame(trial_num_counter)) = bin_pos(i);
    else
        if on_ornot
            trial_length(trial_num_counter) = i - start_frame(trial_num_counter);
            trial_num_counter =trial_num_counter+1;
        end
        on_ornot = 0;
    end
end

%%for spikes
trial_spikes = cell(trial_num,60);
for k = 1:60  % i is the channel number
    for j = 1:trial_num
        trial_spikes{j,k} = null(100,1);
    end
end
for k = channel_number  % i is the channel number
    for j = 1:trial_num
        for m = 1:length(analyze_spikes{k})
            if analyze_spikes{k}(m) < (start_frame(j)+trial_length(j))/fps && analyze_spikes{k}(m) > start_frame(j)/fps
                trial_spikes{j,k} = [trial_spikes{j,k}  analyze_spikes{k}(m)-start_frame(j)/fps];
            end
        end
    end
end

%for ploting
%ha = tight_subplot(length(display_trial),1,[.1 .01],[0.05 0.05],[.02 .01]);
PSTH = null(1,1);
smooth_PSTH = null(1,1);
distance = null(1,1);
dis_STA = zeros(60,181);
sum_n = zeros(60,1);
figure;
for j = 1:length(display_trial)
    BinningTime = [BinningInterval/2 : BinningInterval : trial_length(display_trial(j))/fps-BinningInterval/2];
    BinningSpike = zeros(60,length(BinningTime));
    dis = zeros(60,length(BinningTime));
    spike_dis = zeros(2,length(BinningTime),60);
    for k = channel_number % i is the channel number
        num_spike =  length(analyze_spikes{k});
        if num_spike /stimulus_length > 0.3 && RFcenter(k,1) ~= 0 %Cells with a low firing rate for checkerbox(<0.3HZ) were not considered
            isi = diff(trial_spikes{display_trial(j),k});
            ave_isi = (isi(1:end-1)+isi(2:end))/2;
            
            [n,~] = hist(trial_spikes{display_trial(j),k},BinningTime);
            BinningSpike(k,:) = n;
            %for UD
            %spike_dis(1,:,k)  = n;
            channel_pos(k,:) = RFcenter(k,:);
            if strcmp(type,'UD')
                for m = 1:length(BinningTime)
                    framestep = floor(m*BinningInterval*fps)+1;
                    dis(k, m) = (channel_pos(k,2)-meaCenter_y) - (trial_pos(display_trial(j), framestep)-meaCenter_x - re_bar_wid);
                    %spike_dis(2,m,k)= (channel_pos(k,2)-meaCenter_y) - (trial_pos(display_trial(j), m)-meaCenter_x + re_bar_wid);
                end
            elseif  strcmp(type,'RL')
                for m = 1:length(BinningTime)
                    framestep = floor(m*BinningInterval*fps)+1;
                    dis(k, m) = (channel_pos(k,1)-meaCenter_x) - (trial_pos(display_trial(j), framestep)-meaCenter_x + re_bar_wid);
                    %spike_dis(2,m,k)= (channel_pos(k,1)-meaCenter_x) - (trial_pos(display_trial(j), m)-meaCenter_x + re_bar_wid);
                end
            elseif  strcmp(type,'UR_DL')
                for m = 1:length(BinningTime)
                    framestep = floor(m*BinningInterval*fps)+1;
                    dis(k, m) = (-channel_pos(k,1)+ channel_pos(k,2)+meaCenter_x-meaCenter_y)/sqrt(2) - (trial_pos(display_trial(j), framestep)- meaCenter_x + re_bar_wid);
                    %spike_dis(2,m,k)= (channel_pos(k,1)-meaCenter_x) - (trial_pos(display_trial(j), m)-meaCenter_x + re_bar_wid);
                end
            elseif  strcmp(type,'UL_DR')
                for m = 1:length(BinningTime)
                    framestep = floor(m*BinningInterval*fps)+1;
                    dis(k, m) = (channel_pos(k,1)+channel_pos(k,2)-meaCenter_y-meaCenter_x)/sqrt(2) - (trial_pos(display_trial(j), framestep)- meaCenter_x + re_bar_wid);
                    %spike_dis(2,m,k)= (channel_pos(k,1)-meaCenter_x) - (trial_pos(display_trial(j), m)-meaCenter_x + re_bar_wid);
                end
            end
            %         plot(dis(k,1:length(BinningTime)),BinningSpike(k,1:length(BinningTime))/BinningInterval,'k');
            %         hold on;
            PSTH = [PSTH BinningSpike(k,1:length(BinningTime))];
            %smooth_PSTH =  [smooth_PSTH smooth(BinningSpike(k,1:length(BinningTime)),10)'];
            distance = [distance dis(k,1:length(BinningTime))];
            sum_n(k) = sum_n(k)+ sum(BinningSpike(k,91:length(BinningTime)-90));
            for i = 91:length(BinningTime)-90
                dis_STA(k,:) = dis_STA(k,:) + BinningSpike(k,i)*dis(k, i-90:i+90);
            end
        end
        
    end
end
for k = channel_number % i is the channel number
    dis_STA(k,:) = dis_STA(k,:)/sum_n(k);
end



%
%scatter(distance, smooth_PSTH, 10,'filled');
% distance(find(PSTH == 0)) = [];
% PSTH(find(PSTH == 0)) = [];
% figure;
% distance(PSTH == 0) = [];
% PSTH(PSTH == 0 ) = [];
% [sort_dis index] = sort(distance);
% plot(sort_dis , PSTH(index));

figure;
stem(distance, PSTH, '.');%, 10,'filled');

[sort_dist index]= sort(distance);
sort_PSTH = PSTH(index);
%sort_smooth_PSTH = smooth_PSTH(index);

figure;
plot(sort_dist,sort_PSTH);hold on
plot(-round(re_bar_wid*micro_per_pixel)-1:0, [0 ones(1,round(re_bar_wid*micro_per_pixel)) 0], 'r');
xlabel('Distance from leading edge (\mum)');ylabel('PSTH (Hz)');
set(gca,'fontsize',12 ); hold on

% 
% rr =[9,17,25,33,41,49,...
%     2,10,18,26,34,42,50,58,...
%     3,11,19,27,35,43,51,59,...
%     4,12,20,28,36,44,52,60,...
%     5,13,21,29,37,45,53,61,...
%     6,14,22,30,38,46,54,62,...
%     7,15,23,31,39,47,55,63,...
%     16,24,32,40,48,56];
%     figure('units','normalized','outerposition',[0 0 1 1])
%     ha = tight_subplot(8,8,[.03 .01],[0.02 0.02],[.01 .01]);
% for k=1:60
%     axes(ha(rr(k)));
%     plot(-90:90,dis_STA(k,:),'LineWidth',1.5,'LineStyle','-');hold on;
%     xlim([ -100 100])
%     %ylim([0 inf+0.1])
%         grid on
%     title(k)
% 
% end
