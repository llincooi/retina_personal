function MI = LeoMIfunc(isiv,isix,backward,forward,fps)

MI = zeros(1,backward+forward+1);
StimuSN = max([isix isiv]);
%v in future; x in past
for n =1:forward+1
    isix2 = isix(n:end);
    isiv2 = isiv(1:end+1-n);
    isii2 = StimuSN*(isix2-1) + isiv2;
    for k = unique(isix2)
        for j =unique(isiv2)
            pi = length(find(isii2 ==  StimuSN*(k-1) + j))/length(isii2);
            px = length(find(isix2 == k))/length(isix2 );
            pv = length(find(isiv2 == j))/length(isiv2 );
            MI(n+backward) = MI(n+backward) + pi*log2(pi/px/pv)*fps;%bits/s
        end
    end
end
%x in future; v in past
for n =1:backward
    isix2 = isix(1:end+1-n);
    isiv2 = isiv(n:end);
    isii2 = StimuSN*(isix2-1) + isiv2;
    for k = unique(isix2)
        for j =unique(isiv2)
            pi = length(find(isii2 ==  StimuSN*(k-1) + j))/length(isii2);
            px = length(find(isix2 == k))/length(isix2 );
            pv = length(find(isiv2 == j))/length(isiv2 );
            MI(backward+1 - n) = MI(backward+1 - n) + pi*log2(pi/px/pv)*fps;%bits/s
        end
    end
end

end