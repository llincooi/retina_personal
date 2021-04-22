figure;
for i = tstep_axis
    TK =  [0 U(:,i)'];
    subplot(N_middle_factor(2),N_middle_factor(1),i),plot(TK);hold on;
    pbaspect([1 1 1])
    title(['\sigma = ', num2str(S(i,i)/sum(S, 'ALL')),]);
end
figure;
for i = tstep_axis
    SK = reshape(V(:,i),[side_length,side_length]);%Reshape one dimensional spatial filter to two dimensional spatial filter
    subplot(N_middle_factor(2),N_middle_factor(1),i),imagesc(SK);hold on;
    pbaspect([1 1 1])
    title(['\sigma = ', num2str(S(i,i)/sum(S, 'ALL')),]);
    colormap(gray);
    colorbar;
    scatter(electrode_x(k),electrode_y(k), 10, 'r','filled');
    scatter( RF_properties(k).X_Coor, RF_properties(k).Y_Coor, 50, 'b' ,'o','filled')
end