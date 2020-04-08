% clear all;
%  analyze_spikes = reconstruct_spikes;
analyze_spikes = [Spikes(1,:) Spikes(2,:) Spikes(3,:)];

% TheStimuli=bin_pos;

for channelnumber = [30]
    SamplingRate=20000;
    bin=10;  BinningInterval = bin*10^-3;
    [b,a] = butter(2,50/20000,'low'); % set butter filter
    a_data2 = filter(b,a,a_data(1,:));
    isi = a_data2(TimeStamps(1)*20000:TimeStamps(length(TimeStamps))*20000);% figure;plot(isi);
    isi2=[];
        states=25;
        X=isi;
        nX = sort(X);
        abin = length(nX)/states;
        intervals = [nX(1:abin:end) inf];
        temp=0;
        for jj = 1:BinningInterval*SamplingRate:length(X)
            temp=temp+1;
            isi2(temp) = find(X(jj)<intervals,1)-1; % stimulus for every 50ms
        end
    %recalculated bar position
    %
    
    %
    % analyze_spikes{31} = [];
    drop = 1;
    
    if drop == 1
        for i = 1:60
            spike = analyze_spikes{i}.*0.001;
            
            inter = diff(spike);
            pre = inter(1:end-1);
            post = inter(2:end);
            null_index=[];
            for j = 2:length(inter)-1
                if pre(j) >= 0.0002 || post(j) >= 0.0002
                    null_index = [ null_index j+1];
                end
            end
            analyze_spikes{i}(null_index) = [];
            
            %     scatter(pre,post);hold on;
            %     xlabel('pre isi(sec)');ylabel('post isi(sec)');
            %     set(gca,'xscale','log')
            %     set(gca,'yscale','log')
        end
    end
    
    % velocity
    % HMM
    % for i=1:length(newXarray)-1
    %     v(i)=(newXarray(i+1)-newXarray(i))/17; %17ms
    % end
    % TheStimuli= v;
    
    %OU
    % for i=1:length(new_y)-1
    %     v(i)=(new_y(i+1)-new_y(i))/17; %17ms
    % end
    % TheStimuli= v;
    
    
    % Binning
    bin=BinningInterval*10^3; %ms
    BinningTime =[0:BinningInterval:TimeStamps(end)-TimeStamps(1)];
    
    
    %% cut Stimulus State _ equal probability of each state (different interval range)
    %figure; hist(isi2,StimuSN);%     StimuSN=30; %number of stimulus states
    %     nX=sort(TheStimuli);
    %     abin=length(nX)/StimuSN;
    %     intervals=[nX(1:abin:end) inf]; % inf: the last term: for all rested values
    %     temp=0; isi2=[];
    %     for jj=1:length(TheStimuli)
    %         temp=temp+1;
    %         isi2(temp) = find(TheStimuli(jj)<=intervals,1);
    %     end
    
    % title(name);
    
    %% BinningSpike
    BinningSpike = zeros(60,length(BinningTime));
    for i = 1:60  % i is the channel number
        [n,~] = hist(analyze_spikes{i},BinningTime) ;  %yk_spikes is the spike train made from"Merge_rePos_spikes"
        BinningSpike(i,:) = n ;
    end
    
    %% Predictive information
    backward=ceil(15000/bin);
    forward=ceil(15000/bin);
    n = channelnumber;
    Neurons = BinningSpike(n,:);  %for single channel
    %Neurons = sum(BinningSpike(1:60,:));  %calculate population MI
    
    % Neurons=isi2;
    
    dat=[];informationp=[];temp=backward+2;
    for i=1:backward+1 %past(t<0)
        x=Neurons((i-1)+forward+1:length(Neurons)-backward+(i-1))';
        y=isi2(forward+1:length(isi2)-backward)';
        dat{i}=[x,y];
        %       norm = sum(x)/ length(x); %normalize: bits/spike
        norm = BinningInterval; %bits/second
        
        [N,C]=hist3(dat{i},[max(Neurons)+1,max(isi2)]); %20:dividing firing rate  6:# of stim
        px=sum(N,1)/sum(sum(N)); % x:stim
        py=sum(N,2)/sum(sum(N)); % y:word
        pxy=N/sum(sum(N));
        temp2=[];
        for j=1:length(px)
            for k=1:length(py)
                temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2)/norm;
            end
        end
        temp=temp-1;
        informationp(temp)=nansum(temp2(:));
        corrp(temp)=sum(x.*y);
    end
    
    dat=[];informationf=[];temp=0;sdat=[];
    for i=1:forward
        x = Neurons(forward+1-i:length(Neurons)-backward-i)';
        y = isi2(forward+1:length(isi2)-backward)';
        dat{i}=[x,y];
        %       norm = sum(x)/ length(x); %normalize: bits/spike
        norm = BinningInterval; %bits/second
        
        [N,C]=hist3(dat{i},[max(Neurons)+1,max(isi2)]); %20:dividing firing rate  6:# of stim
        px=sum(N,1)/sum(sum(N)); % x:stim
        py=sum(N,2)/sum(sum(N)); % y:word
        pxy=N/sum(sum(N));
        temp2=[];
        for j=1:length(px)
            for k=1:length(py)
                temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2)/norm;
            end
        end
        temp=temp+1;
        informationf(temp)=nansum(temp2(:));
        corrf(temp)=sum(x.*y);
    end
    
    information=[informationp informationf];
    
    %% shuffle MI
    sNeurons=[];
    r=randperm(length(Neurons));
    for j=1:length(r)
        sNeurons(j)=Neurons(r(j));
    end
    Neurons_shuffle=sNeurons;
    
    dat=[];information_shuffle_p=[];temp=backward+2;
    for i=1:backward+1 %past(t<0)
        x=Neurons_shuffle((i-1)+forward+1:length(Neurons_shuffle)-backward+(i-1))';
        y=isi2(forward+1:length(isi2)-backward)';
        dat{i}=[x,y];
        %       norm = sum(x)/ length(x); %normalize
        norm = BinningInterval;
        
        [N,C]=hist3(dat{i},[max(Neurons_shuffle)+1,max(isi2)]); %20:dividing firing rate  6:# of stim
        px=sum(N,1)/sum(sum(N)); % x:stim
        py=sum(N,2)/sum(sum(N)); % y:word
        pxy=N/sum(sum(N));
        temp2=[];
        for j=1:length(px)
            for k=1:length(py)
                temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2)/norm;
            end
        end
        temp=temp-1;
        information_shuffle_p(temp)=nansum(temp2(:));
        corrp(temp)=sum(x.*y);
    end
    
    dat=[];information_shuffle_f=[];temp=0;sdat=[];
    for i=1:forward
        x = Neurons_shuffle(forward+1-i:length(Neurons_shuffle)-backward-i)';
        y = isi2(forward+1:length(isi2)-backward)';
        dat{i}=[x,y];
        %       norm = sum(x)/ length(x); %normalize
        norm = BinningInterval;
        
        [N,C]=hist3(dat{i},[max(Neurons_shuffle)+1,max(isi2)]); %20:dividing firing rate  6:# of stim
        px=sum(N,1)/sum(sum(N)); % x:stim
        py=sum(N,2)/sum(sum(N)); % y:word
        pxy=N/sum(sum(N));
        temp2=[];
        for j=1:length(px)
            for k=1:length(py)
                temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2)/norm;
            end
        end
        temp=temp+1;
        information_shuffle_f(temp)=nansum(temp2(:));
        corrf(temp)=sum(x.*y);
    end
    
    information_shuffle=[information_shuffle_p, information_shuffle_f];
    
    
    time=[-backward*bin:bin:forward*bin];
    plot(time,information); hold on; %,'color',cc(z,:));hold on
    %plot(time,smooth(information_shuffle));
end
% hist(isi2, 25);
% hist(isi3(2,:));
% scatter(TheStimuli(1,:), TheStimuli(2,:));
% N = hist3(TheStimuli');
% imagesc(N)