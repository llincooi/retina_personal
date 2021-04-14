exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0708';
cd(exp_folder)
load(['Analyzed_data\unsort\0224_cSTA_wf_3min_Q100.mat'])
load('Analyzed_data\30Hz_27_RF\unsort\STK.mat')
load('rr.mat')

figure('units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);
for channelnumber=1:60
    axes(ha(rr(channelnumber)));
    plot(time,cSTA(channelnumber,:),'LineWidth',2,'LineStyle','-');hold on;
    xlim([-500, 0])
%     plot((0:length(SVD_TK(1,:))-1)*-1000/30,SVD_TK(channelnumber,:)/min(SVD_TK(channelnumber,:))*min(cSTA(channelnumber,:)),'LineWidth',2,'LineStyle','-');hold on;
    plot((0:length(SVD_TK(1,:))-1)*-1000/30,SVD_TK(channelnumber,:),'LineWidth',2,'LineStyle','-');hold on;
    grid on
    title(channelnumber)
end

% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% fig = gcf;
% fig.PaperPositionMode = 'auto';
% saveas(fig,[exp_folder,'\FIG\cSTA\unsort\cSTA_SVDTKernel.tiff'])

