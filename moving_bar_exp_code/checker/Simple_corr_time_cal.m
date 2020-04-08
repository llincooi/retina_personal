clear all
load('\\192.168.0.100\Experiment\Retina\2020Videos\0219v\videoworkspace\0224_sOU_RL_G2.5_5min_Q100_6.5mW_15Hz.mat')
hold on;
plot(newXarray)
acf = autocorr(newXarray,100);
plot(acf)
cor_time2 = interp1(acf,1:length(acf),0.5,'linear')/60;
corr_time = find(abs(acf-0.5) == min(abs(acf-0.5)))/60;