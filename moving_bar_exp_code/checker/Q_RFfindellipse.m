BW = (space-min(space))/(max(space, [],  'all')-min(space, [],  'all'));
bw = BW;
bw(BW>=std(BW)) = 1;
bw(BW<=std(BW)) = 0;
for i = 1:length(space)
    for j = 1:length(space)
        if (closest_extrema(1,displaychannel)-j)^2 + (closest_extrema(2,displaychannel)-i)^2 > 13^2
            bw(i, j) = 0
        end
    end
end
s = regionprops(bw,{...
    'Centroid',...
    'MajorAxisLength',...
    'MinorAxisLength',...
    'Orientation'})
figure
imshow(bw,'InitialMagnification','fit')

t = linspace(0,2*pi,50);

hold on
for k = 1:length(s)
    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;
    Xc = s(k).Centroid(1);
    Yc = s(k).Centroid(2);
    phi = deg2rad(-s(k).Orientation);
    x = Xc + a*cos(t)*cos(phi) - b*sin(t)*sin(phi);
    y = Yc + a*cos(t)*sin(phi) + b*sin(t)*cos(phi);
    plot(x,y,'r','Linewidth',5)
end
hold off