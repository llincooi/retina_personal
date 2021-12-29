clear
close all

path='\\ZebraNas\Public\Retina\WF_stimuli\211217\';

Tot = 300;
dt = 0.01; 
T = dt:dt:Tot;
tau=0.5;
D = 1; % dynamical range
at = 60;
a2=[];ey=[];ey1=[];
saving=1;

L = zeros(1,length(T));
for i = 1:length(T)-1
    L(i+1) = L(i) + (-L(i)/tau + randn*sqrt(D/dt))*dt;
end

cutoff=1;
corrtimef=[];

[b,a]=butter(2,2*cutoff*dt,'low');
Lf=filtfilt(b,a,L);

figure(1);plot(T,L,'linewidth',1);xlabel('time (s)');hold on;
plot(T,Lf,'linewidth',1)
legend(('OU'),('LPOU f_c=1Hz'))
%% generate stimulus
mean_set=[4 7 10 13];
C_set=[0.1,0.15,0.2,0.3];

figure(4);hold on;
[t,ey,a2]=generate_stimulus(L,10,2,dt,24);  % (signal, mean intensity, times of std)
plot(t,ey,'linewidth',1);
if saving
    save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=0_mean=10_amp=2.mat'],'ey','a2','t')
end
% [t,ey,a2]=generate_stimulus(Lf,10,2,dt);  % (signal, mean intensity, times of std)
% plot(t,ey,'linewidth',1);
% if saving
%     save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=1_mean10_amp2.mat'],'ey','a2','t')
% end

%% different mean and different contrast 20211008

for i=1:length(mean_set)
    figure(i*878);hold on
    for j=1:length(C_set)
        mean=mean_set(i);
        amp=mean*C_set(j);
        [t,ey,a2]=generate_stimulus(Lf,mean,amp,dt,24);
        plot(t,ey)
        if saving
            save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=1_mean=',num2str(mean),'_C=',num2str(C_set(j)),'.mat'],'ey','a2','t')
        end
    end
end
%%
figure
for cutoff=[2,4]
    [b,a]=butter(2,2*cutoff*dt,'low');
    Lf = filtfilt(b,a,L);
    mean=10;
    amp=10*0.2;
    [t,ey,a2]=generate_stimulus(Lf,mean,amp,dt,24);
    plot(t,ey)
    if saving
        save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=',num2str(cutoff),'_mean=10_C=0.2.mat'],'ey','a2','t')
    end
end



