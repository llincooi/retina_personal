clear
close all

Tot = 300;  
dt = 0.01; 
T = dt:dt:Tot;
tau=0.5;
D =4; % dynamical range
at = 60;
a2=[];ey=[];ey1=[];
saving=1;

L = zeros(1,length(T));
for i = 1:length(T)-1
    L(i+1) = L(i) + (-L(i)/tau + randn*sqrt(D/dt))*dt;
end


path='\\ZebraNas\Public\Retina\WF_stimuli\211029\';
figure(1);plot(T,L,'linewidth',1);xlabel('time (s)')
cutoff=1;
corrtimef=[];

[b,a]=butter(2,2*cutoff*dt,'low');
Lf=filter(b,a,L);

[val,lags] =xcorr(L,Lf,1000);
[M,I]=max(val);
% figure(1);plot(lags,val)
Lfshift=Lf(-lags(I)+1:end);

figure(1);hold on
plot(T(1:end+lags(I)),Lfshift,'linewidth',1)

legend(('OU'),('LPOU f_c=1Hz'))
%% generate stimulus
mean_set=[1 4 7 10 13];
C_set=[0.05,0.1,0.2,0.3];

figure(4);hold on;
[t,ey,a2]=generate_stimulus(L,10,2,dt,24);  % (signal, mean intensity, times of std)
plot(t,ey,'linewidth',1);
if saving
    save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=0_mean=10_amp=2.mat'],'ey','a2','t')
end
% [t,ey,a2]=generate_stimulus(Lfshift,10,2,dt);  % (signal, mean intensity, times of std)
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
        [t,ey,a2]=generate_stimulus(Lfshift,mean,amp,dt,24);
        plot(t,ey)
        if saving
            save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=1_mean=',num2str(mean),'_C=',num2str(C_set(j)),'.mat'],'ey','a2','t')
        end
    end
end


%% different mean same contrast
% figure(78);hold on
% inten_coeff=[1.3,0.6,0.2];
% for i=1:3
%     [t,ey,a2]=generate_stimulus(Lfshift,10,2,dt);
%     ey=inten_coeff(i)*ey;
% %     plot(t,ey)
%     if saving
%        save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=1_coeff=',num2str(inten_coeff(i)),'.mat'],'ey','a2','t')
%     end
% end

%% different amplitude same mean
% figure(87);hold on
% % mean_inten_set=[15,10,5];
% amp_set=[0.5,1,1.5,3];
% for i=1:length(amp_set)
%     mean=10;
%     amp=amp_set(i);
%     [t,ey,a2]=generate_stimulus(Lfshift,mean,amp,dt);
% %     plot(t,ey)
%     if saving
%       save([path,'OU_tau=',num2str(tau*1000),'ms_cutoff=1_mean=',num2str(mean),'_amp=',num2str(amp),'.mat'],'ey','a2','t')
%     end
% end


