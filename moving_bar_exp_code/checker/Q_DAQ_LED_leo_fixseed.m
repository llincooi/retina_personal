    stimu == 'hm'
%     load('G:\Rona\noise\normalnoise.mat');
    G_tau = 3;
    mean_lumin = 10;
    rate = 10000;
    Tot = 300;  
    dt = 50*10^-3; 
    dtau = 50*10^-3; %step width 
    T = dtau:dtau:Tot;
    G = G_tau; % damping  
    w = G/(2*1.06);%w = G/(2w)=1.06;  
    D = 4; %dynamical range
    at = 30;
%     r = 0.14;%if G= 10 normal r =0.1
    m = mean_lumin;

    a2=[];ey=[];ey1=[];
    for i = 1:length(newXarray)/3
        temp(i) = newXarray(i*3) +newXarray(i*3-1) +newXarray(i*3-2);
    end
    temp = 0.3*m/std(temp)*temp;
    temp = temp-mean(temp)+m; % X is the final stimuX
    X = temp;
    X(X > 1.95*mean_lumin) = 1.95*mean_lumin;
    X(X < 0.05*mean_lumin) = 0.05*mean_lumin;
    std(X)/m
    temp2=repmat(X,rate*dtau,1);
    %temp2 = interp1(newXarray,1:Tot*rate/length(newXarray):Tot*rate,1:length(newXarray),'spline');
    ey1=temp2(:)';

    ey0=m*ones(1,at*rate);%REST
    ey=[ey0 ey1];
    a2=zeros(1,length(ey));
    a2(at*rate:(at+1)*rate)=1;
    a2((Tot+at-1)*rate:(Tot+at)*rate)=1;

    t=[1/rate:1/rate:length(ey1)/rate];
    figure(1);plot(ey1);hold on
    plot(newXarray)
    ss = ['_HMM_G=',num2str(G),'_'];

    
    
    acf = autocorr(newXarray,100);
    corr_time = find(abs(acf-0.5) == min(abs(acf-0.5)))/60
        acf = autocorr(ey1,round(100/60*10000));
        plot(acf)
    corr_time = find(abs(acf-0.5) == min(abs(acf-0.5)))/10000