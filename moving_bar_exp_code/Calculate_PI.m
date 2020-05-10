clear all;
code_folder = pwd;
%exp_folder = 'D:\Leo\1012exp';
num_peak = 2;
exp_folder_cell = {'D:\Leo\0503', 'C:\Users\llinc\OneDrive\Documents\GitHub\retina_personal\0503' ,'D:\Leo\0409'};
type_folder_cell = {'pos', 'v', 'pos&v'};%'abs', 'pos', 'v', 'pos&v'.
for eee = 3
exp_folder = exp_folder_cell{eee};
cd(exp_folder);
mkdir MI
cd MI
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
for z =[1:12 14:2:20 22:n_file];%1:n_file %choose file
    pos_Mutual_infos= cell(1,60);
    v_Mutual_infos= cell(1,60);
    joint_Mutual_infos= cell(1,60);
    Redun_Mutual_infos= cell(1,60);
        
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
    
    %% BinningStimulus
    bin=BinningInterval*10^3; %ms
    BinningTime =diode_BT;
    StimuSN=6; %number of stimulus states
    
    isix = binning(bin_pos,'pos',StimuSN);
    isiv = binning(bin_pos,'v',StimuSN);
    isii = StimuSN*(isix)+isiv;
    
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
        [MIx MIv Redundancy] = PIfunc(Neurons,isix,isiv,BinningInterval,backward,forward);
        MIxv = MIfunc(Neurons,isii,BinningInterval,backward,forward);
        
        pos_Mutual_infos{channelnumber} = MIx;
        v_Mutual_infos{channelnumber} = MIv;
        joint_Mutual_infos{channelnumber} = MIxv;
        Redun_Mutual_infos{channelnumber} = Redundancy;
        
     %% find peaks and width
        baseline = min(Redundancy);
        smooth_mutual_information = smooth(MIx);
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
        mutual_information = MIx;
        mean_MI_distr = 0;
        sq_MI_distr = 0;
        for j = 1:length(mutual_information)
            if mutual_information(j) > baseline
                mean_MI_distr =  mean_MI_distr+j*(mutual_information(j)-baseline)/sum(mutual_information);
                sq_MI_distr =sq_MI_distr+ j^2*(mutual_information(j)-baseline)/sum(mutual_information);
            end
        end
        MI_width(channelnumber) =sqrt(sq_MI_distr-mean_MI_distr^2);

    end
    acf = autocorr(bin_pos,100);
    corr_time = interp1(acf,1:length(acf),0.5,'linear')/60;
    if sorted
        save([exp_folder,'\MI\sort\',name(12:end),'.mat'],'time','pos_Mutual_infos','v_Mutual_infos', 'joint_Mutual_infos','Redun_Mutual_infos','peak_time', 'MI_peak','MI_width', 'ind_local_max2','corr_time')
    else
        save([exp_folder,'\MI\unsort\',name(7:end),'.mat'],'time','pos_Mutual_infos','v_Mutual_infos', 'joint_Mutual_infos','Redun_Mutual_infos','peak_time', 'MI_peak','MI_width', 'ind_local_max2',  'corr_time')
    end
end

end
