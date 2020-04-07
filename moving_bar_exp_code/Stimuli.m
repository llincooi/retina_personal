function isi2 = Stimuli(type, BinningInterlval, bin_pos)
% Binning
bin=BinningInterval*10^3; %ms
% put your stimulus here!!
elseif strcmp(type,'abs')
    TheStimuli= bin_pos;
    StimuSN=30; %number of stimulus states
    nX=sort(TheStimuli,2);
    abin=length(nX)/StimuSN;
    isi2 = zeros(60,length(TheStimuli));
    for k = 1:60
        if sum(absolute_pos(k,:))>0
            intervals=[nX(k,1:abin:end) inf]; % inf: the last term: for all rested values
            for jj=1:length(TheStimuli)
                isi2(k,jj) = find(TheStimuli(k,jj)<=intervals,1);
            end
        end
    end
elseif strcmp(type,'pos')
    TheStimuli=bin_pos;
elseif strcmp(type,'v')
    TheStimuli=diff(bin_pos);
    TheStimuli = ([0 TheStimuli] + [TheStimuli 0]) /2;
end
StimuSN=30; %number of stimulus states

nX=sort(TheStimuli);
abin=length(nX)/StimuSN;
intervals=[nX(1:abin:end) inf]; % inf: the last term: for all rested values
isi2=[];
for jj=1:length(TheStimuli)
    isi2(jj) = find(TheStimuli(jj)<=intervals,1);
end




end