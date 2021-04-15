exp_folder = 'D:\GoogleDrive\retina\Chou''s data\20210331';
load([exp_folder, '\Analyzed_data\30Hz_27_RF_15min\unsort\RF_properties.mat'])
RFR15 = zeros(1, 60);
for k = 1:60
    if isempty(RF_properties(k).radius)
    else
        RFR15(k) = RF_properties(k).radius;
    end
end
load([exp_folder, '\Analyzed_data\30Hz_27_RF_30min\unsort\RF_properties.mat'])
RFR30= zeros(1, 60);
for k = 1:60
    if isempty(RF_properties(k).radius)
    else
        RFR30(k) = RF_properties(k).radius;
    end
end
scatter(RFR15, RFR30)
