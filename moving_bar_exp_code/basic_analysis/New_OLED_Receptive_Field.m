close all;
clear all;
code_folder = pwd;
load('oled_channel_pos.mat')
load('oled_boundary_set.mat')

%% things to key in
displaychannel = 53;%Choose which channel to display
save_photo =1;%0 is no save RF photo, 1 is save
save_svd =1;%0 is no save svd photo, 1 is save
tstep_axis = 1:9;%for -50ms:-300ms
fps = 1/30;%50ms
name = '30Hz_27_RF';%Directory name
exp_folder = 'D:\GoogleDrive\retina\Exps\2020\0729';

%%
N = length(tstep_axis);
if  mod(sqrt(N),1) == 0 %if N is a perfact square
    N_middle_factor = [sqrt(N) sqrt(N)];
else
    K = flip(1:ceil(N/2));
    N_middle_factor = K(find(rem(N,K)==0));
end

cd(exp_folder)
%% For unsorted spikes
load('merge\merge_0224_Checkerboard_30Hz_27_15min_Br50_Q100.mat')
analyze_spikes = reconstruct_spikes;
sorted = 0;
%% For sorted spikes
% load('sort_merge_spike\sort_merge_0224_Checkerboard_20Hz_27_5min_Br50_Q100.mat')
% unit = 1;
% complex_channel = [];
% analyze_spikes = get_multi_unit(exp_folder,sorted_spikes,unit);
% sorted = 1;


%% Create directory
mkdir FIG
cd FIG
mkdir RF
cd RF
mkdir(name)
cd (name)
mkdir sort
mkdir unsort

%% Delete useless channel
checkerboard = bin_pos;%Stimulus we use
null_channel = [];
stimulus_length = TimeStamps(2)-TimeStamps(1);

for j = 1:length(displaychannel)
    num_spike =  length(analyze_spikes{displaychannel (j)});
    if num_spike /stimulus_length < 0.3  %Cells with a low firing rate for checkerbox(<1HZ) were not considered
        null_channel = [null_channel j];
    end
end
disp(['useless channels are ',num2str(null_channel)])

displaychannel (null_channel) = [];


%% calculate RF
side_length = length(checkerboard{1});%length of checkerboard
matcheckerboard = zeros(length(checkerboard),side_length,side_length);
for j = 1:length(checkerboard)
    matcheckerboard(j,:,:) = checkerboard{j};
end
temporal_bias = squeeze(sum(matcheckerboard, 1))/length(checkerboard); %No spatial bias because the algorithm makes sure same mean luminaous for each frame

RF = zeros(length(tstep_axis),side_length,side_length, 60);
gauss_RF = zeros(length(tstep_axis),side_length,side_length, 60);
for k =displaychannel
    analyze_spikes{k}(analyze_spikes{k}<1) = []; %remove all feild on effect
    for i =  tstep_axis  %for -50ms:-300ms
        sum_checkerboard = zeros(length(bin_pos{1}));
        for j = 1:length(analyze_spikes{k})
            spike_time = analyze_spikes{k}(j); %s
            RF_frame = max(0, floor((spike_time - i*fps)*60));
            sum_checkerboard = sum_checkerboard + squeeze(matcheckerboard(RF_frame,:,:));
        end
        RF(i,:,:,k) = sum_checkerboard/length(analyze_spikes{k});
        gauss_RF(i,:,:,k) = imgaussfilt(squeeze(RF(i,:,:,k))-temporal_bias,1.5);
    end
