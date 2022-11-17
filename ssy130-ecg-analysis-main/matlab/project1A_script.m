%Project Script 1A

%3.1

load('ath.mat');
X=linspace(0,10,5000);
noise=createdisturbance(5000,0);
ECG_pl=data(:,4,4)+noise;
subplot(1,2,1)
plot(X,data(:,4,4))
xlabel('Time(s)')
ylabel('Amplitude')
title('Unfiltered ECG Signal')
subplot(1,2,2)
plot(X,ECG_pl)
xlabel('Time (s)')
ylabel('Amplitude')
title('ECG Signal with noise')

%3.3 3.4 3.5 3.6

gain=0;
N=5000;
M=200;
horz=linspace(0,10,5000);
z=createdisturbance(N,gain);
x0=data(:,1,1); %ECG trace
x = z + x0; %add noise
lam=0.95; %add lam for window
h = lmfir(@sincos,2,M,M,lam); %create filter
zhat = filter(h,1,x); %filter out noise
xhat = x - zhat;
figure;
subplot(1,2,1)
plot(horz,xhat) %cleaned signal
title('Cleaned Signal')
xlabel('Time (s)')
ylabel('Amplitude')
subplot(1,2,2)
plot(horz,xhat-x0) %remaining error
title('Remaining Error')
xlabel('Time (s)')
ylabel('Amplitude')
norm(xhat(1000:end)-x0(1000:end))/sqrt(N-1000) %print RMS Error






