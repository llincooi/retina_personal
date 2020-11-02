clear all
close all
% load('D:\GoogleDrive\retina\Exps\2020\0503\merge\merge_0224_OUsmooth_RL_G4.5_5min_Q100_6.5mW_1Hz_re.mat')
for Fc = [2]
load(['D:\GoogleDrive\retina\Chou''s data\20200408\20200408_OU_cutoff=',num2str(Fc),'_sort_unit2.mat'])
dt = 0.01;
sampling_rate = 20000;
% put your stimulus here!!
TheStimuli = zeros(2, ceil((TimeStamps(2)-TimeStamps(1))/dt));
TheStimuli(1,:) = a_data(1,TimeStamps(1)*sampling_rate:sampling_rate*dt:TimeStamps(2)*sampling_rate);
TheStimuli(2,:) = finite_diff(TheStimuli(1,:) ,4);
TheStimuli(1,:) = (TheStimuli(1,:) - mean(TheStimuli(1,:)))/std(TheStimuli(1,:));
TheStimuli(2,:) = (TheStimuli(2,:) - mean(TheStimuli(2,:)))/std(TheStimuli(2,:));
% Rotate = [cos(pi/4), -sin(pi/4);cos(pi/4), sin(pi/4)];
% TheStimuli = Rotate*TheStimuli;
BinningInterval = dt
forward = -1;
backward = 1;
forward = round(forward/BinningInterval);
backward = round(backward/BinningInterval);
time=[forward:backward]*BinningInterval;
% Binning
bin = BinningInterval*10^3; %ms
BinningTime = 0:dt:TimeStamps(2)-TimeStamps(1);

%% BinningSpike and calculate STA
BinningSpike = zeros(60,length(BinningTime));
analyze_spikes = Spikes;


sum_n = zeros(1,60);
dis_STA = zeros(60,backward-forward+1);
dis_dSTA = zeros(60,backward-forward+1);
channelnumber = 53;
for i = channelnumber%:60  % i is the channel number
%     [n,~] = hist(analyze_spikes{i}(idxs{i}==2),BinningTime) ;
    [n,~] = hist(analyze_spikes{i},BinningTime) ;
    BinningSpike(i,:) = n;
    sum_n(i) = sum(BinningSpike(i,1-forward:end-backward));
    for time_shift = 1-forward:length(BinningTime)-backward
        dis_STA(i,:) = dis_STA(i,:) + BinningSpike(i,time_shift)*TheStimuli(1,time_shift+forward:time_shift+backward);
        dis_dSTA(i,:) = dis_dSTA(i,:) + BinningSpike(i,time_shift)*TheStimuli(2,time_shift+forward:time_shift+backward);
    end
    if sum_n(i)
        dis_STA(i,:) = dis_STA(i,:)/sum_n(i);
        dis_dSTA(i,:) = dis_dSTA(i,:)/sum_n(i);
    end
%     Syn = smooth(joint_Mutual_infos{i}-pos_Mutual_infos{i}-v_Mutual_infos{i}+Redun_Mutual_infos{i},5);
%     Syn = smooth(Redun_Mutual_infos{i},5);
% %     Syn = smooth(joint_Mutual_infos{i},5);
%     Pos = smooth(pos_Mutual_infos{i},5);
%     V = smooth(v_Mutual_infos{i},5);
%     Syn_peaktime = MI_time(find(Syn==max(Syn)))*10^-3;
%     Pos_peaktime = MI_time(find(Pos==max(Pos)))*10^-3;
%     V_peaktime = MI_time(find(V==max(V)))*10^-3;
end
figure(100)
plot3(dis_STA(channelnumber,:),dis_dSTA(channelnumber,:),time);grid on; hold on;
scatter3(dis_STA(channelnumber,[31 61 91]), dis_dSTA(channelnumber,[31 61 91]) ,time([31 61 91]));


