close all;
clear all;
code_folder = pwd;
load('channel_pos.mat')
load('boundary_set.mat')

displaychannel = 1:60;%Choose which channel to display
save_photo =1;%0 is no save RF photo, 1 is save
save_svd =1;%0 is no save svd photo, 1 is save

time_shift = 1:9;%for -50ms:-300ms
num_shift = 1/30;%50ms
exp_folder = 'D:\Leo\0409';
cd(exp_folder)
% rr =[ 9 ,17,25,33,41,49,...
%     2,10,18,26,34,42,50,58,...
%     3,11,19,27,35,43,51,59,...
%     4,12,20,28,36,44,52,60,...
%     5,13,21,29,37,45,53,61,...
%     6,14,22,30,38,46,54,62,...
%     7,15,23,31,39,47,55,63,...
%       16,24,32,40,48,56];
for j =1:8
    for i =1:8
        rr(8*(j-1)+i) =8*i-j+1;
    end
end
%  rr =1:64;
rr([1, 8, 57, 64]) = [];
  rr = flip(rr);

load('Analyzed_data\unsort\0224_cSTA_wf_3min_Q100.mat')


name = '30Hz_27_RF_15min';%Directory name

%% For unsorted spikes
load('merge\merge_0224_Checkerboard_30Hz_27_15min_Br50_Q100.mat')
analyze_spikes = reconstruct_spikes;
sorted = 0;
%% For sorted spikes
% load('sort_merge_spike\sort_merge_0421_Checkerboard_20Hz_13_5min_Br50_Q100.mat')
% unit = 1;
% complex_channel = [];
% analyze_spikes = get_multi_unit(exp_folder,sorted_spikes,unit);
% sorted = 1;

%% Create directory
mkdir FIG
cd FIG
mkdir RF
cd RF
mkdir(name)
cd (name)
mkdir sort
mkdir unsort

%% Delete useless channel
checkerboard = bin_pos;%Stimulus we use
null_channel = [];
stimulus_length = TimeStamps(2)-TimeStamps(1);

for j = 1:length(displaychannel)
    num_spike =  length(analyze_spikes{displaychannel (j)});
    if num_spike /stimulus_length < 0.3 || isnan(cSTA(j,1)) %Cells with a low firing rate for checkerbox(<0.3HZ) were not considered
        null_channel = [null_channel j];
    end
end
disp(['useless channels are ',num2str(null_channel)])

displaychannel (null_channel) = [];


%% calculate RF
RF = cell(length(time_shift), 60);
gauss_RF = cell(length(time_shift), 60);
for k =displaychannel
    analyze_spikes{k}(analyze_spikes{k}<1) = []; %remove all feild on effect
    for i =  time_shift  %for -50ms:-300ms
        sum_checkerboard = zeros(length(bin_pos{1}));
        for j = 1:length(analyze_spikes{k})
            spike_time = analyze_spikes{k}(j); %s
            RF_frame = floor((spike_time - i*num_shift)*60);
            if RF_frame > 0
                sum_checkerboard = sum_checkerboard + checkerboard{RF_frame};
            end
        end
        RF{i,k} = sum_checkerboard/length(analyze_spikes{k});
        gauss_RF{i,k} = imgaussfilt(RF{i,k},1.5);
    end
end
side_length = length(sum_checkerboard);%length of checkerboard

%% calculate SVD and plot SVD
electrode_x = zeros(1,60);%x positions of electrode
electrode_y = zeros(1,60);%y positions of electrode
closest_extrema = zeros(2,60);%closest positions of RF center to position of electrode
    figure('units','normalized','outerposition',[0 0 1 1])
    ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
for k =displaychannel
    %calculate SVD
    reshape_RF = zeros(side_length^2,length(time_shift));
    for i =  time_shift %for -50ms:-300ms
        reshape_RF(:,i) = reshape(gauss_RF{i,k},[side_length^2,1]);
    end
    [U,S,V] = svd(reshape_RF');%U is temporal filter, V is one dimensional spatial filter, S are singular values
    if (U(1,2)*sum(cSTA(k,end-round(0.066/BinningInterval):end)) < 0) % asume that all channel are fast-OFF-slow-ON if there is no csta file.
        U(:,2) = -U(:,2);
        V(:,2) = -V(:,2);
    end
    space = reshape(V(:,2),[side_length,side_length]);%Reshape one dimensional spatial filter to two dimensional spatial filter

    axes(ha(rr(k)));        
    imagesc(space);hold on;
    
    %Plot spatial SVD    
    title(k)
    pbaspect([1 1 1])
    colormap(gray);
    colorbar;
end
