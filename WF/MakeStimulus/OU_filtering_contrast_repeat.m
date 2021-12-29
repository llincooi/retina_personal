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
at = 60;
a2=[];ey=[];ey1=[];
saving=1;

while true
    delay_compensate = int16(0/dt);
    L = zeros(1,length(T)+delay_compensate);
    for i = 1:length(T)-1
        L(i+1) = L(i) + (-L(i)/tau + randn*sqrt(D/dt))*dt;
    end

    cutoff=1;
    corrtimef=[];

    [b,a]=butter(2,2*cutoff*dt,'low');
    Lf=filtfilt(b,a,L);
    if abs(mean(Lf))<0.01 && abs(Lf(1))<0.01 && abs(Lf(end))<0.01, break, end
end
plot(Lf);hold on
Lf = (Lf-mean(Lf))/std(Lf);
plot(Lf);
sti = repmat([zeros(1,int16(Trest/dt)),Lf], 1, trial);
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
            save([path,'repeat_OU_tau=',num2str(tau*1000),'ms_cutoff=1_mean=',num2str(mean),'_C=',num2str(C_set(j)),'.mat'],'ey','a2','t')
        end
    end
end