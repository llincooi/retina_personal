%% This code plot three MI in same picture
%Position is red
%Speed is blue
%jointed is black
%summation is magenta
close all;
clear all;
code_folder = pwd;
exp_folder = 'D:\Leo\0409';     
exp_folder = 'C:\Users\llinc\GitHub\retina_personal\0229';
cd(exp_folder)
sorted = 0;
if sorted
    cd MI\sort
else
    cd MI\unsort
end
mkdir FIG
all_file = dir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ;
%Tina orientation
load('rr');
% P_channel = [32 48];
% N_channel = [7 8 9 15 16 17 23 24 25];
for z =1:n_file
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
    load([name,ext])
    figure('units','normalized','outerposition',[0 0 1 1])
    ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
    
    for channelnumber=1:60
        if channelnumber == 4
            axes(ha(rr(channelnumber)));
            plot(time,(pos_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber})),'r');hold on;
            plot(time,(v_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber})),'b-');
            plot(time,(joint_Mutual_infos{channelnumber}-min(joint_Mutual_infos{channelnumber})),'k-');
            plot(time,(pos_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))+(v_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber})),'m-');
            legend('MI(x,r)','MI(v,r)', 'MI([x,v],r)', 'MI(x,r)+MI(v,r)');
        elseif max(v_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))<0.1 && max(pos_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))<0.1
            continue;
        else
            axes(ha(rr(channelnumber)));
            %         if size(Mutual_infos{channelnumber},2) ~= size(speed_MI{channelnumber},2)
            %             Mutual_infos{channelnumber} =Mutual_infos{channelnumber}';
            %         end
            plot(time,(pos_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber})),'r');hold on;
            plot(time,(v_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber})),'b-');
            plot(time,(joint_Mutual_infos{channelnumber}),'k-');
            plot(time,(pos_Mutual_infos{channelnumber}+(v_Mutual_infos{channelnumber})),'m-');
            hold off;
            %         if ismember(channelnumber,P_channel)
            %             set(gca,'Color',[0.8 1 0.8])
            %         elseif ismember(channelnumber,N_channel)
            %             set(gca,'Color',[0.8 0.8 1])
            %         else
            %         end
            grid on
            xlim([ -1000 1000])
            ylim([0 inf+0.1])
            title(channelnumber)
        end
    end
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    fig =gcf;
    fig.PaperPositionMode = 'auto';
    fig.InvertHardcopy = 'off';
    saveas(fig,['FIG\MI_',name,'.tif'])
    close(fig)
    %saveas(fig,['FIG\three_mix',name,'.fig'])
end


