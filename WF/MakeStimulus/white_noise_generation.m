% white noise stimulus
clear
close all
savepath = '\\ZebraNas\Public\Retina\WF_stimuli\211217';
Tot = 300;
dt = 0.05; % 20Hz
x_rand = randn(1,Tot/dt);
%% different mean different contrast 20211029
mean_set = [4 7 10 13];
C_set = [0.1,0.15,0.2,0.3];
for i=1:length(mean_set)
    figure(i);hold on
    for j=1:length(C_set)
        mean=mean_set(i);
        amp=mean*C_set(j);
        [t,ey,a2] = generate_stimulus(x_rand,mean,amp,dt,24);
        plot(a2)
%         save([savepath,'\WhiteNoise_mean=',num2str(mean),'_C=',num2str(C_set(j)),'.mat'],'t','ey','a2')
    end
end