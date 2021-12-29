function [time,stimulus,a2]=generate_stimulus(signal,mean_inten,amp,dt,upperbound)

rate=20000;
at = 10; % adaptation time
Tot = length(signal)*dt;
a2t = 1; % time for TimeStamp indicator

signal = amp*signal/std(signal);
temp = signal-mean(signal)+mean_inten; % X is the final stimuX
temp = temp(2:1:length(temp));%temp = X(2:dtau/dt:Tot/dt);
temp2=repmat(temp,rate*dt,1);
ey1 = temp2(:)';

% lowerbound = 2*mean_inten  - upperbound;
% ey1(ey1 > upperbound) = upperbound;
% ey1(ey1 < lowerbound) = lowerbound;

ey0 = mean_inten*ones(1,at*rate); % start REST
ey2 = mean_inten*ones(1,a2t*rate); % end REST
stimulus = [ey0 ey1 ey2];

a2 = zeros(1,length(stimulus));
a2(at*rate+1:(at+a2t)*rate)=1;
a2((Tot+at)*rate+1:(Tot+at+a2t)*rate)=1;
time = [1/rate:1/rate:length(stimulus)/rate];

end