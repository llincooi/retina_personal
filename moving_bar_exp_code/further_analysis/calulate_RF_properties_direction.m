close all;
clear all;
code_folder = pwd;
name = '30Hz_27_RF_15min';%Directory name
exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0729';
sorted = 0;

if sorted
    load([exp_folder,'\Analyzed_data\', name, '\sort\RF_properties.mat']);
else
    load([exp_folder,'\Analyzed_data\', name, '\unsort\RF_properties.mat']);
end
load('oled_channel_pos.mat')
load('oled_boundary_set.mat')

%% Calculate distance from MeaCenter and RF on bar motion direction
direction = 'UL_DR';
theta = -pi/4;
disfc = zeros(60,1);
RFalongdir = zeros(60,1);
for k = 1:60
    if RF_properties(k,2) ~= 0
        disfc(k) = Monitor2DCoor2BarCoor(RF_properties(k,2),RF_properties(k,4), direction,'OLED')-meaCenter_x;
        b = RF_properties(k,5);
        a = RF_properties(k,3);
        e = sqrt(1-b^2/a^2);
        dtheta = RF_properties(k,6)-theta;
        RFalongdir(k) = b/sqrt(1-(e^2)*(cos(dtheta))^2);
    end
end

%% PIz check RF_properties_name
RF_properties = [RF_properties, RFalongdir];
RF_properties = [RF_properties, disfc];

RF_properties_name = {'Amplitude',' X-Coordinate', 'Long-axis','Y-Coordinate','short-axis','Angle(Long-axis)','radius', 'Distance from bar center', 'RF along bar montion'};
if sorted
    save([exp_folder,'\Analyzed_data\', name, '\sort\RF_properties_,',direction,'.mat'],'RF_properties','RF_properties_name');
else
    save([exp_folder,'\Analyzed_data\', name, '\unsort\RF_properties_,',direction,'.mat'],'RF_properties','RF_properties_name');
end
