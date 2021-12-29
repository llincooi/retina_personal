clear
close all

path='\\ZebraNas\Public\Retina\WF_stimuli\211125\';

dt = 0.01; 
meanIPI = 0.2; %s
pulseLen = 0.05; %s
repeat = 25;
rest = 5; %s
Trial = 20;

meanInten=10;
%%  OSR
sti = [];
for t = 1:Trial
    for r = 1:repeat
        sti = [sti, meanInten*ones(1,pulseLen/dt), zeros(1,int16((meanIPI-pulseLen)/dt))];
    end
    sti = [sti, zeros(1,(rest)/dt)];
end
plot(sti);hold on;

[t,ey,a2]=generate_pulse_stimulus(sti,0,dt);
save([path,'OSR_200-50ms_10mW.mat'],'ey','a2','t')
%% OSR jittering
GWN = double(int16(normrnd(0,0.04,1,repeat-3)/dt))*dt;
sti = [];
jitter_record = [];
for t = 1:Trial
    jitter = [0, GWN(randperm(length(GWN))), 0, 0, 0];
    jitter_record = [jitter_record; jitter];
    for r = 1:repeat
        sti = [sti, meanInten*ones(1,pulseLen/dt), zeros(1,int16((meanIPI-pulseLen-jitter(r)+jitter(r+1))/dt))];
    end
    sti = [sti, zeros(1,(rest)/dt)];
end
plot(sti);

[t,ey,a2]=generate_pulse_stimulus(sti,0,dt);
save([path,'OSR_jitter_200-50ms_10mW.mat'],'ey','a2','t','jitter_record')


