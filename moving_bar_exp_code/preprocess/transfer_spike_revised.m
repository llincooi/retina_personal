%% This code specially transfer only A unit spikes from offlinesorter
%sorted_spikes stores all spikes in A unit. It is a 1*60(channel) cell
clear all;
close all;
exp_folder = 'D:\Leo\0409';
cd(exp_folder);
mkdir sort_merge_spike
cd merge

all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ; 

for m = 1:n_file
    if strcmp(all_file(m).name,'onoff') or strcmp(all_file(m).name,'spon')
        continue;
    end
    load(all_file(m).name);
    file = all_file(m).name(7:end);
    load([exp_folder,'\sort\',file]);
    
    sorted_spikes=cell(size(Spikes,1),60);
    for j = 1:length(Spikes)    %running through each channel
        for u = 1:size(Spikes,1)
            ss = Spikes{u,j};
            ss(ss<TimeStamps(1,1)) = [];  %delete the spikes before TimeStamps(1)
            ss(ss>TimeStamps(1,2))=[];
            ss = ss - TimeStamps(1,1);
            sorted_spikes{u,j} = ss;
        end
    end
    
    save([exp_folder,'\sort_merge_spike','\sort_merge_',file],'sorted_spikes','bin_pos','TimeStamps','reconstruct_spikes','diode_BT','BinningInterval');
end

cd ..