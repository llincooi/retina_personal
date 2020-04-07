SamplingRate = 20000;
cc = hsv(3);
rr =[9,17,25,33,41,49,...
    2,10,18,26,34,42,50,58,...
    3,11,19,27,35,43,51,59,...
    4,12,20,28,36,44,52,60,...
    5,13,21,29,37,45,53,61,...
    6,14,22,30,38,46,54,62,...
    7,15,23,31,39,47,55,63,...
    16,24,32,40,48,56];
roi = [1:60];

analyze_spikes = Spikes;

bin = 5;  BinningInterval = bin*10^-3;  %ms
TriggerData = a_data(1,TimeStamps(1)*SamplingRate:TimeStamps(length(TimeStamps))*SamplingRate);% figure;plot(isi);
inten = downsample(TriggerData,SamplingRate*BinningInterval);
plot(inten);
%% spike process
BinningTime = [TimeStamps(1) : BinningInterval : TimeStamps(end)];
BinningSpike = zeros(60,length(BinningTime));
for i = 1:60
    [n,xout] = hist(analyze_spikes{i},BinningTime) ;
    BinningSpike(i,:) = n ;
end
BinningSpike(:,1) = 0;BinningSpike(:,end) = 0;
temprr=0;


%% STA
window = 1;  %STA window
window2 =1;
cSTA = zeros(60, round(window/BinningInterval)+round(window2/BinningInterval)+1);
useful_channelnumber = [];
for nn = 1:length(roi)
    spike = BinningSpike(roi(nn),:);
    
    
    sts = [];
    temp = 0;
    spike(1:window/BinningInterval) = 0;
    spike(length(spike)-window2/BinningInterval-10:end) = 0;
    for in = 1:length(spike)
        if spike(in)~=0
            temp = temp+1;
            sts(temp,:) = spike(in)*inten(in-round(window/BinningInterval):in+round(window2/BinningInterval));
        end
    end
    STA = sum(sts)/sum(spike);%;
    STA = STA-STA(end);
    STA = STA/max(abs(STA));
    %         figure(roi(nn));hold on;
    
    STA = STA/max(abs(STA));
    cSTA(roi(nn),:) = STA;
    
    if isempty(find(abs(cSTA(nn,1:round(length(cSTA)/2))) >= 7*std(cSTA(nn,1:300/bin))))
        cSTA(roi(nn),:) = NaN;
    else
        useful_channelnumber = [useful_channelnumber roi(nn)];
    end
end

time = [-window*1000:bin:window2*1000];
figure('units','normalized','outerposition',[0 0 1 1])
ha = tight_subplot(8,8,[.03 .01],[0.02 0.02],[.01 .01]);
for channelnumber=useful_channelnumber
    axes(ha(rr(channelnumber)));
    plot(time(101:201),cSTA(channelnumber,101:201),'LineWidth',1.5);%,'color',cc(z,:)
    title(channelnumber)
end
if sorted
    saveas(gcf,['FIG\sort\', 'csta','.tiff'])
else
    saveas(gcf,['FIG\unsort\', 'csta','.tiff'])
end
%% Calculate OnOff Index
tau =  zeros(1,60);
Filker_OnOff_Index = ones(1,60)*-10000000;
for channelnumber=useful_channelnumber
    Filker_OnOff_Index(channelnumber) = sum(cSTA(channelnumber,round(length(cSTA)/2)-200/bin:round(length(cSTA)/2))) / sum(abs(cSTA(channelnumber, round(length(cSTA)/2)-200/bin:round(length(cSTA)/2))));
    diff_smooth_cSTA = diff(smooth(cSTA(channelnumber,:)));
    
    for l = fliplr(2:length(diff_smooth_cSTA)/2)
        if diff_smooth_cSTA(l)*diff_smooth_cSTA(l-1) < 0
            tau(channelnumber) = (length(diff_smooth_cSTA)/2-l+1)*bin;
            break
        end
    end
end
Filker_OnOff_Index (find(Filker_OnOff_Index == -10000000)) = NaN;
figure;
hist(Filker_OnOff_Index(useful_channelnumber));
xlim([-1 1])