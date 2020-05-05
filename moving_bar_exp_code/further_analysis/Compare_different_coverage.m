close all;
clear all;
code_folder = pwd;
exp_folder = 'D:\Leo\0409';
cd(exp_folder)
cd Analyzed_data
target_set = 5;
sorted =0;
G = 2.5;
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ; 
for i = 1:n_file
    if all_file(i).name(1) == num2str(target_set)
        load(all_file(i).name);
    end
end
cd ..
%Load calculated MI first(Need to run Calculate_MI.m first to get)
if sorted
    cd MI\sort
else
    cd MI\unsort
end
rr =[9,17,25,33,41,49,...
    2,10,18,26,34,42,50,58,...
    3,11,19,27,35,43,51,59,...
    4,12,20,28,36,44,52,60,...
    5,13,21,29,37,45,53,61,...
    6,14,22,30,38,46,54,62,...
    7,15,23,31,39,47,55,63,...
    16,24,32,40,48,56];

HMM_MI =[];
HMM_MI_shuffle = [];
allchannellegend = cell(1,length(coverages));
% corr_t_legend = cell(1,length(HMM_different_G)+length(OU_different_G));
% t_corr_serie =[];
% time_serie = cell(length(HMM_different_G)+length(OU_different_G),1);
MI_widths = [];
MI_peaks = [];
peak_times = [];
coverages = sort(coverages);
for     C =1:length(coverages)
    if coverages(C) == 0
        load([HMM_former_name,num2str(G),HMM_middle_name ,'.mat'])
    else
        load([HMM_former_name,num2str(G),HMM_middle_name ,'_',num2str(coverages(C)) ,'covered.mat'])
    end
        HMM_MI = [HMM_MI;Mutual_infos];
        HMM_MI_shuffle = [HMM_MI_shuffle ;Mutual_shuffle_infos];
        %MI_widths = [MI_widths; MI_width];
        MI_peaks = [MI_peak; MI_peak];
        %peak_times = [peak_times; peak_time];
        allchannellegend{C} = ['C', num2str(coverages(C))];
        %corr_t_legend{G} = num2str(corr_time);
        %t_corr_serie = [t_corr_serie corr_time];
        time_serie{C} = time;
end


load([OU_former_name,num2str(G),OU_post_name ,'.mat'])
OU_MI = [Mutual_infos];
OU_MI_shuffle = [Mutual_shuffle_infos];
%corr_t_legend{G+length(HMM_different_G)} = ['OU-', num2str(corr_time)];
%time_serie{G+length(HMM_different_G)} = time;

figure('IntegerHandle', 'off', 'units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);

MI_peaks=zeros(length(coverages),60);
ind_peak=zeros(length(coverages),60);
peak_times = zeros(length(coverages),60);
channel_anticipation_power = zeros(2,60);
for channelnumber=1:60 %choose file
    axes(ha(rr(channelnumber)));
    for    C =1:length(coverages)
        mean_MI_shuffle = mean(cell2mat(HMM_MI_shuffle(C,channelnumber)));
        mutual_information = cell2mat(HMM_MI (C,channelnumber));
        if channelnumber~=4
            if max(mutual_information-mean_MI_shuffle)<0.1
                continue;
            else
                plot(time_serie{C},mutual_information-mean_MI_shuffle); hold on; %,'color',cc(z,:));hold on
                xlim([ -2300 1300])
                ylim([0 inf+0.1])
                title(channelnumber);
            end
        else
            plot(time,mutual_information-mean_MI_shuffle); hold on; %,'color',cc(z,:));hold on
            xlim([ -1500 2000])
            ylim([0 100])
            lgd =legend(allchannellegend,'Location','north');
            lgd.FontSize = 8;
            legend('boxoff')
        end
    end
    hold off;
    saveas(gcf,['FIG\',name,'.tif'])
end