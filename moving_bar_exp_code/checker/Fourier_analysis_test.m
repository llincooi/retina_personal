%Signal prediction by anticipatory relaxation dynamics, Voss, Henning U.
clear all;
close all;
load('D:\Leo\0229\merge\merge_0224_HMM_wf_G2.5_5min_Q100.mat')
load('D:\Leo\0229\Analyzed_data\unsort\0224_cSTA_wf_3min_Q100.mat')
fps =60;

analyze_spikes = reconstruct_spikes;
BinningTime = diode_BT;
for i = 48 % i is the channel number
    [n,~] = hist(analyze_spikes{i},BinningTime) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
    BinningSpike(i,:) = n ;
end
        
fs = 60;                                % sample frequency (Hz)
x =bin_pos;
y = 0;
for j = 1:length(time)
y = y + BinningSpike(48,1+length(time)-j:end-j)*cSTA(48, j);
end
x = rescale(x(1:end-length(time)),min(y),max(y));
plot(x);hold on
plot(y);
xc = xcorr(x,y);
longTime = [flip(-1*BinningTime(1:end-length(time))) 0 BinningTime(1:end-length(time))];
plot(longTime, [0 xc 0]);


X = fft(x);
Y = fft(y);
mean(y)
H = X./Y;
G =abs(H);
phi = angle(H);
tau = finite_diff(phi , 4)*fs;
n = length(x);          % number of samples
f = (1:n)*(fs/n);     % frequency range
plot(f, rescale(G, 0, max(tau)));hold on;
plot(f, phi*max(tau)/max(phi))
plot(f,tau)