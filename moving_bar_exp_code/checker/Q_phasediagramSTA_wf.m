close all;
clear all;
code_folder = pwd;
exp_folder = 'D:\Leo\0823exp';
cd(exp_folder);
mkdir STA
cd sort
all_file = subdir('*.mat') ; % change the type of the files which you want to select, subdir or dir.
n_file = length(all_file) ;
unit = 0;
displaychannel = 1:60;
forward = 12;%150 bins before spikes for calculating STA  %1500ms
backward = 25;%150 bins after spikes for calculating STA
SamplingRate = 20000;
frame_to_save = [16 28]; %-100ms &20ms
cd(exp_folder);
mkdir FIG
mkdir FIG phasediagram
cd FIG/phasediagram
for z =20%:n_file %choose file
    
    file = all_file(z).name ;
    [pathstr, name, ext] = fileparts(file);
    directory = [pathstr,'\'];
    filename = [name,ext];
%     if (strcmp(filename(1),'H') || strcmp(filename(1),'O'))
%     else
%         continue
%     end
    load([exp_folder, '\data\', filename])
    load([exp_folder, '\sort\', filename]);
    name=[name];
    z
    name
    bin=10;  BinningInterval = bin*10^-3;
    % put your stimulus here!!
    [b,a] = butter(2,50/20000,'low'); % set butter filter
    a_data2 = filter(b,a,a_data(1,:));
    isi = a_data2( round(TimeStamps(1)*20000) : round(TimeStamps(end)*20000) );% figure;plot(isi);
    isi = isi(1:BinningInterval*SamplingRate:length(isi));
    TheStimuli = zeros(2, length(isi));
    TheStimuli(1,:)=isi;
    TheStimuli(1,:) = (TheStimuli(1,:) - mean(TheStimuli(1,:)))/std(TheStimuli(1,:));
    isi5=diff(TheStimuli(1,:));
    TheStimuli(2,:) = ([0 isi5] + [isi5 0]) /2;
    TheStimuli(2,:) = (TheStimuli(2,:) - mean(TheStimuli(2,:)))/std(TheStimuli(2,:));
    time=[-forward :backward]*BinningInterval;
    % Binning
    BinningTime = [TimeStamps(1) : BinningInterval : TimeStamps(end)];

    
    %% BinningSpike and calculate STA
    BinningSpike = zeros(60,length(BinningTime));
    analyze_spikes = cell(1,60);
    
    complex_channel = [];
    if unit == 0
        fileID = fopen([exp_folder, '\Analyzed_data\unit_a.txt'],'r');
        formatSpec = '%c';
        txt = textscan(fileID,'%s','delimiter','\n');
        for m = 1:size(txt{1}, 1)
            complex_channel = [complex_channel str2num(txt{1}{m}(1:2))];
        end
    end
    for i = 1:60  % i is the channel number
        analyze_spikes{i} =[];
        if unit == 0
            if any(complex_channel == i)
                unit_a = str2num(txt{1}{find(complex_channel==i)}(3:end));
                for u = unit_a
                    analyze_spikes{i} = [analyze_spikes{i} Spikes{u,i}'];
                end
            else
                analyze_spikes{i} = [analyze_spikes{i} Spikes{1,i}'];
            end
        else
            for u = unit
                analyze_spikes{i} = [analyze_spikes{i} Spikes{u,i}'];
            end
        end
        analyze_spikes{i} = sort(analyze_spikes{i});
    end

    sum_n = zeros(1,60);
    phase_STD = cell(31,60); %spike-trigger-distribuion
    time_shift = [1:backward+forward+1];
    num_shift = BinningInterval;

        for k =displaychannel
        phase_STD{i,k} =[];
        analyze_spikes{k}(analyze_spikes{k}<1) = []; %remove all feild on effect
        if length(analyze_spikes{k})/ (length(TheStimuli)*BinningInterval) >1
            for i =  time_shift  %for -250ms:250ms
                for j = 1:length(analyze_spikes{k})
                    spike_time = analyze_spikes{k}(j); %s
                    RF_frame = floor((spike_time - (backward+1-i)*num_shift)*60);
                    if RF_frame > 0 && RF_frame < length(TheStimuli)
                        phace_pt = TheStimuli(: , RF_frame);
                        phase_STD{i,k} = [phase_STD{i,k} phace_pt];
                    end
                end
            end
        else
            displaychannel(displaychannel==k) = [];
        end
    end
    %%%
    %%% # of bin of stimuli = 10*10 (pos*v)
    %%% # of coutour = 4 
    %%%
%     x = (max(TheStimuli(1,:))-min(TheStimuli(1,:)))*[0.5:1:9.5]/10+min(TheStimuli(1,:));
%     y = (max(TheStimuli(2,:))-min(TheStimuli(2,:)))*[0.5:1:9.5]/10+min(TheStimuli(2,:));
    x = -2.5:0.625:2.5;
    y = -2.5:0.625:2.5;
    N_st = hist3(TheStimuli' ,'Ctrs',{x y})';
    for k =displaychannel
        for frame = frame_to_save
            figure(frame);
            %     x = linspace(min(TheStimuli(1,:)), max(TheStimuli(1,:)), 10);
            %     y = linspace(min(TheStimuli(2,:)), max(TheStimuli(2,:)), 10);
            N = hist3(phase_STD{frame,k}','Ctrs',{x y})';
            Mm = contourf(x, y, N/sum(N,  'all'), 4);
            mmm  = Mm2mmm(Mm, Mm(1,1), Mm(2,1)+2);
            contourf(x, y, N/sum(N,  'all'), mmm, 'LineColor','none'); hold on;
            colormap  winter;
            caxis([min(N_st/ sum(N_st,  'all'), [], 'all') max(N_st/ sum(N_st,  'all'), [], 'all')]);
            colorbar;
            contour(x, y, N_st/ sum(N_st,  'all'), 4, 'Color', 'k');
            title([ 'ch.',  num2str(k), ',', num2str( -round((backward+1-frame)*num_shift*1000)),'ms']);
            axis square
            %if ~isempty(find(frame_to_save == frame))
            %mkdir(['ch.',  num2str(k)])
            set(gcf,'units','normalized','outerposition',[0 0 1 1])
            set(gca,'fontsize',12); hold on
            fig =gcf;
            fig.PaperPositionMode = 'auto';
            fig.InvertHardcopy = 'off';
            saveas(fig,[name(1:end),'_ch.',  num2str(k), '_',  num2str( -round((backward+1-frame)*num_shift*1000)),'ms', '.tif'])
            %end
            close(gcf)
        end
    end
end

function mmm = Mm2mmm(Mm, mmm, x)
    mmm = [mmm Mm(1,x)] ;
    x = Mm(2, x)+x+1;
    if x > length(Mm)
        return
    end
    mmm =  Mm2mmm(Mm, mmm, x);
end
