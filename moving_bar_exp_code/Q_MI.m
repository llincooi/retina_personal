
close all;
code_folder = pwd;
%exp_folder = 'D:\Leo\1012exp';
display_channel = 30;
type_folder_cell = {'pos', 'v', 'pos&v'};%'abs', 'pos', 'v', 'pos&v'.
for ttt = 1



type = type_folder_cell{ttt}; 
sorted = 1;
unit = 0; %unit = 0 means using 'unit_a' which is writen down while picking waveform in Analyzed_data.


if sorted
    mkdir sort
    cd ([exp_folder,'\sort_merge_spike'])
    all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
    n_file = length(all_file) ;
else
    mkdir unsort
    cd ([exp_folder,'\merge'])
    all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
    n_file = length(all_file) ;
end
cd(code_folder);

    
    
    % put your stimulus here!!
    if strcmp(type,'abs')
        TheStimuli=absolute_pos;  %recalculated bar position
    elseif strcmp(type,'pos')
        TheStimuli=bin_pos;
    elseif strcmp(type,'v')
        TheStimuli=diff(bin_pos);
        TheStimuli = ([0 TheStimuli] + [TheStimuli 0]) /2;
    end
    
    % Binning
    bin=BinningInterval*10^3; %ms
    BinningTime =diode_BT;
    
    StimuSN=25; %number of stimulus states
    if strcmp(type,'abs')
        nX=sort(TheStimuli,2);
        abin=length(nX)/StimuSN;
        isi2 = zeros(60,length(TheStimuli));
        for k = 1:60
            if sum(absolute_pos(k,:))>0
                intervals=[nX(k,1:abin:end) inf]; % inf: the last term: for all rested values
                for jj=1:length(TheStimuli)
                    isi2(k,jj) = find(TheStimuli(k,jj)<intervals,1);
                end
            end
        end
    elseif strcmp(type,'pos') || strcmp(type,'v')
        nX=sort(TheStimuli);
        abin=length(nX)/StimuSN;
        intervals=[nX(1:abin:end) inf]; % inf: the last term: for all rested values
        temp=0; isi2=[];
        for jj=1:length(TheStimuli)
            isi2(jj) = find(TheStimuli(jj)<intervals,1);
        end
    elseif strcmp(type,'pos&v')
        TheStimuli = zeros(2, length(bin_pos));
        TheStimuli(1,:)=bin_pos;
        TheStimuli(2,:) = ([0 diff(bin_pos)] + [diff(bin_pos) 0]) /2;
        nX1=sort(TheStimuli(1,:));
        nX2=sort(TheStimuli(2,:));
        sqrtStimuSN = 5;
        StimuSN = 25;
        abin=length(nX1)/sqrtStimuSN;
        intervals1=[nX1(1:abin:end) inf]; % inf: the last term: for all rested values
        abin=length(nX2)/sqrtStimuSN;
        intervals2=[nX2(1:abin:end) inf]; % inf: the last term: for all rested values
        temp=0; isi3=[]; isi2=[];
        for jj=1:length(TheStimuli)
            isi3(1,jj) = find(TheStimuli(1,jj)<intervals1,1);
            isi3(2,jj) = find(TheStimuli(2,jj)<intervals2,1);
        end
        isi2 = 5*(isi3(1,:)-2) + (isi3(2,:)-2) + 1;
    end
    
    %% BinningSpike
    BinningSpike = zeros(60,length(BinningTime));
    analyze_spikes = cell(1,60);
    if sorted
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
                        analyze_spikes{i} = [analyze_spikes{i} sorted_spikes{u,i}'];
                    end
                else
                    analyze_spikes{i} = [analyze_spikes{i} sorted_spikes{1,i}'];
                end
            else
                for u = unit
                    analyze_spikes{i} = [analyze_spikes{i} sorted_spikes{u,i}'];
                end
            end
            analyze_spikes{i} = sort(analyze_spikes{i});
        end
    else
        analyze_spikes = reconstruct_spikes;
    end
    for i = display_channel  % i is the channel number
        [n,~] = hist(analyze_spikes{i},BinningTime) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
        BinningSpike(i,:) = n ;
    end
    %% Predictive information & find peak of MI
    backward=ceil(15000/bin);
    forward=ceil(15000/bin);
    time=[-backward*bin:bin:forward*bin];
    MI_peak=zeros(1,60);
    ind_peak=zeros(1,60);
    peak_times = zeros(1,60)-1000000;
    P_channel = [];
    N_channel = [];
    for channelnumber=display_channel
        
        Neurons = BinningSpike(channelnumber,:);  %for single channel
        if strcmp(type,'abs')
            if sum(absolute_pos(channelnumber,:))>0
                information = MIfunc(Neurons,isi2(channelnumber,:),BinningInterval,backward,forward);
            else
                Mutual_infos{channelnumber} = zeros(1,length(time));
                Mutual_shuffle_infos{channelnumber} =zeros(1,length(time));;
                continue
            end
        else
            information = MIfunc(Neurons,isi2,BinningInterval,backward,forward);
        end
        %% shuffle MI
        sNeurons=[];
        r=randperm(length(Neurons));
        for j=1:length(r)
            sNeurons(j)=Neurons(r(j));
        end
        Neurons_shuffle=sNeurons;
        
        if strcmp(type,'abs')
            information_shuffle = MIfunc(Neurons_shuffle,isi2(channelnumber,:),BinningInterval,backward,forward);
        else
            information_shuffle = MIfunc(Neurons_shuffle,isi2,BinningInterval,backward,forward);
        end
        
        Mutual_infos{channelnumber} = information;
        Mutual_shuffle_infos{channelnumber} = information_shuffle;
        
        %find peaks
        if max(Mutual_infos{channelnumber}-mean(Mutual_shuffle_infos{channelnumber}))<0.1
            continue;
        end
        Mutual_infos{channelnumber} = smooth(Mutual_infos{channelnumber});
        [MI_peak(channelnumber), ind_peak(channelnumber)] = max(Mutual_infos{channelnumber}); % MI_peak{number of data}{number of channel}
        if (time(ind_peak(channelnumber)) < -1000) || (time(ind_peak(channelnumber)) > 1000) % the 100 points, timeshift is 1000
            MI_peak(channelnumber) = NaN;
            ind_peak(channelnumber) = NaN;
        end
        % ======= exclude the MI that is too small ===========
        pks_1d=ind_peak(channelnumber);
        peaks_ind=pks_1d(~isnan(pks_1d));
        peaks_time = time(peaks_ind);
        % ============ find predictive cell=============
        if peaks_time>=0
            P_channel=[P_channel channelnumber];
        elseif peaks_time<0
            N_channel=[N_channel channelnumber];
        end
        if length(peaks_time)>0
            peak_times(channelnumber) = peaks_time;
        end
    end
    acf = autocorr(bin_pos,100);
    corr_time = find(abs(acf-0.5) == min(abs(acf-0.5)))/60;
    
    plot(time,Mutual_infos{channelnumber},'LineWidth',1.5); hold on; %,'color',cc(z,:));hold on
plot(time,Mutual_shuffle_infos{channelnumber},'LineWidth',1.5); hold on; %,'color',cc(z,:));hold on
xlabel('delta t (ms)');ylabel('MI (bits/second)( minus shuffled)');
set(gca,'fontsize',12); hold on

 

xlim([ -3000 3000])
% ylim([0 inf])
title(['channel ',num2str(channelnumber)]) 
    
end


