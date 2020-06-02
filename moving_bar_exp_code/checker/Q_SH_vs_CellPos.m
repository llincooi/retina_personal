%% This code plot four PI in same picture
%Position is red
%Speed is blue
%synergy is black
%redundancy is green
close all;
clear all;
code_folder = pwd;
exp_folder = 'D:\Leo\0503';
cd(exp_folder)
load('RGC.mat')
load('oled_boundary_set.mat')
sorted =1;
unit = 0;
if sorted
    cd MI\sort
    spike_folder = '\sort_merge_spike\sort_merge_';
else
    cd MI\unsort
    spike_folder = '\merge\merge_';
end
mkdir FIG
mkdir FIG SH_vs_CP
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ;
%Tina orientation
rr =[9,17,25,33,41,49,...
    2,10,18,26,34,42,50,58,...
    3,11,19,27,35,43,51,59,...
    4,12,20,28,36,44,52,60,...
    5,13,21,29,37,45,53,61,...
    6,14,22,30,38,46,54,62,...
    7,15,23,31,39,47,55,63,...
    16,24,32,40,48,56];
% P_channel = [32 48];
% N_channel = [7 8 9 15 16 17 23 24 25];
for z =1:n_file
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    load([name,ext])
    load([exp_folder, spike_folder,name,ext])
    if sorted
        analyze_spikes = get_multi_unit(exp_folder,sorted_spikes,unit);
    else
        analyze_spikes = reconstruct_spikes;
    end
    SH = []; %height of Synergy (unit = mbit/s/spike)
    cell_pos = []; %same coordinate with bar_pos
    for channelnumber=1:60
        if channelnumber == 4 || max(pos_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))<0.1 || isempty(RGCs{channelnumber}.center_RF)
        else
            SH = [SH max(Redun_Mutual_infos{channelnumber})/length(analyze_spikes{channelnumber})*10^3]; 
            cell_pos = [cell_pos Monitor2DCoor2BarCoor(RGCs{channelnumber}.center_RF(1),RGCs{channelnumber}.center_RF(2),'RL','OLED')];
        end
    end
    [cell_pos I] = sort(cell_pos);
    SH = SH(I);
    [N,c] = hist3([cell_pos' SH'], [10, 10]);
    scatter(cell_pos, SH);    hold on;
    xticks([c{1}])
    %xticklabels(1:10)
    mean_SH = sum(N.*c{2},2)./ sum(N,2);
    std_SH = sqrt(sum((N.*(c{2}-mean_SH)).^2,2) ./ sum(N,2));
    errorbar(c{1},mean_SH',std_SH)
    grid on;

    

   

    
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    fig =gcf;
    fig.PaperPositionMode = 'auto';
    fig.InvertHardcopy = 'off';
    saveas(fig,['FIG\SH_vs_CP\SH_vs_CP_',name,'.tif'])
    close(fig)
    %saveas(fig,['FIG\three_mix',name,'.fig'])
    
end