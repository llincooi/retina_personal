for k = displaychannel
    %plot RF & electrode position & RF center
    figure(600+k);
    num_spike =  length(analyze_spikes{k});
    iSK = 0;
    for i = tstep_axis
        iSK = iSK+squeeze(gauss_RF(i,:,:,k));
        subplot(N_middle_factor(2),N_middle_factor(1),i),imagesc(iSK);hold on;
        pbaspect([1 1 1])
        title(['sum to ', num2str(-i*fps*1000),'ms']);
        colormap(gray);
        colorbar;
        scatter(electrode_x(k),electrode_y(k), 10, 'r','filled');
        scatter( RF_properties(k).X_Coor, RF_properties(k).Y_Coor, 50, 'b' ,'o','filled')
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

for k = displaychannel
    offset = side_length+1-round(RF_properties(k).X_Coor)-round(RF_properties(k).Y_Coor);
    figure(300+k);hold on;
    plot(diag(fliplr(squeeze(SVD_SK(k, :, :))),offset),'LineWidth', 2)
    
    xaxis = linspace(1,length(diag(iSK,offset)),1000);
    bar = zeros(1,1000);
    bc = interp1(xaxis, 1:1000, find(diag(fliplr(squeeze(SVD_SK(k, :, :))),offset) == max(diag(fliplr(squeeze(SVD_SK(k, :, :))),offset))), 'nearest');
    hw = round((bar_wid*2+1)/mea_size_bm*side_length/sqrt(2)/length(diag(fliplr(iSK),offset))*1000/2);
    bar(max(bc-hw,1):min(bc+hw, 1000)) = max(diag(fliplr(squeeze(SVD_SK(k, :, :))),offset));
    plot(xaxis,bar,'LineWidth', 2)
    iSK = 0;
    for i = tstep_axis
        %plot RF & electrode position & RF center
        iSK = iSK+squeeze(gauss_RF(i,:,:,k));
        plot(diag(fliplr(iSK),offset),'LineWidth', 1)
    end
end





