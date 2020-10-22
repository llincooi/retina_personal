exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0729';
load([exp_folder '\Analyzed_data\30Hz_27_RF_15min\unsort\RF_properties.mat'])
load('C:\calibration\20200219oled_calibration\oled_boundary_set.mat')
if size(RF_properties, 2) == 7
    x = RF_properties(:, 2);
    y = RF_properties(:, 4);
    dis = Monitor2DCoor2BarCoor(x,y,'UL_DR','OLED') - meaCenter_x;
    dis(find(x==0)) = 0;
    RF_properties = [RF_properties dis];
end
save([exp_folder '\Analyzed_data\30Hz_27_RF_15min\unsort\RF_properties.mat'])