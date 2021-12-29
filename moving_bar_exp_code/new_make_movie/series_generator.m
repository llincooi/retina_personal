function Xarray = series_generator(type, Tmin , Gvalue, seeddate, cutOffFreq, productfolder)
if Gvalue==4.5
    load(['C:\retina_makemovie\',seeddate,' new video Br50\rn_workspace\o_rntestG045.mat'])
end% wait for you to extent
mkdir([productfolder,'\series_folder'])
T = Tmin*60;
dt = 1/60;
if strcmp(type, 'LPOU')
    buff_time = 1;%Buffer for delay correction
    T=T+buff_time;
    T=dt:dt:T;
    %Gvalue is damping / only G will influence correlation time
    D = 2700000;%dynamical range
    Xarray = zeros(1,length(T));
    Xarray(1,1)=0; % since the mean value of damped eq is zero
    for uu = 1:length(T)-1
        Xarray(uu+1) = (1-dt*Gvalue/(2.12)^2)*Xarray(uu)+sqrt(dt*D)*rntest(uu);
    end
    fs=60;% Sampling rate
    filterOrder=4;% Order of filter
    [b, a]=butter(filterOrder, cutOffFreq/(fs/2), 'low');% Butterworth filter
    %% Filter and make delay correction
    Smooth_Xarray = filter(b, a, Xarray);
    x = xcorr(Xarray, Smooth_Xarray);
    [~,I]=max(x);
    delay_correction = length(Xarray)-I;
    Smooth_Xarray = Smooth_Xarray(delay_correction+1:end-buff_time/dt+delay_correction);
    Xarray = Smooth_Xarray;
    save([productfolder, 'series_folder\',...
        seeddate,'_', type,'_G', num2str(Gvalue), '_', num2str(cutOffFreq),'Hz_', num2str(Tmin),'min.mat'],'Xarray');
elseif strcmp(type, 'OU')
    T=dt:dt:T;
    %Gvalue is damping / only G will influence correlation time
    D = 2700000;%dynamical range
    Xarray = zeros(1,length(T));
    Xarray(1,1)=0; % since the mean value of damped eq is zero
    for uu = 1:length(T)-1
        Xarray(uu+1) = (1-dt*Gvalue/(2.12)^2)*Xarray(uu)+sqrt(dt*D)*rntest(uu);
    end
    save([productfolder, 'series_folder\',seeddate,'_', type,'_G', num2str(Gvalue), '_', num2str(Tmin),'min.mat'],'Xarray');
elseif strcmp(type, 'HMM')
    T=dt:dt:T;
    %Gvalue is damping / only G will influence correlation time
    D = 2700000;%dynamical range
    omega =Gvalue/2.12; %omega = G/(2w)=1.06; follow Bielak's overdamped dynamics/ 2015PNAS
    Xarray = zeros(1,length(T));
    Xarray(1,1)=0; % since the mean value of damped eq is zero
    Vx = zeros(1,length(T));
    %Use rntest(t)!!!
    for t = 1:length(T)-1
        Xarray(t+1) = Xarray(t) + Vx(t)*dt;
        Vx(t+1) = (1-Gvalue*dt)*Vx(t) - omega^2*Xarray(t)*dt + sqrt(dt*D)*rntest(t);
    end
    save([productfolder, 'series_folder\',seeddate,'_', type,'_G', num2str(Gvalue), '_', num2str(Tmin),'min.mat'],'Xarray');
end


end