close all;
clear all;
code_folder = pwd;
%exp_folder = 'C:\Users\llinc\OneDrive\Documents\GitHub\retina_personal\0503';
exp_folder = 'D:\Leo\0409';
exp_folder ='C:\Users\llinc\GitHub\retina_personal\0409';
cd(exp_folder)
target_set = '6';
sorted =1;
cd Analyzed_data
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ; 
for i = 1:n_file
    if all_file(i).name(1) == target_set
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
load('rr.mat')

HMM_MI =[];
baselines = [];
allchannellegend = cell(1,length(HMM_different_G));
corr_t_legend = cell(1,length(HMM_different_G)+length(OU_different_G));
t_corr_serie =[];
time_serie = cell(length(HMM_different_G)+length(OU_different_G),1);
MI_widths = [];
MI_peaks = [];
peak_times = [];
for     G =1:length(HMM_different_G)
    load([HMM_former_name,num2str(HMM_different_G(G)),HMM_post_name ,'.mat'])
    HMM_MI = [HMM_MI;pos_Mutual_infos];
    baselines = [baselines ;min(cell2mat(Redun_Mutual_infos'), [], 2)'];
    MI_widths = [MI_widths; MI_width];
    MI_peaks = [MI_peaks; MI_peak];
    peak_times = [peak_times; peak_time];
    allchannellegend{G} = ['G', num2str(HMM_different_G(G))];
    corr_t_legend{G} = num2str(corr_time);
    t_corr_serie = [t_corr_serie corr_time];
    time_serie{G} = time;
end
OU_MI =[];
OU_baselines = [];
for     G =1:length(OU_different_G)
    load([OU_former_name,num2str(OU_different_G(G)),OU_post_name ,'.mat'])
    OU_MI = [OU_MI;pos_Mutual_infos];
    OU_baselines = [OU_baselines ;min(cell2mat(Redun_Mutual_infos'), [], 2)'];
    corr_t_legend{G+length(HMM_different_G)} = ['OU-', num2str(corr_time)];
    time_serie{G+length(HMM_different_G)} = time;
end

%% plot ALL ch.
figure('IntegerHandle', 'off', 'units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);

channel_anticipation_power = zeros(2,60);
for channelnumber=1:60 %choose file
    axes(ha(rr(channelnumber)));
    for     G =1:length(HMM_different_G)
        baseinfo = baselines(G,channelnumber);
        mutual_information = cell2mat(HMM_MI (G,channelnumber));
        if channelnumber~=4
            if max(mutual_information-baseinfo)<0.1
                continue;
            else
                plot(time_serie{G},mutual_information-baseinfo); hold on; %,'color',cc(z,:));hold on
                xlim([ -2300 1300])
                ylim([0 inf+0.1])
                title(channelnumber);
            end
        else
            plot(time,mutual_information-baseinfo); hold on; %,'color',cc(z,:));hold on
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
displychannel = find(sum(isnan(MI_peaks)) == 0);
%% Chose by hand and plot single channels
for channelnumber=displychannel%
    figure(channelnumber)
    for   G =1:length(HMM_different_G)
        mutual_information = cell2mat(HMM_MI (G,channelnumber)) ;hold on;
        baseinfo = baselines(G,channelnumber);
        plot(time_serie{G},smooth(mutual_information- baseinfo ),'LineWidth',1.5,'LineStyle','-');
        xlim([ -2300 1300])
        ylim([0 inf+0.1])
    end
    for   G =1:length(OU_different_G)
        baseinfo = OU_baselines(G,channelnumber);
        mutual_information = cell2mat(OU_MI (G,channelnumber));hold on;
        plot(time_serie{G+length(HMM_different_G)},smooth(mutual_information - baseinfo ),'LineWidth',1.5,'LineStyle',':');
        xlim([ -1300 1300])
        ylim([0 inf+0.1])
    end
    title(channelnumber);
    xlabel('\deltat (ms)');ylabel('MI (bits/second)');
    set(gca,'fontsize',12 ); hold on
    lgd =legend(corr_t_legend,'Location','northwest');
    lgd.FontSize = 11;
    legend('boxoff')
    grid on
    hold off;
    %
    figure(channelnumber+100)
    plot(t_corr_serie,peak_times(:,channelnumber ),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
    xlabel('t_c_o_r_r (ms)');ylabel('t_s_h_i_f_t (ms)');
    title(channelnumber);
    set(gca,'fontsize',12 );
%     %
%     figure(channelnumber+200)
%     plot(t_corr_serie,MI_peaks(:,channelnumber ),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
%     xlabel('t_c_o_r_r (ms)');ylabel('MI peak (bits/second)');
%     title(channelnumber);
%     set(gca,'fontsize',12 );
%     %
%     figure(channelnumber+300)
%     plot(t_corr_serie,MI_widths(:, channelnumber),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
%     xlabel('t_c_o_r_r (ms)');ylabel('MI width (time)');
%     title(channelnumber);
%     set(gca,'fontsize',12 );
end

%% Calculate MI_properties
channel_anticipation_power(:,find(sum(isnan(MI_peaks)) > 0)) = NaN;
%channel_anticipation_power(1,:): 
%     NaN -> useless cell
%     0   -> NP cell
%     >0  -> P cell
%     <0  -> Odd cell
for channelnumber = displychannel
    if mean(peak_times(:, channelnumber)) < 0 % NP cell (all t_shift < 0)
        if std(peak_times(:, channelnumber)) > 50 % exclude Odd cell
            channel_anticipation_power(1,channelnumber) = -1; 
        end
    else % P cell
        f = fit(t_corr_serie',peak_times(:,channelnumber ),'poly1'); %fit a line
        channel_anticipation_power(1,channelnumber) = atan(f.p1/1000); % define the anticipation power to be the angle. (angle> 0) % exclude Odd cell here
        channel_anticipation_power(2,channelnumber) = f.p2; % the time delay for complete zero auto correlated noise.
    end
end
if sorted
    save([exp_folder,'\Analyzed_data\sort\',filename,'.mat'],'MI_widths', 'MI_peaks', 'peak_times', 'channel_anticipation_power');
else
    save([exp_folder,'\Analyzed_data\unsort\',filename,'.mat'],'MI_widths', 'MI_peaks', 'peak_times', 'channel_anticipation_power');
end