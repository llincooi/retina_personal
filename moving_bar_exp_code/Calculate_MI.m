clear all;
code_folder = pwd;
%exp_folder = 'D:\Leo\1012exp';
num_peak = 2;
exp_folder_cell = {'D:\Leo\0409', 'C:\Users\llinc\OneDrive\Documents\GitHub\retina_personal\0406' ,'D:\Leo\1017exp'};
type_folder_cell = {'pos', 'v', 'pos&v'};%'abs', 'pos', 'v', 'pos&v'.
for ttt = 1
for eee = 2
exp_folder = exp_folder_cell{eee};
cd(exp_folder);
mkdir MI
cd MI
type = type_folder_cell{ttt}; 
sorted = 0;
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
for z =13:2:21;%1:n_file %choose file
    Mutual_infos = cell(1,60);
    Mutual_shuffle_infos = cell(1,60);
    
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    if (strcmp(filename(12),'H') || strcmp(filename(12),'O')) && sorted == 0
    elseif (strcmp(filename(17),'H') || strcmp(filename(17),'O')) && sorted
    else
        continue
    end
    
    load([directory,filename]);
    
    name=[name];
    z
    name
    
    
    % put your stimulus here!!
    if strcmp(type,'abs')
        TheStimuli=absolute_pos;  %recalculated bar position
    elseif strcmp(type,'pos')
        TheStimuli=bin_pos;
    elseif strcmp(type,'v')
        x=bin_pos;
        TheStimuli = finite_diff(x ,4);
    end
    
    % Binning
    bin=BinningInterval*10^3; %ms
    BinningTime =diode_BT;
    
    StimuSN=6; %number of stimulus states
    if strcmp(type,'abs')
        nX=sort(TheStimuli,2);
        abin=length(nX)/StimuSN;
        isi2 = zeros(60,length(TheStimuli));
        for k = 1:60
            if sum(absolute_pos(k,:))>0
                intervals=[nX(k,abin:abin:end) inf]; % inf: the last term: for all rested values
                for jj=1:length(TheStimuli)
                    isi2(k,jj) = find(TheStimuli(k,jj)<=intervals,1);
                end
            end
        end
    elseif strcmp(type,'pos') || strcmp(type,'v')
        nX=sort(TheStimuli);
        abin=length(nX)/StimuSN;
        intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
        temp=0; isi2=[];
        for jj=1:length(TheStimuli)
            isi2(jj) = find(TheStimuli(jj)<=intervals,1);
        end
    elseif strcmp(type,'pos&v')
        TheStimuli = zeros(2, length(bin_pos));
        TheStimuli(1,:)=bin_pos;
        x = TheStimuli(1,:);
        TheStimuli(2,:) = finite_diff(x ,4);
        nX1=sort(TheStimuli(1,:));
        nX2=sort(TheStimuli(2,:));
        abin=length(nX1)/StimuSN;
        intervals1=[nX1(abin:abin:end) inf]; % inf: the last term: for all rested values
        abin=length(nX2)/StimuSN;
        intervals2=[nX2(abin:abin:end) inf]; % inf: the last term: for all rested values
        temp=0; isi3=[]; isi2=[];
        for jj=1:length(TheStimuli)
            isi3(1,jj) = find(TheStimuli(1,jj)<=intervals1,1);
            isi3(2,jj) = find(TheStimuli(2,jj)<=intervals2,1);
        end
        isi2 = StimuSN*(isi3(1,:)-1) + isi3(2,:);
    end
    
    %% BinningSpike
    BinningSpike = zeros(60,length(BinningTime));
    analyze_spikes = cell(1,60);
    if sorted
        analyze_spikes = get_multi_unit(exp_folder,sorted_spikes,unit);
    else
        analyze_spikes = reconstruct_spikes;
    end
    for i = 1:60  % i is the channel number
        [n,~] = hist(analyze_spikes{i},BinningTime) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
        BinningSpike(i,:) = n ;
    end
    %% Predictive information & find peak of MI
    backward=ceil(15000/bin);
    forward=ceil(15000/bin);
    time=[-backward*bin:bin:forward*bin];
    MI_peak=zeros(1,60);
    ind_peak=zeros(1,60);
    peak_time = zeros(1,60)-1000000;
    ind_local_max2 = cell(1,60);
    MI_peaks= cell(1,60);
    MI_width = zeros(1,60);
    for channelnumber=1:60
        
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
        
     %% find peaks and width
        mean_MI_shuffle = mean(Mutual_shuffle_infos{channelnumber});
        baseline = mean_MI_shuffle - std(Mutual_shuffle_infos{channelnumber});
        smooth_mutual_information = smooth(Mutual_infos{channelnumber});
        MIdiff = diff(smooth_mutual_information);
        ind_local_extrema = find(MIdiff(1:end-1).*MIdiff(2:end) < 0)+1; %find all local extrema
        if isempty(ind_local_extrema)
            MI_peak(channelnumber) = NaN;
            ind_peak(channelnumber) = NaN;
            continue
        end
        [a I] = sort(smooth_mutual_information(ind_local_extrema), 'descend');
        ind_local_max2{channelnumber} = [];
        for i = 1:num_peak %find the biggest two local extrema with deltat in -1~1 sec.
            if (time(ind_local_extrema(I(i))) < -1000) || (time(ind_local_extrema(I(i))) > 1000) ||  smooth_mutual_information(ind_local_extrema(I(i)))-baseline < 0.1% the 100 points, timeshift is 1000
            else
                ind_local_max2{channelnumber} = [ind_local_max2{channelnumber} ind_local_extrema(I(i))]; %factor out biggest 'num_peak' local extrema
            end
        end
        if isempty(ind_local_max2{channelnumber})
            MI_peak(channelnumber) = NaN;
            ind_peak(channelnumber) = NaN;
        else
            ind_local_max2{channelnumber} = sort(ind_local_max2{channelnumber}, 'descend');
            MI_peaks{channelnumber} = smooth_mutual_information(ind_local_max2{channelnumber});
            %pick the right one
            ind_peak(channelnumber) = ind_local_max2{channelnumber}(1);
            peak_time(channelnumber) = time(ind_peak(channelnumber));
            MI_peak(channelnumber) = smooth_mutual_information(ind_peak(channelnumber));
        end
        
        %calculate MI_width by seeing MI curve as a Gaussian distribution. So the unit of MI_width would be ms.
        mutual_information = Mutual_infos{channelnumber};
        mean_MI_distr = 0;
        sq_MI_distr = 0;
        for j = 1:length(mutual_information)
            if mutual_information(j) > baseline
                mean_MI_distr =  mean_MI_distr+j*(mutual_information(j)-baseline)/sum(mutual_information);
                sq_MI_distr =sq_MI_distr+ j^2*(mutual_information(j)-baseline)/sum(mutual_information);
            end
        end
        MI_width( channelnumber) =sqrt (sq_MI_distr-mean_MI_distr^2);
     
     
    end
    acf = autocorr(bin_pos,100);
    corr_time = interp1(acf,1:length(acf),0.5,'linear')/60;
    if sorted
        save([exp_folder,'\MI\sort\', type,'_',name(12:end),'.mat'],'time','Mutual_infos','Mutual_shuffle_infos','peak_time', 'MI_peak','MI_width', 'ind_local_max2','corr_time')
    else
        save([exp_folder,'\MI\unsort\', type,'_',name(7:end),'.mat'],'time','Mutual_infos','Mutual_shuffle_infos','peak_time', 'MI_peak','MI_width', 'ind_local_max2',  'corr_time')
    end
    
    
end

end
end