clear all;
load('D:\0930v\videoworkspace\0421_HMM_Dark_RL_G4.5_7min_Br50_Q100.mat')
fps =60;
tau = 60; %has to be zero now
x = newXarray;
y = newXarray;
% x = 1:3;
% y = 1:3;

StimuSN =5;

nX=sort(x);
abin=length(nX)/StimuSN;
intervals=[nX(1:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isi2=[];
for jj=1:length(x)
    isix(jj) = find(x(jj)<intervals,1)-1;
end
isix = isix(1:end-tau);

nX=sort(y);
abin=length(nX)/StimuSN;
intervals=[nX(1:abin:end) inf]; % inf: the last term: for all rested values
temp=0; isi2=[];
for jj=1:length(y)
    isiy(jj) = find(y(jj)<intervals,1)-1;
end
isiy = isiy(1+tau:end);

isix2 = isix;
isiy2 = isiy;
isii2 = StimuSN*(isix2-1) + isiy2;
MI = 0;
for k = unique(isix2)
    for j =unique(isiy2)
        pi = length(find(isii2 ==  StimuSN*(k-1) + j))/length(isii2);
        px = length(find(isix2 == k))/length(isix2 );
        py = length(find(isiy2 == j))/length(isiy2 );
        if pi == 0
            break
        end
        MI = MI + pi*log2(pi/px/py)*fps;%bits/s
    end
end

A = cell(2^(StimuSN-1)-1-StimuSN,1);
B = cell(2^(StimuSN-1)-1-StimuSN,1);
counter = 1;
for n = 2:floor(StimuSN/2)
    a = nchoosek(1:StimuSN,n);
    for nn = 1:size(a, 1)
        A{counter} = a(nn,:);
        b = 1:StimuSN;
        b(a(nn,:)) = [];
        B{counter} = b;
        if counter == 2^(StimuSN-1)-1-StimuSN
            break
        end
        counter = counter+1;
    end
end

MI_A = zeros(2^(StimuSN-1)-1-StimuSN,1);
MI_B = zeros(2^(StimuSN-1)-1-StimuSN,1);
norm_I_eff = zeros(2^(StimuSN-1)-1-StimuSN,1);
for m = 1:counter
    isix2 = isix(ismember(isix, A{m}));
    isiy2 = isiy(ismember(isiy, A{m}));
    isix3 = isix(ismember(isix, B{m}));
    isiy3 = isiy(ismember(isiy, B{m}));
    isii2 = StimuSN*(isix2-1) + isiy2;
    isii3 = StimuSN*(isix3-1) + isiy3;
    for k = unique(isix2)
        for j =unique(isiy2)
            pi2 = length(find(isii2 ==  StimuSN*(k-1) + j))/length(isii2);
            px2 = length(find(isix2 == k))/length(isix2 );
            py2 = length(find(isiy2 == j))/length(isiy2 );
            if pi2 == 0
                break
            end
            MI_A(m) = MI_A(m) + pi2*log2(pi2/px2/py2)*fps;%bits/s
        end
    end
    for k = unique(isix3)
        for j =unique(isiy3)
            pi3 = length(find(isii3 ==  StimuSN*(k-1) + j))/length(isii3);
            px3 = length(find(isix3 == k))/length(isix3 );
            py3 = length(find(isiy3 == j))/length(isiy3 );
            if pi3 == 0
                break
            end
            MI_B(m) = MI_B(m) + pi3*log2(pi3/px3/py3)*fps;%bits/s
        end
    end
    norm_I_eff(m) = (MI - MI_A(m) - MI_B(m))/min(MI_A(m),MI_B(m));
end
[normII mib_index] = min(norm_I_eff);
II = normII*min(MI_A(mib_index),MI_B(mib_index));