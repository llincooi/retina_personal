T=5*60; %second
dt=1/60;
Time=dt:dt:T;
repeat = 100;
HMMcor_time = [];
Smooth_OUcor_time = [];
HMMV = [];
Smooth_OUV = [];
Gvalue = 4.5;
cutOffFreq = 1;
load('C:\calibration\20200219oled_calibration\oled_boundary_set.mat')
for i = 1:repeat
    rntest = randn(length(Time)*2,1);
    HMMXarray = HMM_generator(T,dt,Gvalue,rntest);
    HMMXarray = round(rescale(HMMXarray, leftx_bar+bar_wid, rightx_bar-bar_wid));
    acf = autocorr(HMMXarray,150);
    HMMcor_time = [HMMcor_time interp1(acf,1:length(acf),0.5,'linear')/60];
    HMMV = [HMMV std(diff(HMMXarray)/dt)*micro_per_pixel];
    Smooth_OUXarray = Smooth_OU_generator(T,dt,Gvalue,rntest,cutOffFreq);
    Smooth_OUXarray = round(rescale(Smooth_OUXarray, leftx_bar+bar_wid, rightx_bar-bar_wid));
    acf = autocorr(Smooth_OUXarray,150);
    Smooth_OUcor_time = [Smooth_OUcor_time interp1(acf,1:length(acf),0.5,'linear')/60];
    Smooth_OUV = [Smooth_OUV std(diff(Smooth_OUXarray)/dt)*micro_per_pixel];
end

mean(Smooth_OUcor_time)
mean(HMMcor_time)
mean(Smooth_OUV)
mean(HMMV)