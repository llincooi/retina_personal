clear
close all

path='\\ZebraNas\Public\Retina\WF_stimuli\211118\';

Tsti = 5;
Trest = 2;
trial = 85;
dt = 0.01; 
T = dt:dt:Tsti;
tau=0.5;
D = 1; % dynamical range
% at = 60;
% a2=[];ey=[];ey1=[];
saving=1;

while true
    L = randn(1,length(T));
    if abs(mean(L))<0.01, break, end
end
plot(L);
L = (L-mean(L))/std(L);
sti = repmat([zeros(1,int16(Trest/dt)),L], 1, trial);
plot(sti);
%% different mean and different contrast 20211008
mean_set=[1 4 7 10 13];
C_set=[0.05,0.1,0.2,0.3];

for i=1:length(mean_set)
    figure(i*878);hold on
    for j=1:length(C_set)
        mean=mean_set(i);
        amp=mean*C_set(j);
        [t,ey,a2]=generate_stimulus(sti,mean,amp,dt,24);
        plot(t,ey)
        if saving
            save([path,'repeat_WhiteNoise_mean=',num2str(mean),'_C=',num2str(C_set(j)),'.mat'],'ey','a2','t')
        end
    end
end