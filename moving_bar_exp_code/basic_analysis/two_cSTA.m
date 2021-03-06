clear all
close all
exp_folder = 'D:\GoogleDrive\retina\Chou''s data\20210504';
cd(exp_folder)
load('rr.mat')

load(['Analyzed_data\unsort\0224_cSTA_wf_3min_Q100.mat'])
figure('units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
for channelnumber=1:60
    axes(ha(rr(channelnumber)));
    ncSTA = cSTA(channelnumber,:)/-min(cSTA(channelnumber,:));
    plot(time,ncSTA,'LineWidth',2,'LineStyle','-');hold on;
    xlim([-500, 0])
    grid on
    title(channelnumber)
end

load('Analyzed_data\30Hz_27_RF_15min_re\unsort\STK.mat')
for channelnumber=1:60
    axes(ha(rr(channelnumber)));
    T = (0:size(SVD_TK,2)-1)*-1000/30;
    nSVD_TK = SVD_TK(channelnumber,:)/-min(SVD_TK(channelnumber,:));
    plot(T,nSVD_TK, 'LineWidth',2,'LineStyle','-');hold on;
    xlim([-500, 0])
    grid on
    title(channelnumber)
end


set(gcf,'units','normalized','outerposition',[0 0 1 1])
fig = gcf;
fig.PaperPositionMode = 'auto';
saveas(fig,[exp_folder,'\FIG\cSTA\unsort\cSTA_30SVDTKernel_re.tiff'])

