%% This code plot four PI in same picture
%Position is red
%Speed is blue
%synergy is black
%redundancy is green
close all;
clear all;
code_folder = pwd;
exp_folder = 'C:\Users\hydro_leo\Documents\GitHub\retina_personal\0503';
%exp_folder = 'C:\Users\llinc\GitHub\retina_personal\0409';
cd(exp_folder)
load('oled_boundary_set.mat')
sorted =0;
unit = 0;
if sorted
    load('sortRGC.mat')
    cd MI\sort
    spike_folder = '\sort_merge_spike\sort_merge_';
else
    load('unsortRGC.mat')
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
allSH = []; %height of Synergy (unit = mbit/s/spike)
allST = [];
allcell_pos = []; %same coordinate with bar_pos
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
    ST = [];
    cell_pos = []; %same coordinate with bar_pos
    for channelnumber=1:60
        if channelnumber == 4 || isempty(RGCs{channelnumber}.center_RF) || max(pos_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))<0.3 
        else
            peak_time = time(find(Redun_Mutual_infos{channelnumber}==max(Redun_Mutual_infos{channelnumber})));
            if length(peak_time) == 1 && peak_time < 500 && peak_time > -800
                SH = [SH max(Redun_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))/length(analyze_spikes{channelnumber})*10^3]; %
                ST = [ST peak_time];
                cell_pos = [cell_pos Monitor2DCoor2BarCoor(RGCs{channelnumber}.center_RF(1),RGCs{channelnumber}.center_RF(2),'RL','OLED')];
            end
        end
    end
    allSH = [allSH  SH];
    allST = [allST  ST];
    allcell_pos = [allcell_pos cell_pos];
    [cell_pos I] = sort(cell_pos);
    SH = SH(I);
%     [N,c] = hist3([cell_pos' SH'], 'Ctrs', {linspace(leftx_bd,rightx_bd,15), linspace(min(SH),max(SH),9)});
%     scatter(cell_pos, SH);    hold on;
%     xticks([c{1}])
%     %xticklabels(1:10)
%     mean_SH = (sum(N.*c{2},2)./ sum(N,2))';
%     std_SH = (sqrt(sum((N.*((c{2}-mean_SH')).^2),2) ./ sum(N,2)))';
%     errorbar(c{1}(~isnan(mean_SH)),mean_SH(~isnan(mean_SH)),std_SH(~isnan(mean_SH)));
%     ylabel('Synergy Height (bit/s/spike)')
%     xlabel('Cell Position (mm)')
%     v = [[leftx_bar rightx_bar rightx_bar leftx_bar]; [min(ylim) min(ylim), max(ylim) max(ylim)]]';
%     f = [1 2 3 4];
%     p = patch('Faces',f,'Vertices',v,...
%         'EdgeColor','k','FaceColor',[0.9 0.9 0.9],'LineStyle','none');uistack(p,'bottom')
%     grid on;set(gca,'Layer','top')
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     fig =gcf;
%     fig.PaperPositionMode = 'auto';
%     fig.InvertHardcopy = 'off';
%     saveas(fig,['FIG\SH_vs_CP\SH_vs_CP_',name,'.tif'])
%     close(fig)
end
[cell_pos I] = sort(allcell_pos);
SH = allSH(I);
ST = allST(I);

[N,c] = hist3([cell_pos' SH'], 'Ctrs', {linspace(leftx_bd,rightx_bd,15), linspace(min(SH),max(SH),9)});
scatter3(cell_pos, SH, ST);
figure;scatter( cell_pos, SH);hold on;

xticks([c{1}])
%xticklabels(1:10)
mean_SH = (sum(N.*c{2},2)./ sum(N,2))';
std_SH = (sqrt(sum((N.*((c{2}-mean_SH')).^2),2) ./ sum(N,2)))';
errorbar(c{1}(~isnan(mean_SH)),mean_SH(~isnan(mean_SH)),std_SH(~isnan(mean_SH)));
ylabel('Synergy Height (bit/s/spike)')
xlabel('Cell Position (mm)')
v = [[leftx_bar rightx_bar rightx_bar leftx_bar]; [min(ylim) min(ylim), max(ylim) max(ylim)]]';
f = [1 2 3 4];
p = patch('Faces',f,'Vertices',v,...
    'EdgeColor','k','FaceColor',[0.9 0.9 0.9],'LineStyle','none');uistack(p,'bottom')
grid on;set(gca,'Layer','top')
set(gcf,'units','normalized','outerposition',[0 0 1 1])
fig =gcf;
fig.PaperPositionMode = 'auto';
fig.InvertHardcopy = 'off';
% saveas(fig,['FIG\SH_vs_CP\SH_vs_CP_ALL.tif'])
% close(fig)