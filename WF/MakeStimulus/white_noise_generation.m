% white noise stimulus
clear
close all
savepath='\\ZebraNas\Public\Retina\WF_stimuli\211029';
Tot=300;
dt=0.05;
x_rand=randn(1,Tot/dt);
%% different mean different contrast 20211029
mean_set=[1 4 7 10 13];
C_set=[0.05,0.1,0.2,0.3];

for i=1:length(mean_set)
    figure(i);hold on
    for j=1:length(C_set)
        mean=mean_set(i);
        amp=mean*C_set(j);
        [t,ey,a2]=generate_stimulus(x_rand,mean,amp,dt,24);
        plot(t,ey)
        save([savepath,'\WhiteNoise_mean=',num2str(mean),'_C=',num2str(C_set(j)),'.mat'],'t','ey','a2')
    end
end

%% 
% amp_set=[0.5,1,1.5,2,3];
% for i = 1%:length(amp_set)
%     mean=10;
%     amp=2 %amp_set(i);
%     [t,inten,a2]=generate_stimulus(x_rand,mean,amp,dt);
% %     save([savepath,'\WhiteNoise_mean=',num2str(mean),'_amp=',num2str(amp),'.mat'],'t','inten','a2')
%     plot(t,inten,'linewidth',1);hold on
% end

% title('White noise stimulus')
% xlabel('time (s)')
% ylabel('light intensity (mW/m^2)')
% set(gcf,'Position',[300,300,600,300])
% xlim([100,104])