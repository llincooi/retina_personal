clear all;
cd \\192.168.0.100\Experiment\Retina\2020Videos\0219v\videoworkspace
all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ;
for z = 1:n_file
    Adding_Work_space(all_file(z).name)
end

function Adding_Work_space(name)
load(name);
% series_type
if contains(name,'HMM')
    series_type = 'HMM';
elseif contains(name,'OU')
    series_type = 'OU';
elseif contains(name,'OUsmooth')
    series_type = 'OUsmooth';
elseif contains(name,'Reversal')
    series_type = 'Reversal';
elseif contains(name,'cSTA')
    series_type = 'cSTA';
end
%stimulation type
if contains(name, 'Checker')
    stimulation_type = 'Checker';
elseif contains(name, 'Grating')
    stimulation_type = 'Grating';
elseif contains(name, 'OnOff')
    stimulation_type = 'OnOff';
elseif contains(name, 'Edge')
    stimulation_type = 'Edge';
elseif contains(name, 'wf') || contains(name, 'Intensity')
    stimulation_type = 'WF';
elseif contains(name, 'saccade')
    stimulation_type = 'saccade';
else
    stimulation_type = 'Bar';
end


if contains(name,'0224') || contains(name,'0225')
    % direction and theta
    if contains(name,'RL')
        direction = 'RL';
        theta = 0;
    elseif contains(name,'UD')
        direction = 'UD';
        theta = pi/2;
    elseif contains(name,'UR_DL')
        direction = 'UR_DL';
        theta = pi*3/4;
    elseif contains(name,'UL_DR')
        direction = 'UL_DR';
        theta = pi/4;
    end
    % mean_lumin
    if contains(name,'6.5mW')
        mean_lumin = 6.5;
    elseif contains(name,'10mW')
        mean_lumin = 10;
    elseif contains(name,'13mW')
        mean_lumin = 13;
    end
    %Dark
    if contains(name, 'Dark')
        Dark = 'Dark';
    elseif contains(name, '2nd')
        Dark = '2nd';
    end
    
elseif contains(name,'06')
    clearvars type
end
save([name], '-regexp',  '^(?!(name)$).')
end