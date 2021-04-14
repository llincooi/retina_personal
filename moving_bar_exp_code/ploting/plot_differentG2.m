close all;
clear all;
code_folder = pwd;
exp_folder = 'D:\GoogleDrive\retina\Chou''s data\MB';
cd(exp_folder)
XOwf =0;
XOdark = 0;
direction = 'RL';
sorted =0;
special = 0;
num_peak = 1
if XOwf
    HMM_former_name = '0224_OU_G';
    HMM_post_name = ['_5min_Q100'];
    OU_former_name = '0224_OU_wf_G';
    OU_post_name = ['_5min_Q100'];
    OU_different_G = [3 7.5];
    name = '5G_WF';
    filename = 'WF_5GMI_properties';
elseif XOdark
    HMM_former_name = ['pos_0224_HMM_Dark_',direction, '_G'];
    HMM_post_name = '_5min_Q100_6.5mW_100';
    OU_former_name = ['pos_0224_OU_Dark_', direction, '_G'];
    OU_post_name = '_5min_Q100_6.5mW_100';
    OU_different_G = [3 7.5];
    name = '5G_DB';
    filename = 'DB_5GMI_properties';
else
    HMM_former_name = ['0727_OUsmooth_Bright_',direction, '_G4.5_5min_Q100_6.5mW_'];
    HMM_post_name = 'Hz';
    %     OU_former_name = ['pos_0224_OU_', direction, '_G'];
    %     OU_post_name = '_5min_Q100_6.5mW';
    %     OU_different_G = [3 7.5];
    name = '5Fc_BB';
    filename = 'BB_5FcMI_properties';
end
HMM_different_G = [0.5,1,2,4,8,0];
%Load calculated MI first(Need to run Calculate_MI.m first to get)
if sorted
    cd MI\sort
else
    if special
        cd MI\special
    else
        cd MI\unsort
    end
end

load('rr.mat')

HMM_MI =[];
baselines = [];
allchannellegend = cell(1,length(HMM_different_G));
corr_t_legend = cell(1,length(HMM_different_G));%+length(OU_different_G));
t_corr_serie =[];
time_serie = cell(length(HMM_different_G));%+length(OU_different_G),1);
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


% OU_MI =[];
% OU_MI_shuffle = [];
% for     G =1:length(OU_different_G)
%     load([OU_former_name,num2str(OU_different_G(G)),OU_post_name ,'.mat'])
%
%     OU_MI = [OU_MI;pos_Mutual_infos];
%     OU_MI_shuffle = [OU_MI_shuffle ;pos_Mutual_shuffle_infos];
%     corr_t_legend{G+length(HMM_different_G)} = ['OU-', num2str(corr_time)];
%     time_serie{G+length(HMM_different_G)} = time;
% end
figure('IntegerHandle', 'off', 'units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
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
end
%% find MI peak, peak time and MI width
ind_local_max2 =cell(length(HMM_different_G),60);
MI_peaks = cell(length(HMM_different_G),60);
MI_width = zeros(5,60);
for channelnumber=1:60 %choose file
    for     G =1:length(HMM_different_G)
        mean_MI_shuffle = mean(cell2mat(HMM_MI_shuffle(G,channelnumber)));
        baseline = mean_MI_shuffle + std(cell2mat(HMM_MI_shuffle(G,channelnumber)));
        HMM_MI{G,channelnumber} = smooth(HMM_MI{G,channelnumber});
        MIdiff = diff(HMM_MI{G,channelnumber});
        ind_local_extrema = find(MIdiff(1:end-1).*MIdiff(2:end) < 0)+1; %find all local extrema
        [a I] = sort(HMM_MI{G,channelnumber}(ind_local_extrema), 'descend');
        ind_local_max2{G,channelnumber} = [];
        for i = 1:num_peak %find the biggest two local extrema with deltat in -1~1 sec.
            if (time(ind_local_extrema(I(i))) < -1000) || (time(ind_local_extrema(I(i))) > 1000) ||  max(HMM_MI{G,channelnumber})-baseline < 0.05% the 100 points, timeshift is 1000
            else
                ind_local_max2{G,channelnumber} = [ind_local_max2{G,channelnumber} ind_local_extrema(I(i))]; %factor out biggest 'num_peak' local extrema
            end
        end
        if isempty(ind_local_max2{G,channelnumber})
            MI_peak(G,channelnumber) = NaN;
            ind_peak(G,channelnumber) = NaN;
        else
            ind_local_max2{G,channelnumber} = sort(ind_local_max2{G,channelnumber}, 'descend');
            MI_peaks{G,channelnumber} = HMM_MI{G,channelnumber}(ind_local_max2{G,channelnumber});
            %pick the right one
            ind_peak(G,channelnumber) = ind_local_max2{G,channelnumber}(1);
            peak_times(G,channelnumber) = time(ind_peak(G,channelnumber));
            MI_peak(G,channelnumber) = HMM_MI{G,channelnumber}(ind_peak(G,channelnumber));
        end
        
        %calculate MI_width by seeing MI curve as a Gaussian distribution. So the unit of MI_width would be ms.
        mutual_information = cell2mat(HMM_MI (G,channelnumber));
        mean_MI_distr = 0;
        sq_MI_distr = 0;
        for j = 1:length(mutual_information)
            if mutual_information(j) > baseline
                mean_MI_distr =  mean_MI_distr+j*(mutual_information(j)-baseline)/sum(mutual_information);
                sq_MI_distr =sq_MI_distr+ j^2*(mutual_information(j)-baseline)/sum(mutual_information);
            end
        end
        MI_width(G, channelnumber) =sqrt (sq_MI_distr-mean_MI_distr^2);
    end
end
%% Chose by hand and plot single channels
for channelnumber=1:60%
    if sum(isnan(MI_peak(:,channelnumber))) == 0
        figure(channelnumber)
        for   G =1:length(HMM_different_G)
            mutual_information = cell2mat(HMM_MI (G,channelnumber)) ;hold on;
            mean_MI_shuffle = mean(cell2mat(HMM_MI_shuffle(G,channelnumber)));
            plot(time_serie{G},smooth(mutual_information- mean_MI_shuffle ),'LineWidth',1.5,'LineStyle','-');
            xlim([ -2300 1300])
            ylim([0 inf+0.1])
        end
        %         for   G =1:length(OU_different_G)
        %             mean_MI_shuffle = mean(cell2mat(OU_MI_shuffle(G,channelnumber)));
        %             mutual_information = cell2mat(OU_MI (G,channelnumber));hold on;
        %             plot(time_serie{G+length(HMM_different_G)},smooth(mutual_information - mean_MI_shuffle ),'LineWidth',1.5,'LineStyle',':');
        %             xlim([ -1300 1300])
        %             ylim([0 inf+0.1])
        %         end
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
        %
        figure(channelnumber+200)
        plot(t_corr_serie,MI_peak(:,channelnumber ),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
        xlabel('t_c_o_r_r (ms)');ylabel('MI peak (bits/second)');
        title(channelnumber);
        set(gca,'fontsize',12 );
        %
        figure(channelnumber+300)
        plot(t_corr_serie,MI_width(:, channelnumber),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
        xlabel('t_c_o_r_r (ms)');ylabel('MI width (time)');
        title(channelnumber);
        set(gca,'fontsize',12 );
    end
end

if sorted
    save([exp_folder,'\Analyzed_data\sort\',filename,'.mat'],'MI_width', 'MI_peak', 'peak_times');
else
    save([exp_folder,'\Analyzed_data\unsort\',filename,'.mat'],'MI_width', 'MI_peak', 'peak_times');
end