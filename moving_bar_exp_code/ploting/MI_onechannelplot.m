%clear all;
close all;
for channelnumber=10:14
figure;
plot(time,Mutual_infos{channelnumber},'LineWidth',1.5); hold on; %,'color',cc(z,:));hold on
plot(time,Mutual_shuffle_infos{channelnumber},'LineWidth',1.5); hold on; %,'color',cc(z,:));hold on
xlabel('\deltat (ms)');ylabel('MI (bits/second)');
set(gca,'fontsize',12); hold on

 

xlim([ -3000 3000])
% ylim([0 inf])
title(['channel ',num2str(channelnumber)])
end


%lgd = legend('Tc = 0.8s', 'Tc = 0.183s');





