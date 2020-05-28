%% This code plot four PI in same picture
%Position is red
%Speed is blue
%synergy is black
%redundancy is green
close all;
clear all;
code_folder = pwd;
exp_folder = 'D:\Leo\0229';
cd(exp_folder)
sorted =0;
if sorted
    cd MI\sort
else
    cd MI\unsort
end
mkdir FIG
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
    figure('units','normalized','outerposition',[0 0 1 1])
    ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
    
    for channelnumber=1:60
        if channelnumber == 4
            axes(ha(rr(channelnumber)));
            plot(time,(pos_Mutual_infos{channelnumber}-Redun_Mutual_infos{channelnumber}),'r');hold on;
            plot(time,(v_Mutual_infos{channelnumber}-Redun_Mutual_infos{channelnumber}),'b-');
            plot(time,(joint_Mutual_infos{channelnumber}-Redun_Mutual_infos{channelnumber}),'k-');
            plot(time,Redun_Mutual_infos{channelnumber},'g-');
            legend('U_x','U_v', 'S', 'R');
        elseif max(v_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))<0.1 && max(pos_Mutual_infos{channelnumber}-min(Redun_Mutual_infos{channelnumber}))<0.1
            continue;
        else
            axes(ha(rr(channelnumber)));
            %         if size(Mutual_infos{channelnumber},2) ~= size(speed_MI{channelnumber},2)
            %             Mutual_infos{channelnumber} =Mutual_infos{channelnumber}';
            %         end
            plot(time,(pos_Mutual_infos{channelnumber}-Redun_Mutual_infos{channelnumber}),'r');hold on;
            plot(time,(v_Mutual_infos{channelnumber}-Redun_Mutual_infos{channelnumber}),'b-');
            plot(time,(joint_Mutual_infos{channelnumber}+Redun_Mutual_infos{channelnumber})-pos_Mutual_infos{channelnumber}-v_Mutual_infos{channelnumber},'k-');
            plot(time,Redun_Mutual_infos{channelnumber},'g-');
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
    saveas(fig,['FIG\PI_',name,'.tif'])
    close(fig)
    %saveas(fig,['FIG\three_mix',name,'.fig'])
    
end


