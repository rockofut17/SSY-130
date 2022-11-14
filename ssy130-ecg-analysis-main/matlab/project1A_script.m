%Project Script 1A

%3.1

load('ath.mat');
X=linspace(0,10,5000);
noise=createdisturbance(5000,0);
ECG_pl=data(:,4,4)+noise;
subplot(1,2,1)
plot(X,data(:,4,4))
subplot(1,2,2)
plot(X,ECG_pl)

%3.3 3.4 3.5

gain=0.01;
N=5000;
M=12;
horz=linspace(0,10,5000);
z=createdisturbance(N,gain);
x0=data(:,1,1); %ECG trace
x = z + x0; %add noise
h = lmfir(@sincos,2,M,M); %create filter
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
RMS=norm(xhat(1000:end)-x0(1000:end))/sqrt(N-1000); %RMS Error






