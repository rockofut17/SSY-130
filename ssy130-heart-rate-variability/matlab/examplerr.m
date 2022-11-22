M = 3;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

NN = 8000; % Length of Data to analyze and plot
offset = 4000; %Offset into the dataset

fs = 128;

for ff = 1:Nfiles
    load(['dataB/',dd(ff).name]);
    x0 = data(offset+(1:NN),1);

    % Here is a lmfir_diff filter designed (needs to be completed)
    % h1diff = lmfir_diff(@monofun,@monoderfun, .....);
    % y1diff = filter(h1diff,1,x0);
    
    
    y1diff = x0; % uncomment this if directly peak-find on ECG trace.
    figure(1)
    plot([y1diff 0.1*x0])
    hold on
    % You need to set MPH and MPD to some good values....
    [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD);
    plot(r_indices,p,'hr')
    hold off
    
    % Calculate RR intervals
    rr = diff(r_indices);
    figure(2)
    plot(r_indices(1:end-1)/fs,(1./rr)*fs*60)
    pause
end 

function f = monofun(i,m) 
    if i==0
        f = 1;
    elseif i==1;
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