% xcenter = (max(dis_STA(channelnumber,:))+min(dis_STA(channelnumber,:)))/2;
% vcenter = 0;
% scatter3(xcenter, vcenter, 0)
% xaxislength = (max(dis_STA(channelnumber,:))-min(dis_STA(channelnumber,:)))/2;
% vaxislength = (max(smooth(dSTA(channelnumber,:),3))-vcenter);
% 1/(Syn_peakpos-xcenter)*xaxislength*(Syn_peakv-vcenter)/vaxislength
end


sum_n = zeros(1,60);
peaktimes = [-0.2 -0.18 0.18 1];
peaktimes_names = ["VPeakTime", "JointPeakTime", "PosPeakTime", "ends"];
numfig = length(peaktimes)
phase_STD = cell(numfig,60); %spike-trigger-distribuion
num_shift = BinningInterval;

for k = channelnumber
%     TheSpikes = analyze_spikes{k}(idxs{k}==1)
    TheSpikes = analyze_spikes{k}
    TheSpikes(TheSpikes<1) = []; %remove all feild on effect
    if length(TheSpikes)/ (length(TheStimuli)*BinningInterval) >1
        for i =  1:numfig %for -250ms:250ms
            for j = 1:length(TheSpikes)
                spike_time = TheSpikes(j); %s
                RF_frame = floor((spike_time + peaktimes(i))*60);
                if RF_frame > 0 && RF_frame < length(TheStimuli)
                    phace_pt = TheStimuli(: , RF_frame);
                    phase_STD{i,k} = [phase_STD{i,k} phace_pt];
                end
            end
        end
    else
        channelnumber(channelnumber==k) = [];
    end
end

x = -2.5:0.625:2.5;
y = -2.5:0.625:2.5;
N_st = hist3(TheStimuli' ,'Ctrs',{x  y})';

for k =channelnumber
    for i = 1:numfig
        figure(i);
        %     x = linspace(min(TheStimuli(1,:)), max(TheStimuli(1,:)), 10);
        %     y = linspace(min(TheStimuli(2,:)), max(TheStimuli(2,:)), 10);
        N = hist3(phase_STD{i,k}','Ctrs',{x y})';
        Mm = contourf(x, y, N_st/sum(N_st,  'all'), 4);
        mmm  = Mm2mmm(Mm, Mm(1,1), Mm(2,1)+2);
        contourf(x, y, N/sum(N,  'all'), mmm, 'LineColor','none'); hold on;
        colormap  winter;
        caxis([min(N_st/ sum(N_st,  'all'), [], 'all') max(N_st/ sum(N_st,  'all'), [], 'all')]);
        colorbar;
        contour(x, y, N_st/ sum(N_st,  'all'), 4, 'Color', 'k');
        scatter(mean(phase_STD{i,k}(1,:)), mean(phase_STD{i,k}(2,:)), 'filled', 'r')
        mean(phase_STD{i,k}(1,:))
        mean(phase_STD{i,k}(2,:))
        title([ 'ch.',  num2str(k), ', ',convertStringsToChars(peaktimes_names(i)),'=', num2str(round(peaktimes(i)*10^3)),'ms']);
        axis square
        grid on
        %if ~isempty(find(frame_to_save == frame))
        %mkdir(['ch.',  num2str(k)])
        set(gca,'fontsize',12); hold on
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        fig =gcf;
        fig.PaperPositionMode = 'auto';
        fig.InvertHardcopy = 'off';
%         if sorted
%             saveas(fig,[exp_folder,'/FIG/phasediagram/sort/',name(12:end),'_ch.',  num2str(k), '_',  num2str( -round((backward+1-frame)*num_shift*1000)),'ms', '.tif'])
%         else
%             saveas(fig,[exp_folder,'/FIG/phasediagram/unsort/',name(12:end),'_ch.',  num2str(k), '_',  num2str( -round((backward+1-frame)*num_shift*1000)),'ms', '.tif'])
%         end
        %close(gcf)
        hold off;
    end
end

%% Function for histogram plotting
function mmm = Mm2mmm(Mm, mmm, x)
    if x > length(Mm)
        return
    end
    mmm = [mmm Mm(1,x)] ;
    x = Mm(2, x)+x+1;
    mmm =  Mm2mmm(Mm, mmm, x);
end