end
%% calculate SVD
for k =displaychannel
    %calculate SVD
    reshape_RF = zeros(side_length^2,length(tstep_axis));
    for i =  tstep_axis %for -50ms:-300ms
        reshape_RF(:,i) = reshape(gauss_RF(i,:,:,k),[side_length^2,1]);
    end
    [U,S,V] = svd(reshape_RF');%U is temporal filter, V is one dimensional spatial filter, S are singular values
    if abs(min(V(:,1)))>abs(max(V(:,1))) % asume that all channel are fast-OFF-slow-ON if there is no csta file.
        U(:,1) = -U(:,1);
        V(:,1) = -V(:,1);
    end
    space = reshape(V(:,1),[side_length,side_length]);%Reshape one dimensional spatial filter to two dimensional spatial filter
    %Calculate first component percentage
    power_component = round(diag(S)/sum(diag(S)), 3);%Each component percentage
    disp(['channel',int2str(k),' 1st_component power is ',num2str(power_component(1))])
end
%% plot temporal SVD
for k =displaychannel
    %Calculate and plot temporal SVD
    figure(k+200);hold on;
    plot([0 tstep_axis*fps*1000] , [0 U(:,1)'], 'LineWidth',3)
    title(['temporal filter from SVD channel ',int2str(k)])
    xlabel('time before spike(ms)')
    ylabel('relative intensity')
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    if save_svd
        if sorted
            saveas(fig,[exp_folder, '\FIG\RF\', name,'\sort','\temporal_svd_channel_', num2str(k)  '.tiff'])
        else
            saveas(fig,[exp_folder, '\FIG\RF\', name,'\unsort','\temporal_svd_channel_', num2str(k)  '.tiff'])
        end
        close(fig);
    end
end
%% Plot SVD (and electrode position) ; Find RF
electrode_x = zeros(1,60);%x positions of electrode
electrode_y = zeros(1,60);%y positions of electrode
RF_properties = struct(); %find RF_center by 2D GaussianFit['Amplitude',' X-Coordinate', 'X-Width','Y-Coordinate','Y-Width','Angle'];
for k =displaychannel
    %Calculate electrode position and RF center from SVD
    electrode_x(k) = (oled_channel_pos(k,1)-meaCenter_x)*side_length/mea_size_bm + round(side_length/2);
    electrode_y(k) = (oled_channel_pos(k,2)-meaCenter_y)*side_length/mea_size_bm + round(side_length/2);
    num_spike =  length(analyze_spikes{k});

    RFpro = RF_finder(space);
    RF_PropertyNames = {'Amplitude', 'X_Coor', 'X_Width','Y_Coor','Y_Width','Angle'};
    for i = 1:length(RFpro)
        RF_properties(k).(RF_PropertyNames{i}) = RFpro(i); % fit to 2D-Guassion
    end
    
    %Plot spatial SVD
    figure(k+100)
    imagesc(space);hold on;
    title(k)
    pbaspect([1 1 1])
    colormap(gray);
    colorbar;
    scatter(electrode_x(k),electrode_y(k), 50, 'r','filled');
    if num_spike /stimulus_length > 1
        scatter( RF_properties(k).X_Coor, RF_properties(k).Y_Coor, 50, 'b' ,'o','filled')
    end
    
    %plot RF_ellipse
    t=-pi:0.01:pi;
    e_x=RF_properties(k).X_Width*cos(t);
    e_y=RF_properties(k).Y_Width*sin(t);
    theta = RF_properties(k).Angle;
    R_matrix = [cos(theta) sin(theta) ; -sin(theta) cos(theta)];
    ellipse = R_matrix*[e_x;e_y];
    e_x=RF_properties(k).X_Coor+ellipse(1,:);
    e_y=RF_properties(k).Y_Coor+ellipse(2,:);
    plot(e_x,e_y, 'LineWidth', 2)

    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    if save_svd
        if sorted
            saveas(fig,[exp_folder, '\FIG\RF\', name,'\sort','\spatial_svd_channel', num2str(k)  '.tiff'])
        else
            saveas(fig,[exp_folder, '\FIG\RF\', name,'\unsort','\spatial_svd_channel', num2str(k)  '.tiff'])
        end
%         close(fig);
    end
end


%% plot RF & electrode position & RF center
for k = displaychannel
    %plot RF & electrode position & RF center
    figure(k);
    num_spike =  length(analyze_spikes{k});
    for i = tstep_axis
        subplot(N_middle_factor(2),N_middle_factor(1),i),imagesc(squeeze(gauss_RF(i,:,:,k)));hold on;
        pbaspect([1 1 1])
        title([num2str(-i*fps*1000),'ms']);
        colormap(gray);
        colorbar;
        scatter(electrode_x(k),electrode_y(k), 10, 'r','filled');
        if num_spike /stimulus_length > 1
            scatter( RF_properties(k).X_Coor, RF_properties(k).Y_Coor, 50, 'b' ,'o','filled')
        end
        
    end
    
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    if save_photo
        if sorted
            saveas(fig,[exp_folder, '\FIG\RF\', name,'\sort','\channel', num2str(k)  '.tiff'])
        else
            saveas(fig,[exp_folder, '\FIG\RF\', name,'\unsort','\channel', num2str(k)  '.tiff'])
        end
        close(fig);
    end
   
    
end
%% Only for direction = 'UL_DR'
for k = displaychannel
    offset = round(RF_properties(k).X_Coor)-round(RF_properties(k).Y_Coor);
    iSK = 0;
    for i  = tstep_axis
        iSK = iSK+squeeze(gauss_RF(i,:,:,k));
    end
    figure(300+k);hold on;
    plot(diag(iSK,offset))
    plot(diag(space,offset))
    
    xaxis = linspace(1,length(diag(iSK,offset)),1000);
    bar = zeros(1,1000);
    interp1(xaxis, 1:1000, find(diag(space,offset) == max(diag(space,offset))));
    (bar_wid*2+1)/mea_size_bm*side_length;
    figure(400+k);
    imagesc(iSK);hold on;
    pbaspect([1 1 1])
    colormap(gray);
    colorbar;
    scatter( RF_properties(k).X_Coor, RF_properties(k).Y_Coor, 50, 'b' ,'o','filled')
    plot(e_x,e_y, 'LineWidth', 2)
end
%% Change coordinates, resacle;
RF_pixel_size = mea_size_bm/side_length*micro_per_pixel %mircometer
for k = displaychannel
    RF_properties(k).X_Coor = ( RF_properties(k).X_Coor - round(side_length/2))/(side_length/mea_size_bm)+meaCenter_x;
    RF_properties(k).Y_Coor = ( RF_properties(k).Y_Coor - round(side_length/2))/(side_length/mea_size_bm)+meaCenter_y;
    RF_properties(k).X_Width =  1.5*RF_properties(k).X_Width*RF_pixel_size; %%mm %%1.5*sdv accroding to Gollisch
    RF_properties(k).Y_Width =  1.5*RF_properties(k).Y_Width*RF_pixel_size; %%mm %%1.5*sdv accroding to Gollisch
    RF_properties(k).radius = sqrt(RF_properties(k).X_Width*RF_properties(k).Y_Width); %"radius" == (a*b)^0.5 for ellipse
    if RF_properties(k).X_Width < RF_properties(k).Y_Width
        temp = RF_properties(k).X_Width;
        RF_properties(k).X_Width = RF_properties(k).Y_Width;
        RF_properties(k).Y_Width =temp;
        if RF_properties(k).Angle > 0
            RF_properties(k).Angle = RF_properties(k).Angle - pi/2;
        else
            RF_properties(k).Angle = RF_properties(k).Angle + pi/2;
        end
    end
end



%%
if sorted
    save([exp_folder,'\Analyzed_data\', name, '\sort\RF_properties.mat'],'RF_properties');
else
    save([exp_folder,'\Analyzed_data\', name, '\unsort\RF_properties.mat'],'RF_properties');
end


cd(code_folder)