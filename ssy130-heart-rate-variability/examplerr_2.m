clear; clc; clf;
M = 3;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

NN = 8000; % Length of Data to analyze and plot
offset = 4000; %Offset into the dataset

fs = 128;

for ff = 1:Nfiles
    load(['dataB/',dd(ff).name]);
    x0 = data(offset+(1:NN),1);
    
    %Remove baseline wander
    [b,a] = butter(2,0.5/(fs/2),"high");
    x0_new = filter(b,a,x0);
    
    m0 = 0 ; % could be +- M or 0. 0 to get a smoothing filter
    % idea is that a smoothing filter can remove the bias coming from a
    % baseline. Also the filter is of order 1, making it an averaging
    % filter.
    p = 3; % number of basis functions
   
    % Here is a lmfir_diff filter designed (needs to be completed)
    h1diff = lmfir_diff(@monofun,@monoderfun,p,M,m0);
    %y1diff = filter(h1diff,1,x0_new);
    
    
    y1diff = x0; % uncomment this if directly peak-find on ECG trace.
    figure(1)
    plot([y1diff 0.1*x0_new])
    hold on
    % You need to set MPH and MPD to some good values....
    [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',0.1,'MinPeakDistance',60);
    plot(r_indices,p,'hr')
    title('RR peaks and ECG trace vs sample index')
    hold off
    
    % Calculate RR intervals
    rr = diff(r_indices);
    figure(2)
    plot(r_indices(1:end-1)/fs,(1./rr)*fs*60)
    title('Heart rate vs time')
    xlabel('time[s]')
    ylabel('BPM')
    pause

     % Task 2
    % Find Resp rate, look att FFT of data intervals
    % New try, FFT(data), plot
    x = data((1:NN),1);
    Y = fft(x);
    P = abs(Y/NN);
    Fourier = P(1:NN/2+1);
    Fourier(2:end-1) = 2*Fourier(2:end-1);
    f = fs*(0:(NN/2))/NN;

    figure(3)
    plot(f,Fourier) % Results around 0.1 Hz, = 1/t. 
    title('Frequency spectrum of ECG trace')
    xlabel('frequency')
    ylabel('Magnitude')
    
    
    % Task 3 - remove outliers
    % Threshold, plot histogram of measurment, if like gaussian, and some
    % points stand out, remove these. Histogram of RR intervals!!!
    figure(4)
    histogram(rr)
 
    
    % Task 5: Use statistical tools. Want RR intervals to be as
    % similar as poosible. Uniform distribution is optimal. Plot a histogram or other probability 
    % distribution to find mean interval. Then plot intervals over index to
    % search for pattern of when the intervals varies most.
    % over time and try to find a pattern of where 
end 

   

function f = monofun(i,m) 
    if i==0
        f = 1;
    elseif i==1
        f = m;
    elseif i>0
        f = m^i;
    else
        error('i must be a positive integer');
    end
end

function fd = monoderfun(i,m) 
    if i==0
        fd = 0;
    elseif i==1
        fd = 1;
    elseif i>1
        fd = i*(m^(i-1));
    else
        error('i must be a positive integer');
    end
end