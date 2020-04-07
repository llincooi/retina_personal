clear all;
load('D:\0930v\videoworkspace\0421_HMM_Dark_RL_G4.5_7min_Br50_Q100.mat')
fps =60;
x = newXarray;
v = diff(newXarray);
v = ([0 v] + [v 0]) /2;

StimuSN = 25;

nX=sort(x);
abin=length(nX)/StimuSN;
intervals=[nX(1:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isi2=[];
for jj=1:length(x)
    isix(jj) = find(x(jj)<intervals,1)-1;
end

nX=sort(v);
abin=length(nX)/StimuSN;
intervals=[nX(1:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isi2=[];
for jj=1:length(v)
    isiv(jj) = find(v(jj)<intervals,1)-1;
end

isii = StimuSN*(isix-1) + isiv;

MI = zeros(1,2*length(newXarray)-1);
%v in future; x in past
for n =1:length(newXarray)
    isix2 = isix(n:end);
    isiv2 = isiv(1:end+1-n);
    isii2 = StimuSN*(isix2-1) + isiv2;
    for k = unique(isix2)
        for j =unique(isiv2)
            pi = length(find(isii2 ==  StimuSN*(k-1) + j))/length(isii2);
            px = length(find(isix2 == k))/length(isix2 );
            pv = length(find(isiv2 == j))/length(isiv2 );
            MI(n+length(newXarray)-1) = MI(n+length(newXarray)-1) + pi*log2(pi/px/pv)*fps;%bits/s
        end
    end
end
%x in future; v in past
for n =2:length(newXarray)
    isix2 = isix(1:end+1-n);
    isiv2 = isiv(n:end);
    isii2 = StimuSN*(isix2-1) + isiv2;
    for k = unique(isix2)
        for j =unique(isiv2)
            pi = length(find(isii2 ==  StimuSN*(k-1) + j))/length(isii2);
            px = length(find(isix2 == k))/length(isix2 );
            pv = length(find(isiv2 == j))/length(isiv2 );
            MI(length(newXarray)+1 - n) = MI(length(newXarray)+1 - n) + pi*log2(pi/px/pv)*fps;%bits/s
        end
    end
end
time = (-length(newXarray)+1:length(newXarray)-1)/fps;
plot(time, MI);
