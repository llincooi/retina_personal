clear all;
code_folder = pwd;
sorted =0;
exp_folder = 'E:\20200418';
exp_folder = 'C:\Users\llinc\OneDrive\Documents\GitHub\retina_personal\0406';
cd (exp_folder)
if sorted
    load('Analyzed_data\30Hz_27_RF_15min\sort\RF_properties.mat')
    cd ([exp_folder,'\STA\sort'])
    mkdir MI
    all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
    n_file = length(all_file) ;
else
    load('Analyzed_data\30Hz_27_RF_15min\unsort\RF_properties.mat')
    cd ([exp_folder,'\STA\unsort'])
    mkdir MI
    all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
    n_file = length(all_file) ;
end
roi = find(RF_properties(:,2)~=0)';
sort_directory = 'sort';
cd(code_folder);

type_folder_cell = {'pos', 'v'};%'abs', 'pos', 'v', 'pos&v'.
choose_type = 1:2;
for z = [19:n_file] %choose file
    PCA_Mutual_infos = cell(6,60);
    PCA_Mutual_shuffle_infos = cell(6,60);
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [all_file(z).folder,'\'];
    filename = [name,ext];
    load([directory ,filename]);
    name=[name];
    z
    name
    if strcmp(name(1:3),'pos')
        continue
    end
    Red_BinningSpike = BinningSpike;
    Blue_BinningSpike = BinningSpike;
    for i = roi
        num_spike = 1;
        idx = idxs{i};
        if ~isempty(idx)
            for time_shift = forward+1:length(BinningTime)-backward
                for x = 1:BinningSpike(i,time_shift)
                    %Red is 1, Blue is 2
                    if idx(num_spike) == 1
                        Blue_BinningSpike(i,time_shift) = Blue_BinningSpike(i,time_shift) -1;
                    elseif idx(num_spike) == 2
                        Red_BinningSpike(i,time_shift) = Red_BinningSpike(i,time_shift) -1;
                    end
                    num_spike = num_spike+1;
                end
            end
        end
    end
    % Binning
    StimuSN=6; %number of stimulus states
    for ttt = choose_type
        type = type_folder_cell{ttt}
        isi2 = binning(TheStimuli,type,StimuSN);
        %% Predictive information
        backward=ceil(15000/bin);
        forward=ceil(15000/bin);
        time=[-backward*bin:bin:forward*bin];
        for channelnumber= roi
            channelnumber
            Blue_Neurons = Blue_BinningSpike(channelnumber,:);  %for single channel
            Red_Neurons = Red_BinningSpike(channelnumber,:);  %for single channel
            Blue_information = MIfunc(Blue_Neurons,isi2,BinningInterval,backward,forward);
            Red_information = MIfunc(Red_Neurons,isi2,BinningInterval,backward,forward);
            
            %% shuffle MI
            sNeurons=[];
            r=randperm(length(Blue_Neurons));
            BlueNeurons_shuffle= zeros(1,length(Blue_Neurons));
            RedNeurons_shuffle= zeros(1,length(Red_Neurons));
            for j=1:length(r)
                BlueNeurons_shuffle(j)=Blue_Neurons(r(j));
                RedNeurons_shuffle(j)=Red_Neurons(r(j));
            end
            Blue_information_shuffle = MIfunc(BlueNeurons_shuffle,isi2,BinningInterval,backward,forward);
            Red_information_shuffle = MIfunc(RedNeurons_shuffle,isi2,BinningInterval,backward,forward);
            PCA_Mutual_infos{1+3*(ttt-1),channelnumber} = Blue_information;
            PCA_Mutual_shuffle_infos{1+3*(ttt-1),channelnumber} = Blue_information_shuffle;
            PCA_Mutual_infos{2+3*(ttt-1),channelnumber} = Red_information;
            PCA_Mutual_shuffle_infos{2+3*(ttt-1),channelnumber} = Red_information_shuffle;
            if sorted
                load([exp_folder,'\MI\sort\',type,'_',name,'.mat'])
            else
                load([exp_folder,'\MI\unsort\',type,'_',name,'.mat'])
            end
                PCA_Mutual_infos{3+3*(ttt-1),channelnumber} = Mutual_infos{channelnumber}';
                PCA_Mutual_shuffle_infos{3+3*(ttt-1),channelnumber} = Mutual_shuffle_infos{channelnumber}';
        end
    end
    if sorted
        save([exp_folder,'\STA\sort\MI\',name,'.mat'],'STA_time','dis_STA','bin_pos','corr_time','idxs','PCA_STAs','positive_PCAs','negative_PCAs','time','PCA_Mutual_infos','PCA_Mutual_shuffle_infos','positive_before_pos','negative_before_pos','corr_time')
    else
        save([exp_folder,'\STA\unsort\MI\',name,'.mat'],'STA_time','dis_STA','bin_pos','corr_time','idxs','PCA_STAs','positive_PCAs','negative_PCAs','time','PCA_Mutual_infos','PCA_Mutual_shuffle_infos','positive_before_pos','negative_before_pos','corr_time')
    end
end
