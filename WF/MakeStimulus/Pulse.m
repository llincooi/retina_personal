clear
close all

path='\\ZebraNas\Public\Retina\WF_stimuli\211125\';

Tot = 300;
dt = 0.01; 
T = dt:dt:Tot;
tau=1;
D = 1; % dynamical range
at = 60;
a2=[];ey=[];ey1=[];
saving=1;

L = zeros(1,length(T));
for i = 1:length(T)-1
    L(i+1) = L(i) + (-L(i)/tau + randn*sqrt(D/dt))*dt;
end

cutoff=1;

[b,a]=butter(2,2*cutoff*dt,'low');
Lf=filtfilt(b,a,L);

figure(1);plot(T,L,'linewidth',1);xlabel('time (s)');hold on;
plot(T,Lf,'linewidth',1)
legend(('OU'),('LPOU f_c=1Hz'))

% save([path,'original_LPOU_1s1Hz.mat'],'Lf')
%% AM
meanIPI = 0.2; %s
pulseLen = 0.05;

meanInten = 10;
Contrast = 0.2;
downSampleLf_Inten = (Lf*meanInten*Contrast+meanInten);
downSampleLf_Inten = downSampleLf_Inten(1:meanIPI/dt:length(T));

AMsti = zeros(1,length(T));
for i = 1:length(downSampleLf_Inten)
    AMsti((i-1)*meanIPI/dt+1:((i-1)*meanIPI+pulseLen)/dt) = downSampleLf_Inten(i);
end
AMsti = [AMsti, meanInten*ones(1,pulseLen/dt)];
[t,ey,a2]=generate_pulse_stimulus(AMsti,0,dt);

save([path,'AM_LPOU_1s1Hz_200-50ms_10-2mW.mat'],'ey','a2','t','Lf')
%% DM (duty cycle modulation)
DMsti = zeros(1,length(T));
downSampleLf_Duty = (Lf*pulseLen*Contrast+pulseLen);
downSampleLf_Duty = downSampleLf_Duty(1:meanIPI/dt:length(T));
for i = 1:length(downSampleLf_Duty)
    DMsti((i-1)*meanIPI/dt+1:((i-1)*meanIPI+downSampleLf_Duty(i))/dt) = meanInten;
end
DMsti = [DMsti, meanInten*ones(1,pulseLen/dt)];
[t,ey,a2]=generate_pulse_stimulus(DMsti,0,dt);
save([path,'DM_LPOU_1s1Hz_200-50ms_10-2mW.mat'],'ey','a2','t','Lf')
%% FM
FMsti = zeros(1,length(T));
downSampleLf_IPIshift = (meanInten./downSampleLf_Inten-1)*meanIPI;
for i = 1:length(downSampleLf_Inten)-1
    FMsti( (i*meanIPI+downSampleLf_IPIshift(i))/dt+1 : (i*meanIPI+downSampleLf_IPIshift(i)+pulseLen)/dt ) = meanInten;
end
FMsti = [FMsti, meanInten*ones(1,pulseLen/dt)];
[t,ey,a2]=generate_pulse_stimulus(FMsti,0,dt);
save([path,'FM_LPOU_1s1Hz_200-50ms_10-2mW.mat'],'ey','a2','t','Lf')
%% plots
figure();
plot(AMsti,'linewidth',1);hold on;
plot((Lf*meanInten*Contrast+meanInten),'linewidth',1)
plot(DMsti,'linewidth',1);
plot(FMsti,'linewidth',1);


