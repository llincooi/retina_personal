clear all;
close all;
%load('D:\Leo\0229\merge\merge_0224_HMM_UR_DL_G2.5_5min_Q100_6.5mW.mat')
load('merge_0224_HMM_UL_DR_G4.5_5min_Q100_6.5mW.mat')
fps =60;
x = 1:length(bin_pos);
% x = sin(x*pi/8);
% v = cos(x*pi/8);
isix = randi(2, length(bin_pos), 1)';
isiv = randi(2, length(bin_pos), 1)';
x = isix-1;
v = isiv-1;
r = xor(x, v);
isir = r+1;
isii = 2*(isiv-1) + isix;


bin = BinningInterval*1000;
backward=0;
forward=0;
time=[-backward*bin:bin:forward*bin];
[information_x_r information_v_r redundant_I] = PIfunc(isir,isix, isiv,BinningInterval,backward,forward);
information_i_r = MIfunc(isir,isii,BinningInterval,backward,forward);

isiir =  2*(isii-1) + isir;
Hir = Shannon_Entropy(isiir);
Hi = Shannon_Entropy(isii);
Hr = Shannon_Entropy(isir);
Hx = Shannon_Entropy(isix);
isixr =  2*(isix-1) + isir;
Hxr = Shannon_Entropy(isixr);
isivr =  2*(isiv-1) + isir;
Hvr = Shannon_Entropy(isivr);

% shuffle_isir = isir(randperm(length(isir)));
% shuffle_information_x_r = MIfunc(shuffle_isir,isix,BinningInterval,backward,forward);
% shuffle_information_v_r = MIfunc(shuffle_isir,isiv,BinningInterval,backward,forward);
% shuffle_information_i_r = MIfunc(shuffle_isir,isii,BinningInterval,backward,forward);
% information_x_r = information_x_r - min(shuffle_information_x_r);
% information_v_r = information_v_r - min(shuffle_information_v_r);
% information_i_r = information_i_r - min(shuffle_information_i_r);
figure(4);
plot(time,information_x_r, 'r');hold on;
plot(time,information_v_r, 'b')
plot(time,information_i_r, 'k')
plot(time,information_x_r+ information_v_r, 'm')
legend('MI(x, 𝛾)','MI(v, 𝛾)', 'MI([x,v], 𝛾)', 'MI(x, 𝛾)+MI(v, 𝛾)');

z = information_x_r + information_v_r -information_i_r;
%z_minus_base = z- min(shuffle_information_x_r) - min(shuffle_information_v_r) + min(shuffle_information_i_r);
synergy_I = redundant_I-z;
PI_x = information_x_r - redundant_I;
%a = information_x_v - z ;
PI_v = information_v_r - redundant_I;
figure(6);
plot(time,PI_x, 'r');hold on;
plot(time,PI_v, 'b')
plot(time,synergy_I, 'k')
plot(time,redundant_I, 'g')
legend('PI_x','PI_v', 'synergy I', 'redundant I');
