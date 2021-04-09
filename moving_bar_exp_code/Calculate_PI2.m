clear all;
code_folder = pwd;
%exp_folder = 'D:\Leo\1012exp';
exp_folder_cell = {'D:\GoogleDrive\retina\Chou''s data\MB', 'C:\Users\llinc\GitHub\retina_personal\0409' ,'D:\Leo\0503'};
for eee = 1
    exp_folder = exp_folder_cell{eee};
    cd(exp_folder);
    mkdir MI
    cd MI
    sorted = 0;
    special = 0;
    unit = 0; %unit = 0 means using 'unit_a' which is writen down while picking waveform in Analyzed_data.
    if sorted
        mkdir sort
        cd ([exp_folder,'\sort_merge_spike'])
        all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
        n_file = length(all_file) ;
    else
        if special
            mkdir special
            cd ([exp_folder,'\OU_merge_OUsmooth'])
            all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
            n_file = length(all_file) ;
        else
            mkdir unsort
            cd ([exp_folder,'\merge'])
            all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
            n_file = length(all_file) ;
        end
    end
    cd(code_folder);
    for z =1:n_file;%1:n_file %choose file
        pos_Mutual_infos= cell(1,60);
        v_Mutual_infos= cell(1,60);
        joint_Mutual_infos= cell(1,60);
        Redun_Mutual_infos= cell(1,60);
        
        file = all_file(z).name ;
        [pathstr, name, ext] = fileparts(file);
        directory = [pathstr,'\'];
        filename = [name,ext];
        load([directory,filename]);
        
        
        
        z
        name
        
        if strcmp(filename(end-12:end-4),'interrupt')
            bin_pos = abs(bin_pos);
        end
        
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
            
          
        end
        acf = autocorr(bin_pos,100);
        corr_time = interp1(acf,1:length(acf),0.5,'linear')/60;
        if sorted
            save([exp_folder,'\MI\sort\',name(12:end),'.mat'],'time','pos_Mutual_infos','v_Mutual_infos', 'joint_Mutual_infos','Redun_Mutual_infos','peak_time', 'MI_peak','MI_width', 'ind_local_max2','corr_time')
        else
            if special
                save([exp_folder,'\MI\special\',name(7:end),'.mat'],'time','pos_Mutual_infos','v_Mutual_infos', 'joint_Mutual_infos','Redun_Mutual_infos','peak_time', 'MI_peak','MI_width', 'ind_local_max2',  'corr_time')
            else
                save([exp_folder,'\MI\unsort\',name(7:end),'.mat'],'time','pos_Mutual_infos','v_Mutual_infos', 'joint_Mutual_infos','Redun_Mutual_infos','peak_time', 'MI_peak','MI_width', 'ind_local_max2',  'corr_time')
            end
        end
    end
end
