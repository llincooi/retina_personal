close all;
clear all;
code_folder = pwd;
exp_folder ='D:\GoogleDrive\retina\Exps\2020\0729';
sorted =0;
cd(exp_folder)
load('Analyzed_data\Gs_Sets')
if sorted
    cd MI\sort
else
    cd MI\unsort
end
load('rr.mat')

for setnum = 1:length(Gs_Sets)
TheFileNames = ChooseWantedfile(Gs_Sets{setnum}.Including, Gs_Sets{setnum}.Excluding);
Files = cell(1, size(TheFileNames, 2)); 
Gs = [];
for i = 1: size(TheFileNames, 2)
    filename = convertStringsToChars(TheFileNames(i));
    istart = strfind(filename,'G');
    iend = strfind(filename(istart:end),'_');
    Gs = [Gs str2num(filename(istart+1:istart+iend(1)-2))];
    Files{i} = load(filename);
end
[Gs I] = sort(Gs);
SortedFileNames = TheFileNames(I);
Files = Files(I);

allchannellegend = cell(1, size(TheFileNames, 2)); 
MI_peaks = [];
t_corr_serie = [];
peak_times = [];
for i =1:length(Gs)
    allchannellegend{i} = ['t_{corr}:', num2str(Files{i}.corr_time)];
    MI_peaks = [MI_peaks; Files{i}.MI_peak];
    t_corr_serie = [t_corr_serie Files{i}.corr_time];
    peak_times = [peak_times; Files{i}.peak_time];
end
%% plot ALL ch.
figure('IntegerHandle', 'off', 'units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);

channel_anticipation_power = zeros(2,60);
for channelnumber=1:60 %choose file
    axes(ha(rr(channelnumber)));
    for  i =1:length(Gs)
        baseinfo = min(Files{i}.Redun_Mutual_infos{channelnumber});
        mutual_information = Files{i}.pos_Mutual_infos{channelnumber};
        if channelnumber == 4
            plot( Files{i}.time,mutual_information-baseinfo); hold on; %,'color',cc(z,:));hold on
            xlim([ -1500 2000])
            ylim([0 100])
            lgd =legend(allchannellegend,'Location','north');
            lgd.FontSize = 6;
            legend('boxoff')
        elseif max(mutual_information-baseinfo)<0.1
                continue;
        else
            plot(Files{i}.time,mutual_information-baseinfo); hold on; %,'color',cc(z,:));hold on
            grid on;
            xlim([ -1500 1300])
            ylim([0 inf+0.1])
            title(channelnumber);
        end
    end
    hold off;
    saveas(gcf,['FIG\',Gs_Sets{setnum}.fig_name,'.tif'])
end
end
% displychannel = find(sum(isnan(MI_peaks)) == 0);
% %% Chose by hand and plot single channels
% for channelnumber = displychannel%
%     figure(channelnumber)
%     for  i =1:length(Gs)
%         mutual_information = Files{i}.pos_Mutual_infos{channelnumber};hold on;
%         baseinfo = min(Files{i}.Redun_Mutual_infos{channelnumber});
%         plot(Files{i}.time,smooth(mutual_information- baseinfo ),'LineWidth',1.5,'LineStyle','-');
%         xlim([-2300 1300])
%         ylim([0 inf+0.1])
%     end
% %     for   G =1:length(OU_different_G)
% %         baseinfo = OU_baselines(G,channelnumber);
% %         mutual_information = cell2mat(OU_MI (G,channelnumber));hold on;
% %         plot(time_serie{G+length(HMM_different_G)},smooth(mutual_information - baseinfo ),'LineWidth',1.5,'LineStyle',':');
% %         xlim([ -1300 1300])
% %         ylim([0 inf+0.1])
% %     end
%     title(channelnumber);
%     xlabel('\deltat (ms)');ylabel('MI (bits/second)');
%     set(gca,'fontsize',12 ); hold on
%     lgd =legend(allchannellegend,'Location','northwest');
%     lgd.FontSize = 11;
%     legend('boxoff')
%     grid on
%     hold off;
%     %
%     figure(channelnumber+100)
%     plot(t_corr_serie,peak_times(:,channelnumber ),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
%     xlabel('t_{corr} (ms)');ylabel('t_{shift} (ms)');
%     title(channelnumber);
%     set(gca,'fontsize',12 );
% %     %
% %     figure(channelnumber+200)
% %     plot(t_corr_serie,MI_peaks(:,channelnumber ),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
% %     xlabel('t_c_o_r_r (ms)');ylabel('MI peak (bits/second)');
% %     title(channelnumber);
% %     set(gca,'fontsize',12 );
% %     %
% %     figure(channelnumber+300)
% %     plot(t_corr_serie,MI_widths(:, channelnumber),'-o','MarkerIndices',1:length(t_corr_serie),'LineWidth',1.5)
% %     xlabel('t_c_o_r_r (ms)');ylabel('MI width (time)');
% %     title(channelnumber);
% %     set(gca,'fontsize',12 );
% end

%% Calculate MI_properties
% channel_anticipation_power(:,find(sum(isnan(MI_peaks)) > 0)) = NaN;
% %channel_anticipation_power(1,:): 
% %     NaN -> useless cell
% %     0   -> NP cell
% %     >0  -> P cell
% %     <0  -> Odd cell
% for channelnumber = displychannel
%     if mean(peak_times(:, channelnumber)) < 0 % NP cell (all t_shift < 0)
%         if std(peak_times(:, channelnumber)) > 50 % exclude Odd cell
%             channel_anticipation_power(1,channelnumber) = -1; 
%         end
%         channel_anticipation_power(2,channelnumber) = mean(peak_times(:, channelnumber)); %delay time
%     else % P cell
%         f = fit(t_corr_serie',peak_times(:,channelnumber ),'poly1'); %fit a line
%         channel_anticipation_power(1,channelnumber) = atan(f.p1/1000); % define the anticipation power to be the angle. (angle> 0) % exclude Odd cell here
%         channel_anticipation_power(2,channelnumber) = f.p2; % the time delay for complete zero auto correlated noise.
%     end
% end
% if sorted
%     save([exp_folder,'\Analyzed_data\sort\',filename,'.mat'],'MI_widths', 'MI_peaks', 'peak_times', 'channel_anticipation_power');
% else
%     save([exp_folder,'\Analyzed_data\unsort\',filename,'.mat'],'MI_widths', 'MI_peaks', 'peak_times', 'channel_anticipation_power');
% end
