% Calculated MI for continuos changing intensity stimulation , by Rona
close all
clear all;
code_folder = pwd;
%exp_folder = 'D:\Leo\1012exp';
exp_folder_cell = {'D:\Leo\0225', 'D:\Leo\1219exp' ,'D:\Leo\1017exp'};
type_folder_cell = {'wf', 'wfv', 'wfi&v'}; %'wf', 'wfv', 'wfi&v'.
for eee = 1
for ttt = 1
exp_folder = exp_folder_cell{eee};
cd(exp_folder);
mkdir MI
cd MI
sorted =1;
unit = 0;
type = type_folder_cell{ttt}; 
if sorted
    mkdir sort
    cd ([exp_folder,'\sort'])
    all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
    n_file = length(all_file) ;
else
    mkdir unsort
    cd ([exp_folder,'\data'])
    all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
    n_file = length(all_file) ;
end
cd(code_folder);



SamplingRate=20000;
roi = [1:60];
for z =1:n_file
    Mutual_infos = cell(1,60);
    Mutual_shuffle_infos = cell(1,60);
    
    
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    if strcmp(filename(1),'H') || strcmp(filename(1),'O')
    else
        continue
    end
    load([directory(1:end-5),'data\',filename]);
    load([directory,filename]);
    z
    name
    bin=10;  BinningInterval = bin*10^-3;
    %backward=ceil(1000/bin); forward=ceil(1000/bin);
    %%  TimeStamps  %%%%%%%%%%%%%%%%%%%
    %     if size(a_data,1)==1              %only find one analog channel, possibly cause by the setting in MC_rack
    %         a_data2 = a_data(1,:);
    %     else
    %         a_data2 = a_data(2,:);
    %     end
    %     [~,locs]=findpeaks(diff(a_data2),'MINPEAKHEIGHT',5*std(diff(a_data2)));
    %     analog_loc = (locs)/SamplingRate;
    %     TimeStamps = analog_loc;
    %
    % TimeStamps =[TimeStamps_H(1):TimeStamps_N(end)]
    if length(TimeStamps)==1
        TimeStamps(2)=TimeStamps(1)+200;
    end
    
    %% diode as isi2
    %    load(['E:\google_rona\20170502\diode\diode_',filename]);
    %      [~,locs_a2]=findpeaks(diff(diff(a2)),'MINPEAKHEIGHT',5*std(diff(diff(a2))));
    %      TimeStamps_a2 = (locs_a2)/SamplingRate;
    %
    % %     [b,a]=butter(2,60/20000,'low');
    % %     a_data2=filter(b,a,callumin)';
    % %     a_data2=eyf;
    %     isi = callumin_filter(TimeStamps_a2(1)*20000:TimeStamps_a2(end)*20000);
    % %     figure(z);autocorr(isi,100000);
    %% state of light intensity  of change rate %%%
    [b,a] = butter(2,50/20000,'low'); % set butter filter
    a_data2 = filter(b,a,a_data(1,:));
    isi = a_data2(TimeStamps(1)*20000:TimeStamps(end)*20000);% figure;plot(isi);
    if strcmp(type,'wf') %for whole field stimuli
        isi2=[];
        states=25;
        X=isi;
        nX = sort(X);
        abin = length(nX)/states;
        intervals = [nX(1:abin:end) inf];
        temp=0;
        for jj = 1:BinningInterval*SamplingRate:length(X)
            temp=temp+1;
            isi2(temp) = find(X(jj)<intervals,1)-1; % stimulus for every 50ms
        end
        %TheStimuli= absolute_pos;  %recalculated bar position
    elseif strcmp(type,'wfv')  %for change rate of whole field stimuli
        isi5=[];isi4=[];
        isi5 = isi(1:BinningInterval*SamplingRate:length(isi));
        isi5=diff(isi5);
        isi5 = ([0 isi5] + [isi5 0]) /2;
        isi2=[];
        states=25;
        X=isi5;
        nX = sort(X);
        abin = length(nX)/states;
        intervals = [nX(1:abin:end) inf];
        temp=0;
        for jj = 1:length(X)
            temp=temp+1;
            isi2(temp) = find(X(jj)<intervals,1)-1; % stimulus for every 50ms
        end
    elseif strcmp(type,'wfi&v')  %for change rate of whole field stimuli
        isi2=[]; isi3=[];
        states=5;
        X=isi;
        nX = sort(X);
        abin = length(nX)/states;
        intervals = [nX(1:abin:end) inf];
        temp=0;
        for jj = 1:BinningInterval*SamplingRate:length(X)
            temp=temp+1;
            isi3(1,temp) = find(X(jj)<intervals,1)-1; % stimulus for every 50ms
        end
        isi5 = isi(1:BinningInterval*SamplingRate:length(isi));
        X=([0 diff(isi5)] + [diff(isi5) 0]) /2;
        nX = sort(X);
        abin = length(nX)/states;
        intervals = [nX(1:abin:end) inf];
        temp=0;
        for jj = 1:length(X)
            temp=temp+1;
            isi3(2,temp) = find(X(jj)<intervals,1)-1; % stimulus for every 50ms
        end
        isi2 =states*(isi3(1,:)-1) + (isi3(2,:)-1) + 1;
    end
    plot(isi2);
    %% Spike process
    BinningTime = [TimeStamps(1) : BinningInterval : TimeStamps(end)];
    BinningSpike = zeros(60,length(BinningTime));
    analyze_spikes = cell(1,60);
    complex_channel = [];
    
    if sorted
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
    else
        analyze_spikes = Spikes;
    end
    
    
    for i = 1:60
        [n,xout] = hist(analyze_spikes{i},BinningTime) ;
        BinningSpike(i,:) = n ;
    end
    % [n,out] = hist(TimeStamps,BinningTime);
    % Stimuli = n;
    BinningSpike(:,1) = 0;BinningSpike(:,end) = 0;% figure;plot(BinningTime,sum(BinningSpike),BinningTime,10*Stimuli,'o')
    %     figure;imagesc(BinningTime,[1:60],BinningSpike)
    
    %% Mutual Information
    %% Predictive information
    backward=ceil(15000/bin);
    forward=ceil(15000/bin);
    time=[-backward*bin:bin:forward*bin];
    MI_peak=zeros(1,60);
    ind_peak=zeros(1,60);
    peak_times = zeros(1,60)-1000000;
    P_channel = [];
    N_channel = [];
    for channelnumber =1:60
        
        Neurons = BinningSpike(channelnumber,:);  %for single channel
        
        information = MIfunc(Neurons,isi2,BinningInterval,backward,forward);
        
        %% shuffle MI
        sNeurons=[];
        r=randperm(length(Neurons));
        for j=1:length(r)
            sNeurons(j)=Neurons(r(j));
        end
        Neurons_shuffle=sNeurons;
        
        
        information_shuffle = MIfunc(Neurons_shuffle,isi2,BinningInterval,backward,forward);
        
        
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
    acf = autocorr(isi,round(100/60*20000));
    corr_time = find(abs(acf-0.5) == min(abs(acf-0.5)))/20000;
    if sorted
        save([exp_folder,'\MI\sort\', type,'_',name,'.mat'],'time','Mutual_infos','Mutual_shuffle_infos', 'corr_time')
    else
        save([exp_folder,'\MI\unsort\', type,'_',name,'.mat'],'time','Mutual_infos','Mutual_shuffle_infos', 'corr_time')
    end
end
end
end
