function H = Shannon_Entropy(seire, StimuSN)
H = 0;
seire =  seire +1-min(seire);
for k = unique(seire)
    p = length(find(seire == k))/length(seire);
    H = H-p*log2(p);
end
end