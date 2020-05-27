%% Code that calculate correlation time
%load merge data first
acf = autocorr(bin_pos,'NumLags',100);
corr_time = interp1(acf,1:length(acf),0.5,'linear')/60;
disp(['The correlation time is ',num2str(corr_time),' second'])