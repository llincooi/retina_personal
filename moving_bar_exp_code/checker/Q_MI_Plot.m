figure('units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.04 .02],[0.07 0.02],[.02 .02]);


rr =[9,17,25,33,41,49,...
    2,10,18,26,34,42,50,58,...
    3,11,19,27,35,43,51,59,...
    4,12,20,28,36,44,52,60,...
    5,13,21,29,37,45,53,61,...
    6,14,22,30,38,46,54,62,...
    7,15,23,31,39,47,55,63,...
    16,24,32,40,48,56];
for channelnumber=1:60
    if max(MI{channelnumber})<0.1
        continue;
    end
    MI{channelnumber} = smooth(MI{channelnumber});
    axes(ha(rr(channelnumber)));
    plot(TimeShift, MI{channelnumber},'LineWidth',2,'LineStyle','-');
    grid on
    ylim([-inf-0.1 inf+0.1])
    title(channelnumber)
    
end