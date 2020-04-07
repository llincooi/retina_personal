%by guessing, needed to learn more to comfirm
%https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1001052
clear all;
load('D:\0930v\videoworkspace\0421_HMM_Dark_RL_G4.5_7min_Br50_Q100.mat')
fps =60;
tau = 60; %has to be zero now
x = newXarray;
y = newXarray;
% x = 1:3;
% y = 1:3;

StimuSN =10;

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
isii2 = (StimuSN+1)*(isix2-1) + isiy2;
MI = 0;
for k = unique(isix2)
    for j =unique(isiy2)
        pi = length(find(isii2 ==  (StimuSN+1)*(k-1) + j))/length(isii2);
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
Hx_A = zeros(2^(StimuSN-1)-1-StimuSN,1);
Hx_B = zeros(2^(StimuSN-1)-1-StimuSN,1);
norm_I_eff = zeros(2^(StimuSN-1)-1-StimuSN,1);
for m = 1:counter
    isix2 = isix;
    isix3 = isix;
    isiy2 = isiy;
    isiy3 = isiy;
    isix2(ismember(isix, B{m})) = 0;
    isiy2(ismember(isiy, B{m})) = 0;
    isix3(ismember(isix, A{m})) = 0;
    isiy3(ismember(isiy, A{m})) = 0;
    isii2 = (StimuSN+1)*(isix2-1) + isiy2;
    isii3 = (StimuSN+1)*(isix3-1) + isiy3;
    isix2(find(isix2 == 0)) = [];
    isiy2(find(isiy2 == 0)) = [];
    isix3(find(isix3 == 0)) = [];
    isiy3(find(isiy3 == 0)) = [];
    Null_index = [-1*(0:(StimuSN+1)) (StimuSN+1)*(1:(StimuSN-2))];
    isii2(ismember(isii2, Null_index)) = [];
    isii3(ismember(isii3, Null_index)) = [];
    for k = A{m}
        for j = A{m}
            pi2 = length(find(isii2 ==  (StimuSN+1)*(k-1) + j))/length(isii2);
            px2 = length(find(isix2 == k))/length(isix2 );
            py2 = length(find(isiy2 == j))/length(isiy2 );
            if pi2 == 0
                break
            end
            MI_A(m) = MI_A(m) + pi2*log2(pi2/px2/py2)*fps;%bits/s
        end
        Hx_A(m) = Hx_A(m) - px2*log2(px2);
    end
    for k = B{m}
        for j =B{m}
            pi3 = length(find(isii3 ==  (StimuSN+1)*(k-1) + j))/length(isii3);
            px3 = length(find(isix3 == k))/length(isix3 );
            py3 = length(find(isiy3 == j))/length(isiy3 );
            if pi3 == 0
                break
            end
            MI_B(m) = MI_B(m) + pi3*log2(pi3/px3/py3)*fps;%bits/s
        end
        Hx_B(m) = Hx_B(m) - px3*log2(px3);
    end
    norm_I_eff(m) = (MI - MI_A(m) - MI_B(m))/min(Hx_A(m),Hx_B(m));
end
[normII mib_index] = min(norm_I_eff);
II = normII*min(Hx_A(mib_index),Hx_B(mib_index))
mib_index
A_min = A{mib_index};
B_min = B{mib_index};