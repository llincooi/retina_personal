clear all;
code_folder = pwd;
%exp_folder = 'D:\Leo\1012exp';
exp_folder_cell = {'D:\Leo\0409', 'C:\Users\llinc\GitHub\retina_personal\0503' ,'D:\Leo\0503'};
for eee = 2
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
    p_state =zeros(60,4);
    for i = 1:60  % i is the channel number
        for j = unique(BinningSpike(i,:))
            if j>=3
                p_state(i,4) = p_state(i,4)+length(find(BinningSpike(i,:) == j))/length(BinningSpike(i,:));
            else
                p_state(i,j+1) = length(find(BinningSpike(i,:) == j))/length(BinningSpike(i,:));
            end
        end
    end
    [pdakjsk I] = sort(p_state, 2);
    if ~isempty(find(I(:,3) ~= 2))
        print('Oops');
        break
    end
    
end
end
