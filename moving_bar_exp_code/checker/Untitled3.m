close all
t = 0:0.001:1;
sig = sin(2*pi*10*t) + sin(2*pi*20*t);
plot(t,sig)
[b, a]=butter(10, 15*0.001*2, 'low'); %Butterworth filter
filtered = filter(b, a, sig);
figure; hold on;
plot(t,sin(2*pi*10*t))
plot(t,filtered)