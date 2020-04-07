LCD=a_data(3,:);
OLED=a_data(1,:);
OLED = OLED/mean(OLED)*mean(LCD);
plot(LCD);hold on
plot(OLED);
x = xcorr(LCD, OLED);
figure
plot(x)
[m I]=max(x)
 lelay_correction = -(length(LCD)-I)/20000
