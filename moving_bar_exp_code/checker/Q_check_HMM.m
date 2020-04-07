G_tau = [2 5 10];
dt = [0.05 0.02 0.01];
mean_lumin = 10;
corr_time =zeros(1,10);

for i = 1:3
Tot = 100;
dtau = dt(i); %step width
T = dtau:dtau:Tot;
G = G_tau(i); % damping
w = G/(2*1.06);%w = G/(2w)=1.06;
D = 4; %dynamical range
at = 30;
m = mean_lumin;
L = zeros(1,length(T));
V = zeros(1,length(T));
for t = 1:length(T)
    L(t+1) = L(t) + V(t)*dt(i);  %(th*(mu - X(t)))*dt + sqrt(dt)*randn; th = .01;  mu = 3;
    V(t+1) = (1-G*dt(i))*V(t) - w^2*L(t)*dt(i) + sqrt(dt(i)*D)*randn;
    %         V(t+1) = (1-G*dt)*V(t) - w^2*L(t)*dt + sqrt(dt*D)*noise(t);
end
L = 0.3*m*L/std(L);
temp = L-mean(L)+m;

    acf = autocorr(temp,100);
    figure(i);plot(acf);
    corr_time(i) = find(abs(acf-0.5) == min(abs(acf-0.5)));
end
corr_time