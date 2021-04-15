exp_folder = 'D:\GoogleDrive\retina\Chou''s data\20210413';
load([exp_folder,'\merge\merge_0224_Checkerboard_30Hz_27_15min_Br50_Q100.mat'])
analyze_spikes = reconstruct_spikes;
load([exp_folder, '\Analyzed_data\30Hz_27_RF\unsort\RF_properties.mat'])
numspike = zeros(1, 60);
RFR = zeros(1, 60);
dch = [];
for k = 1:60
    if k>length(RF_properties)
    elseif isempty(RF_properties(k).radius) 
    else
        RFR(k) = RF_properties(k).radius;
        numspike(k) = length(analyze_spikes{k});
        dch = [dch k];
    end
end
scatter(numspike(dch), RFR(dch))
