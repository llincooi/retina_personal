exp_folder = 'D:\GoogleDrive\retina\Chou''s data\20210331';
cd(exp_folder)
load(['Analyzed_data\unsort\0224_cSTA_wf_3min_Q100.mat'])
load('rr.mat')

figure('units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
for channelnumber=1:60
    axes(ha(rr(channelnumber)));
    plot(time,cSTA(channelnumber,:),'LineWidth',2,'LineStyle','-');hold on;
    xlim([-500, 0])
    grid on
    title(channelnumber)
end
load(['Analyzed_data\unsort\0224_cSTA_wf_3min_Q100_re.mat'])
for channelnumber=1:60
    axes(ha(rr(channelnumber)));
    plot(time,cSTA(channelnumber,:),'LineWidth',2,'LineStyle','-');hold on;
    xlim([-500, 0])
    grid on
    title(channelnumber)
end


% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% fig = gcf;
% fig.PaperPositionMode = 'auto';
% saveas(fig,[exp_folder,'\FIG\cSTA\unsort\cSTA_30SVDTKernel.tiff'])

