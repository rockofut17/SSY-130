close all; clc;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

NN = 10000; % Length of Data to analyze and plot
offset = 4000; %Offset into the dataset

fs = 128;


for ff = 1:Nfiles
    M = 3;
    p = 3;
    m0 = M;
    load(['dataB/',dd(ff).name]);
    x0 = data(offset+(1:NN),1);

    % Task 1. Filter the baseline wander
    [b,a] = butter(3,0.6/(fs/2),"high");
    x0filtered = filter(b,a,x0);

    % Here is a lmfir_diff filter designed (needs to be completed)
    h1diff = lmfir_diff(@monofun,@monoderfun,p,M,m0);
    y1diff = filter(h1diff,1,x0filtered); 
    
%     y1diff = x0filtered; % uncomment this if directly peak-find on ECG trace.
    figure;
    plot([y1diff 0.1*x0filtered])
    hold on
    % You need to set MPH and MPD to some good values....
    MPH = 0.05; 
    MPD = 75;
    [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD);
    plot(r_indices,p,'hr')
    hold off

    % Task 2. Find EDR
    [bR,aR] = butter(3,[0.2 0.4]/(fs/2),"bandpass");
    x0Respiratory = filter(bR,aR,x0);
    figure;
    time = 0:1/fs:(length(x0)-1)/fs;
    plot(x0Respiratory)
    hold on
    [pRespiratory,resp_indices] = findpeaks(x0Respiratory,'MinPeakHeight',0,'MinPeakDistance',200);
    plot(resp_indices,pRespiratory,'hr')
    hold off

    % Calculate respiratory intervals
    respIntervals = diff(resp_indices);
    figure;
    plot(resp_indices(1:end-1)/fs,(1./respIntervals)*fs*60)
    xlabel('Time[s]'); ylabel('Breaths per minute')

    % Calculate RR intervals
    
    rr = diff(r_indices);
    rrmean = mean(rr(1:60)); % We calculate the mean of some of the samples to use it for the outliers
    % Task 3: We use neighbour data
    for i=1:length(rr)
        if rr(i)>120 && rr(i)<226 % Outliers frequencies that gives too low BPMs
            rr(i) = rrmean;
        end
    end
            
    figure;
    % Task 4
    plot(r_indices(1:end-1)/fs,(1./rr)*fs*60)
    xlabel('Time[s]'); ylabel('Beats per minute')
    pause

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
