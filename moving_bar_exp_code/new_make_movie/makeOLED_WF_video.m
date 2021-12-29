function makeOLED_WF_video(WherenWhen, irradiance, series)
%%
% WherenWhen
    % date: today
    % video_folder: where to export video
    % videoworkspace_folder: where to export video details
    % calibration_date: when is the setup calibrated
    % productfolder: where keep series and sti_matirx ('C:\retina_makemovie\')
% irradiance: 
    % mean: (mW/m2)
    % contrast: std/mean
    % aperture: Adjust the aperture of telecentric lens for higher resolution or higher range.
% series:
    % type: 'HMM', 'OU', 'LPOU', 'WN'
    % Fc: cutoff_frequency for 'LPOU'
    % G: Gamma in HMM and tau in OU
    % seeddate: where to import random seed ('mmdd') (not for WN)
    % length: (min)


%% basic setting
load(['C:\retina_makemovie\calibration\',WherenWhen.calibration_date,'oled_calibration\calibration.mat'])
load(['C:\retina_makemovie\calibration\',WherenWhen.calibration_date,'oled_calibration\oled_boundary_set.mat']);
fps=60;  %
dt=1/fps; %s

%% load or create series
if strcmp(series.type, 'HMM') || strcmp(series.type, 'OU')
    VideoName_A = [series.type,'_G',num2str(series.G)];
    try
        load([WherenWhen.productfolder, 'series_folder\',series.seeddate,'_', VideoName_A ,num2str(series.length),'min.mat']);
    catch
        Xarray = series_generator(series.type, series.length, series.G, series.seeddate, 0, WherenWhen.productfolder);
    end
elseif strcmp(series.type, 'LPOU')
    VideoName_A = [series.type,'_G',num2str(series.G), '_',num2str(series.Fc),'Hz'];
    try
        load([WherenWhen.productfolder, 'series_folder\', series.seeddate,'_', VideoName_A ,num2str(series.length),'min.mat']);
    catch
        Xarray = series_generator(series.type, series.length, series.G, series.seeddate, series.Fc, WherenWhen.productfolder);
    end
elseif strcmp(series.type, 'WN')
    VideoName_A = [series.type];
    Xarray = randn(1,series.length*60/dt);
else
end
%% rescale series to fit in stimulus dynamical_range
newXarray = ((Xarray-mean(Xarray))/std(Xarray) *irradiance.contrast +1) * irradiance.mean;
newXarray(find(newXarray<0)) = 0;
newXarray(find(newXarray>2*irradiance.mean)) = 2*irradiance.mean;
OLEDXarray = interp1(real_lum*irradiance.aperture,lum,newXarray,'linear');
monitor_mean_lumin= interp1(real_lum*irradiance.aperture,lum,irradiance.mean,'linear');
%% Video setting
VideoName_C = [num2str(irradiance.mean), '-', num2str(irradiance.contrast), 'mW_A=', num2str(irradiance.aperture)];
name = [WherenWhen.date, '_WF_', VideoName_A, '_', VideoName_C]

video_fps = fps;
writerObj = VideoWriter([WherenWhen.video_folder,name,'.avi']);  %change video name here!
writerObj.FrameRate = video_fps;
writerObj.Quality = 100;
open(writerObj);


%% Start part: adaptation
img=zeros(screen_y,screen_x);
for mm=1:fps*20
    img=zeros(screen_y,screen_x);
    img(1:600,1:800) = monitor_mean_lumin;
    writeVideo(writerObj,img);
end
%% Draw matrix
for kk =1:length(OLEDXarray)
    a=zeros(screen_y,screen_x);%full screen pixel matrix %it's the LED screen size
    a(1:600,1:800) = OLEDXarray(kk);
    %% Square_flicker
    if mod(kk,3)==1 %odd number
        a(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=1; % white square
    elseif mod(kk,3)==2
        a(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=0.2; %gray
    else
        a(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=0; % dark
    end
    writeVideo(writerObj,a);
end
%% End part video for detection of ending
img=zeros(screen_y,screen_x);
img(flicker_loc(1):flicker_loc(2),flicker_loc(3):flicker_loc(4))=0.2; %gray
for mm=1:10
    writeVideo(writerObj,img);
end
img=zeros(screen_y,screen_x);
writeVideo(writerObj,img);
close(writerObj);

% [WherenWhen.videoworkspace_folder, name,'.mat']
save([WherenWhen.videoworkspace_folder, name,'.mat'],'newXarray','series')
end