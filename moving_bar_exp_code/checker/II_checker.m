clear all;
close all;
load('D:\Leo\0229\merge\merge_0224_HMM_UR_DL_G2.5_5min_Q100_6.5mW.mat')
fps =60;

x = bin_pos(1:end);
v = finite_diff(x ,4);
tau_v = 0.2*fps; %has to be greater than zero
tau_x = 0.4*fps;
r = poissrnd(abs(finite_diff(v ,4))); %%Generate spikes from poisson process
r = r(1+tau_v:end-tau_x);
x = x(1+tau_x +tau_v:end);
v = v(1:end-tau_v-tau_x);
RespoSN = 4;
thesholds = [[std(r) 2*std(r) 3*std(r) ]+mean(r) max(r)];
isir = [];
for jj=1:length(r)
    isir(jj) = find(r(jj)<=thesholds,1);
end

StimuSN = 9;
sqrtStimuSN = 9;



% [n,~] = hist(reconstruct_spikes{27},diode_BT) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
% isir= n ;

nX=sort(x);
abin=length(nX)/sqrtStimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isix=[];
for jj=1:length(x)
    isix(jj) = find(x(jj)<=intervals,1);
end
nX=sort(v);
abin=length(nX)/sqrtStimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
isiv=[];
for jj=1:length(v)
    isiv(jj) = find(v(jj)<=intervals,1);
end
isii = sqrtStimuSN*(isiv-1) + isix;
figure(3);histogram(isii, StimuSN)


nX=sort(x);
abin=length(nX)/StimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isix=[];
for jj=1:length(x)
    isix(jj) = find(x(jj)<=intervals,1);
end
nX=sort(v);
abin=length(nX)/StimuSN;
intervals=[nX(abin:abin:end) inf]; % inf: the last term: for all rested values
isiv=[];
for jj=1:length(v)
    isiv(jj) = find(v(jj)<=intervals,1);
end
figure(1);histogram(isix, StimuSN)
figure(2);histogram(isiv, StimuSN)
length(unique(isiv))


bin = BinningInterval*1000;
backward=ceil(15000/bin);
forward=ceil(15000/bin);
time=[-backward*bin:bin:forward*bin];
information_x_r = MIfunc(isir,isix,BinningInterval,backward,forward);
information_v_r = MIfunc(isir,isiv,BinningInterval,backward,forward);
information_i_r = MIfunc(isir,isii,BinningInterval,backward,forward);
shuffle_isir = isir(randperm(length(isir)));
shuffle_information_x_r = MIfunc(shuffle_isir,isix,BinningInterval,backward,forward);
shuffle_information_v_r = MIfunc(shuffle_isir,isiv,BinningInterval,backward,forward);
shuffle_information_i_r = MIfunc(shuffle_isir,isii,BinningInterval,backward,forward);
information_x_r = information_x_r - max(shuffle_information_x_r);
information_v_r = information_v_r - max(shuffle_information_v_r);
information_i_r = information_i_r - max(shuffle_information_i_r);
figure(4);
plot(time,information_x_r, 'r');hold on;
plot(time,information_v_r, 'b')
plot(time,information_i_r, 'k')
plot(time,information_x_r+ information_v_r, 'm')
time(find(information_i_r > information_x_r+ information_v_r))




information_x_x = MIfunc(isix,isix,BinningInterval,backward,forward);
information_v_v = MIfunc(isiv,isiv,BinningInterval,backward,forward);
information_i_i = MIfunc(isii,isii,BinningInterval,backward,forward);
shuffle_information_x_x = MIfunc(isix(randperm(length(isix))),isix,BinningInterval,backward,forward);
shuffle_information_v_v = MIfunc(isiv(randperm(length(isiv))),isiv,BinningInterval,backward,forward);
shuffle_information_i_i = MIfunc(isii(randperm(length(isii))),isii,BinningInterval,backward,forward);
information_x_x = information_x_x - max(shuffle_information_x_x);
information_v_v = information_v_v - max(shuffle_information_v_v);
information_i_i = information_i_i - max(shuffle_information_i_i);
figure(5);
plot(time,information_x_x, 'r');hold on;
plot(time,information_v_v, 'b')
plot(time,information_i_i, 'k')
plot(time,information_x_x+ information_v_v, 'm')

pTau = 0;
nTau = 30;
H_x = Shannon_Entropy(isix(1+nTau:end-pTau), StimuSN);
H_v = Shannon_Entropy(isiv(1+nTau:end-pTau), StimuSN);
H_rt = Shannon_Entropy(isir(1+pTau:end-nTau), StimuSN);
H_x_v = Shannon_Entropy(isii(1+nTau:end-pTau), StimuSN^2);
isi2 = sqrtStimuSN*(isix(1+nTau:end-pTau)-1) + isir((1+pTau:end-nTau));
H_x_rt = Shannon_Entropy(isi2, length(unique(isi2)));
isi3 = sqrtStimuSN*(isiv(1+nTau:end-pTau)-1) + isir((1+pTau:end-nTau));
H_v_rt = Shannon_Entropy(isi3, length(unique(isi3)));
isi4 = sqrtStimuSN*(isii(1+nTau:end-pTau)-1) + isir((1+pTau:end-nTau));
H_x_v_rt = Shannon_Entropy(isi4, length(unique(isi4)));
z = -(-H_x-H_v-H_rt+H_x_rt+H_v_rt+H_x_v-H_x_v_rt);
a = -(-H_x-H_v+H_x_v)-z;
b = -(-H_v-H_rt+H_v_rt)-z;
c = -(-H_x-H_rt+H_x_rt)-z;
f = H_x_v_rt - H_x_rt;
e = H_x_v_rt - H_v_rt;
g = H_x_v_rt - H_x_v;
[a b c e f g z]/BinningInterval
information_i_r(902-pTau+nTau) - information_x_r(902-pTau+nTau) - information_v_r(902-pTau+nTau) - mean(shuffle_information_x_r) - mean(shuffle_information_v_r) + mean(shuffle_information_i_r)
