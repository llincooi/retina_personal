clear all;
%% Things barely change
load('oled_boundary_set.mat');
WherenWhen =struct();
WherenWhen.makemovie_folder = 'C:\Users\hydro_leo\Documents\GitHub\retina_personal\moving_bar_exp_code\new_make_movie\'; 
WherenWhen.date = datestr(datetime('now'), 'mmdd');
WherenWhen.date = '1214';
WherenWhen.video_folder = '\\ZebraNas\Public\Retina\Video\20211211video\';
cd(WherenWhen.video_folder)
WherenWhen.videoworkspace_folder = '\\ZebraNas\Public\Retina\Video\20211211video\videoworkspace\';
WherenWhen.calibration_date = '20211211';
cd(WherenWhen.makemovie_folder);

WherenWhen.productfolder = 'C:\retina_makemovie\';
%% Checkerboard
% makeOLED_checkerboard_video(WherenWhen, refresh_fps, num_pixel, mins, bright_lum, aperture)
makeOLED_checkerboard_video(WherenWhen,   30,          27,        15,   13,         0.2);

%% WF LPOU D-Fc
series = struct();
series.type = 'LPOU';
series.Fc = 1;
series.G = 4.5;
series.seeddate = '0421'; %where to import random seed ('mmdd')
series.length = 5; %(min)

irradiance = struct();
irradiance.mean = 10;
irradiance.contrast = 0.2;
irradiance.aperture = 0.2;
for Fc = [1,2,4]
    series.Fc = Fc;
    makeOLED_WF_video(WherenWhen, irradiance, series);
end

%% WF WN DCDM
series = struct();
series.type = 'WN';
series.length = 5; %(min)

for M = [4,7,10,13,16,19]
    for C = [0.1,0.15,0.2,0.3]
        irradiance.mean = M;
        irradiance.contrast = C;
        makeOLED_WF_video(WherenWhen, irradiance, series);
    end
end

%% WF LPOU DCDM
series = struct();
series.type = 'LPOU';
series.Fc = 1;
series.G = 4.5;
series.seeddate = '0421'; %where to import random seed ('mmdd')
series.length = 5; %(min)

for M = [4,7,10,13,16,19]
    for C = [0.1,0.15,0.2,0.3]
        irradiance.mean = M;
        irradiance.contrast = C;
        makeOLED_WF_video(WherenWhen, irradiance, series);
    end
end

%% LPOU D-Fc
series = struct();
series.type = 'LPOU';
series.Fc = 1;
series.G = 4.5;
series.seeddate = '0421'; %where to import random seed ('mmdd')
series.length = 5; %(min)

sti_matrix = struct();
sti_matrix.type = 'SW'; %'SW':square wave; 'GP': Gaussian pulse; 'Grating'
sti_matrix.width = 8; %half width of 'SW' and 'Grating'; sigma for 'GP'. Addtional term for dark spatial period of 'Grating'
sti_matrix.length = 'long'; %'long': 1-D matrix repeated to 2-D; short: 2-D matrix
sti_matrix.dynamical_range = [leftx_bar, rightx_bar];

irradiance = struct();
irradiance.bar = 10;
irradiance.background = 0;
irradiance.aperture = 0.2;
for Fc = [1, 2, 4]
    for theta = [0, pi/2, pi/4, pi*3/4]
        series.Fc = Fc;
        makeOLED_video_rot(WherenWhen, theta, irradiance, sti_matrix, series)
    end
end

%% LPOU D-sigma
series = struct();
series.type = 'LPOU';
series.Fc = 1;
series.G = 4.5;
series.seeddate = '0421'; %where to import random seed ('mmdd')
series.length = 5; %(min)

sti_matrix = struct();
sti_matrix.type = 'GP'; %'SW':square wave; 'GP': Gaussian pulse; 'Grating'
sti_matrix.width = 6.8; %half width of 'SW' and 'Grating'; sigma for 'GP'. Addtional term for dark spatial period of 'Grating'
sti_matrix.length = 'long'; %'long': 1-D matrix repeated to 2-D; short: 2-D matrix
sti_matrix.dynamical_range = [leftx_bar, rightx_bar];

irradiance = struct();
irradiance.bar = 10;
irradiance.background = 0;
irradiance.aperture = 0.2;
for sigma = [6.8,13.2,25.9]
    for theta = [0, pi/2, pi/4, pi*3/4]
            sti_matrix.width = sigma;
        makeOLED_video_rot(WherenWhen, theta, irradiance, sti_matrix, series)
    end
end




