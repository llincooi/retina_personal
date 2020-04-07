close all
clear all
exp_folder = 'D:\Leo\0620exp';
load('D:\Leo\0620exp\merge\merge_0415_short_HMM_RL_G4.3_15min_Br50_Q100.mat')
type = 'RL';
load('boundary_set.mat')
load('channel_pos.mat')
stimulus_length = TimeStamps(2)-TimeStamps(1);
trial_num =30;
fps = 60;
display_trial = 1:30;
analyze_spikes = reconstruct_spikes;
%analyze_spikes = sorted_spikes;
%
% analyze_spikes = Spikes;
analyze_spikes{31}=[];
channel_number = 1:60;
BinningInterval = 1/60;


%% divide stimuli
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
for i = 1:length(bin_pos)
    if bin_pos(i) > 0
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
%% divide Spikes
trial_spikes = cell(trial_num,60);
for k = 1:60  % i is the channel number
    for j = 1:trial_num
        trial_spikes{j,k} = null(100,1);
    end
end
for k = channel_number  % i is the channel number
    for j = 1:trial_num
        for m = 1:length(analyze_spikes{k});
            if analyze_spikes{k}(m) < (start_frame(j)+trial_length(j))/fps && analyze_spikes{k}(m) > start_frame(j)/fps
                trial_spikes{j,k} = [trial_spikes{j,k}  analyze_spikes{k}(m)-start_frame(j)/fps];
            end
        end
        %trial_spikes{j,k} = trial_spikes{j,k} - 1/fps;
    end
end

display_trial = find(trial_length == mode(trial_length));
length(display_trial)

%% Calculate distance btw bar and electrode
PSTH =zeros(8, mode(trial_length)/fps/BinningInterval);
smooth_PSTH = null(1,1);
distance = [];
for j = 1:length(display_trial)
    BinningTime = [BinningInterval/2 : BinningInterval : trial_length(display_trial(j))/fps-BinningInterval/2];
    BinningSpike = zeros(60,length(BinningTime));
    dis = zeros(8,length(BinningTime));
    spike_dis = zeros(2,length(BinningTime),60);
    for k = channel_number % i is the channel number
        num_spike =  length(analyze_spikes{k});
        if num_spike /stimulus_length > 0.3 %Cells with a low firing rate for checkerbox(<0.3HZ) were not considered
            isi = diff(trial_spikes{display_trial(j),k});
            ave_isi = (isi(1:end-1)+isi(2:end))/2;
            [n,~] = hist(trial_spikes{display_trial(j),k},BinningTime);
            BinningSpike(k,:) = n;
        end
    end
    
    %for UD
    if strcmp(type,'UD')
        UD_spikes = get_UD(BinningSpike);
        for m = 1:length(BinningTime)
            kk = 0;
            for k = [55 47 39 31 23 15 7 1];
                framestep = floor(m*BinningInterval*fps);
                kk = kk+1;
                dis(kk, m) = (channel_pos(k,1)-meaCenter_x) - (trial_pos(display_trial(j), framestep)-meaCenter_x);  
            end
        end
        PSTH = PSTH + UD_spikes;
    elseif  strcmp(type,'RL')
        RL_spikes = get_RL(BinningSpike);
        for m = 1:length(BinningTime)
            kk = 0;
            for k = [14 6 5 4 3 2 1 7];
                framestep = floor(m*BinningInterval*fps);
                kk = kk+1;
                dis(kk, m) = (channel_pos(k,1)-meaCenter_x) - (trial_pos(display_trial(j), framestep)-meaCenter_x);
            end
        end
        PSTH = PSTH + RL_spikes;
    elseif  strcmp(type,'UR_DL')
        for m = 1:length(BinningTime)
            framestep = floor(m*BinningInterval*fps)+1;
            dis(k, m) = (-channel_pos(k,1)+ channel_pos(k,2)+meaCenter_x-meaCenter_y)/sqrt(2) - (trial_pos(display_trial(j), framestep)- meaCenter_x);
        end
    elseif  strcmp(type,'UL_DR')
        for m = 1:length(BinningTime)
            framestep = floor(m*BinningInterval*fps)+1;
            dis(k, m) = (channel_pos(k,1)+channel_pos(k,2)-meaCenter_y-meaCenter_x)/sqrt(2) - (trial_pos(display_trial(j), framestep)- meaCenter_x);
        end
    end
end
%% ploting
for kk =1:8
    figure(kk);
    plot(dis(kk,:)/max(abs(dis(kk,:)))*max(PSTH(kk,:)));hold on
    plot(PSTH(kk,:));hold on
end

norPSTH = zeros(8, mode(trial_length)/fps/BinningInterval);
for kk = 1:8
    if mean(PSTH(kk,:)) == 0
        norPSTH(kk,:) = 0;
    else
        norPSTH(kk,:) = PSTH(kk,:)/ max(PSTH(kk,:));
    end
end
peak_pos = [];
peak_pos_heat_map = zeros(8, length(peak_pos));
for i = 1:length(PSTH)
    if sum( PSTH(:,i)) == 0
        peak_pos = [peak_pos NaN];
    else
        index = find(norPSTH(:,i)' == max( norPSTH(:,i))); 
        peak_pos = [peak_pos mean(index)];
        peak_pos_heat_map(index, i) = max( norPSTH(:,i))/ sum( norPSTH(:,i));
    end
end

figure(100);
stairs (peak_pos);hold on
ylim([0 9]);
%%imagesc(peak_pos_heat_map);hold on
plot (-dis(1,:)*micro_per_pixel/200+1, 'LineWidth',1.5,'LineStyle','-', 'Color', 'r');hold on
% figure(99);
% x = xcorr (-dis(1,:)*micro_per_pixel/200+1, peak_pos);
% plot (x);
% figure;
% hist(norPSTH)
% mode(norPSTH, 'all')
%% 
% 
cd(exp_folder)
mkdir FIG
cd FIG
mkdir short_8
cd short_8
tau_max = [];
smooth_pos = smooth(-dis(1,:)*micro_per_pixel/200+1, 10);
for i = 1:length(PSTH)
    bar_state = zeros(1,8);
    bar_state(round(-dis(1,i)*micro_per_pixel/200+1)) = 1;
    i
%     f = figure('visible','off');
%     ax2 = subplot(2,1,1);
%     bar(norPSTH(:,i),1);
%     ylim(ax2,[0 0.12])
%     x2 = xlim(ax2);
%     ax1 = subplot(2,1,2);bar(smooth_pos(i), 1 , (2*bar_wid+1)*micro_per_pixel/200 );
%     xlim(ax1, x2)
%     saveas(f,[num2str(i) , '.tiff']);
    %tau = xcorr (norPSTH(:,i)', bar_state');
    tau = xcorr (bar_state', norPSTH(:,i)');
    [trash index] = max(tau);
    tau_max = [tau_max mean(index)-8];
end

    figure;
    plot(tau_max);hold on
    plot (smooth_pos-4.5, 'LineWidth',1.5,'LineStyle','-', 'Color', 'r');
% 

% 



