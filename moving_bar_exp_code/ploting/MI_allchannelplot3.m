%% This code plot three MI(pos, abs, speed) in same picture
%Position is red
%Speed is blue
%Absolute is black
close all;
clear all;
code_folder = pwd;
exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0708';
cd(exp_folder)
sorted =0;
%Load calculated MI first(Need to run Calculate_MI.m first to get)
if sorted
    cd MI\sort
else
    cd MI\unsort
end
mkdir FIG
XOmb = 1;
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
        
for z =1:n_file
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    if XOmb
        if name(1) == 'p' | name(1) == 'a'  | name(1) == 'w'
            continue
        end
        name = name(2:end)
        type1name = 'pos';
        type2name ='v';
        type3name ='pos&v';
    else
        if name(1) == 'p' | name(1) == 'a' | name(1) == 'v' | name(1:3) == 'wfi' |  name(1:3) == 'wfv'
            continue
        end
        name = name(3:end)
        type1name = 'wf';
        type2name ='wfv';
        type3name ='wfi&v';
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load([type2name,name,ext])
    speed_MI = Mutual_infos;
    speed_MI_shuffle = Mutual_shuffle_infos;
    load([type3name,name,ext])
    absolute_MI = Mutual_infos;
    absolute_MI_shuffle = Mutual_shuffle_infos;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    load([type1name,name,ext])
    figure('units','normalized','outerposition',[0 0 1 1])
    ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
    MI_peak=zeros(1,60);
    ind_peak=zeros(1,60);
    peak_times = zeros(1,60)-1000000;
    P_channel = [];
    N_channel = [];
    
    for channelnumber=1:60
        if max(speed_MI{channelnumber}-mean(speed_MI_shuffle{channelnumber}))<0.1 && max(Mutual_infos{channelnumber}-mean(Mutual_shuffle_infos{channelnumber}))<0.1
            continue;
        end
        Mutual_infos{channelnumber} = smooth(Mutual_infos{channelnumber});
        [MI_peak(channelnumber), ind_peak(channelnumber)] = max(Mutual_infos{channelnumber}); % MI_peak{number of data}{number of channel}
        if (time(ind_peak(channelnumber)) < -1000) || (time(ind_peak(channelnumber)) > 1000) % the 100 points, timeshift is 1000
            MI_peak(channelnumber) = NaN;
            ind_peak(channelnumber) = NaN;
        end
    % ======= exclude the MI that is too small ===========
        
       
       
        pks_1d=ind_peak(channelnumber);
        peaks_ind=pks_1d(~isnan(pks_1d));
        peaks_time = time(peaks_ind); 
        % ============ find predictive cell=============

        
       
        if peaks_time>=0
            P_channel=[P_channel channelnumber];
        elseif peaks_time<0
             N_channel=[N_channel channelnumber];
        end
        if length(peaks_time)>0
            peak_times(channelnumber) = peaks_time;
        end
        axes(ha(rr(channelnumber))); 
        if size(Mutual_infos{channelnumber},2) ~= size(speed_MI{channelnumber},2)
            Mutual_infos{channelnumber} =Mutual_infos{channelnumber}';
        end
        
        plot(time,(Mutual_infos{channelnumber}-mean(Mutual_shuffle_infos{channelnumber})),'r');hold on;
        plot(time,(speed_MI{channelnumber}-mean(speed_MI_shuffle{channelnumber})),'b-');
        plot(time,(speed_MI{channelnumber}-mean(speed_MI_shuffle{channelnumber})+Mutual_infos{channelnumber}-mean(Mutual_shuffle_infos{channelnumber})),'m.');
        if sum(absolute_MI{channelnumber}) ~= 0
            plot(time,(absolute_MI{channelnumber}-mean(absolute_MI_shuffle{channelnumber})),'k.');
        end
        
%         plot(time,smooth(Mutual_infos{channelnumber}),'r');hold on;
%         plot(time,smooth(speed_MI{channelnumber}),'b-');
%         plot(time,smooth(speed_MI{channelnumber}+Mutual_infos{channelnumber}),'m.');
%         if sum(absolute_MI{channelnumber}) ~= 0
%             plot(time,smooth(absolute_MI{channelnumber}),'k.');
%         end
        
        
        hold off;
         if ismember(channelnumber,P_channel)
            set(gca,'Color',[0.8 1 0.8])
        elseif ismember(channelnumber,N_channel)
            set(gca,'Color',[0.8 0.8 1])
         else
         end    
        grid on
        xlim([ -500 500])
        ylim([0 inf+0.1])
        title(channelnumber)

    end
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    fig =gcf;
    fig.PaperPositionMode = 'auto';
    fig.InvertHardcopy = 'off';
    saveas(fig,['FIG\three_mix',name,'.tif'])
    close(fig)
    %saveas(fig,['FIG\three_mix',name,'.fig'])

end


