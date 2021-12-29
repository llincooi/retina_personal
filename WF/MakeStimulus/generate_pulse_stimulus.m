function [time,stimulus,a2]=generate_pulse_stimulus(signal,adInten,dt)
rate=20000;
at = 1; % s; adaptation time
Tot = length(signal)*dt;
a2t = 1; % s; time for TimeStamp indicator

ey1 = repelem(signal,1,rate*dt);

ey0 = adInten*ones(1,at*rate); % start REST
ey2 = adInten*ones(1,a2t*rate); % end REST
stimulus = [ey0 ey1 ey2];

a2 = zeros(1,length(stimulus));
a2(at*rate+1:(at+a2t)*rate)=1;
a2((Tot+at)*rate+1:(Tot+at+a2t)*rate)=1;
time = [1/rate:1/rate:length(stimulus)/rate];

end