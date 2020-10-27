clear all
close all
% load('D:\GoogleDrive\retina\Exps\2020\0503\merge\merge_0224_OUsmooth_RL_G4.5_5min_Q100_6.5mW_1Hz_re.mat')
for Fc = [2]
load(['D:\GoogleDrive\retina\Exps\2020\0729\merge\merge_0727_OUsmooth_Bright_UL_DR_G4.5_5min_Q100_6.5mW_',num2str(Fc),'Hz.mat'])
load(['D:\GoogleDrive\retina\Exps\2020\0729\MI\unsort\0727_OUsmooth_Bright_UL_DR_G4.5_5min_Q100_6.5mW_',num2str(Fc),'Hz.mat'])
MI_time = time;
% put your stimulus here!!
TheStimuli=bin_pos;  %recalculated bar position
TheStimuli(1,:) = (TheStimuli(1,:) - mean(TheStimuli(1,:)))/std(TheStimuli(1,:));
forward = -1;
backward = 1;
forward = round(forward/BinningInterval);
backward = round(backward/BinningInterval);
time=[forward:backward]*BinningInterval;
% Binning
bin=BinningInterval*10^3; %ms
BinningTime =diode_BT;

%% BinningSpike and calculate STA
BinningSpike = zeros(60,length(BinningTime));
analyze_spikes = cell(1,60);
analyze_spikes = reconstruct_spikes;

sum_n = zeros(1,60);
dis_STA = zeros(60,backward-forward+1);
channelnumber = 52;
for i = channelnumber%:60  % i is the channel number
    [n,~] = hist(analyze_spikes{i},BinningTime) ;
    BinningSpike(i,:) = n ;
    sum_n(i) = sum(BinningSpike(i,1-forward:end-backward));
    for time_shift = 1-forward:length(BinningTime)-backward
        dis_STA(i,:) = dis_STA(i,:) + BinningSpike(i,time_shift)*TheStimuli(time_shift+forward:time_shift+backward);
    end
    if sum_n(i)
        dis_STA(i,:) = dis_STA(i,:)/sum_n(i);
    end
    
    Syn = smooth(joint_Mutual_infos{i}-pos_Mutual_infos{i}-v_Mutual_infos{i}+Redun_Mutual_infos{i},10);
    Syn = smooth(joint_Mutual_infos{i},5);
    Pos = smooth(pos_Mutual_infos{i},5);
    V = smooth(v_Mutual_infos{i},5);
    Syn_peaktime = MI_time(find(Syn==max(Syn)))*10^-3;
    Pos_peaktime = MI_time(find(Pos==max(Pos)))*10^-3;
    V_peaktime = MI_time(find(V==max(V)))*10^-3;
end
figure(101); hold on;
plot(MI_time,Syn)
plot(MI_time,V)
plot(MI_time,Pos)
grid on;
xlim([-1000,1000])
figure(100)
dSTA = diff(dis_STA,1,2)/BinningInterval;
plot3(dis_STA(channelnumber,2:end),dSTA(channelnumber,:),time(2:end));grid on; hold on;
scatter3(dis_STA(channelnumber,[31 61 91]), dSTA(channelnumber,[30 60 90]) ,time([31 61 91]));
Syn_peakpos = interp1(time,dis_STA(channelnumber,:),Syn_peaktime);
Syn_peakv = interp1(time(2:end),dSTA(channelnumber,:),Syn_peaktime);
scatter3(Syn_peakpos, Syn_peakv, Syn_peaktime)

% xcenter = (max(dis_STA(channelnumber,:))+min(dis_STA(channelnumber,:)))/2;
% vcenter = 0;
% scatter3(xcenter, vcenter, 0)
% xaxislength = (max(dis_STA(channelnumber,:))-min(dis_STA(channelnumber,:)))/2;
% vaxislength = (max(smooth(dSTA(channelnumber,:),3))-vcenter);
% 1/(Syn_peakpos-xcenter)*xaxislength*(Syn_peakv-vcenter)/vaxislength
end

TheStimuli = zeros(2, length(bin_pos));
TheStimuli(1,:)=bin_pos;
TheStimuli(1,:) = (TheStimuli(1,:) - mean(TheStimuli(1,:)))/std(TheStimuli(1,:));
TheStimuli(2,:) = finite_diff(TheStimuli(1,:) ,4);
TheStimuli(2,:) = (TheStimuli(2,:) - mean(TheStimuli(2,:)))/std(TheStimuli(2,:));
sum_n = zeros(1,60);
peaktimes = [V_peaktime Syn_peaktime Pos_peaktime, MI_time(1)*10^-3, MI_time(end)*10^-3];
peaktimes_names = ["VPeakTime", "JointPeakTime", "PosPeakTime", "ends", "end"];
numfig = length(peaktimes)
phase_STD = cell(numfig,60); %spike-trigger-distribuion
num_shift = BinningInterval;

for k = channelnumber
    analyze_spikes{k}(analyze_spikes{k}<1) = []; %remove all feild on effect
    if length(analyze_spikes{k})/ (length(TheStimuli)*BinningInterval) >1
        for i =  1:numfig %for -250ms:250ms
            for j = 1:length(analyze_spikes{k})
                spike_time = analyze_spikes{k}(j); %s
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