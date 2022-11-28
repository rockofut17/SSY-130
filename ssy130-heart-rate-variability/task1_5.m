close all; clc;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

nMin = 10;
NN = 7680*nMin; % Length of Data to analyze and plot
offset = 4000; %Offset into the dataset

fs = 128;
allMeans = zeros(4,nMin);
allSd = zeros(4,nMin);

for ff = 1:Nfiles
    load(['dataB/',dd(ff).name]);
    x0 = data(offset+(1:NN),1); % To analyze all the data, not NN 
    R = reshape(x0,7680,[]);

%     numberMinutes = round(length(x0)/7680); 
    onePersonMean = zeros(nMin,1);
    onePersonSd = zeros(nMin,1);

    for i = 1:nMin%numberMinutes-1
        M = 3;
        p = 3;
        m0 = M;
%         x = x0(((i-1)*7680)+1:i*7680);
        x = R(:,i);

        % Filter the baseline wander
        [b,a] = butter(3,0.6/(fs/2),"high");
        x0filtered = filter(b,a,x);
    
        % Here is a lmfir_diff filter designed (needs to be completed)
        h1diff = lmfir_diff(@monofun,@monoderfun,p,M,m0);
        y1diff = filter(h1diff,1,x0filtered); 
        
    %     y1diff = x0filtered; % uncomment this if directly peak-find on ECG trace.
%         figure;
%         plot([y1diff 0.1*x0filtered])
%         hold on
        % You need to set MPH and MPD to some good values....
        MPH = 0.05; 
        MPD = 75;
        [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',MPH,'MinPeakDistance',MPD);
%         plot(r_indices,p,'hr')
%         hold off

        % Calculate RR intervals
        
        rr = diff(r_indices);
        rrmean = mean(rr); % We calculate the mean to use it for the outliers
        % Task 3: We use neighbour data
        for j=1:length(rr)
            if rr(j)>120 % Outliers frequencies that gives too low BPMs
                rr(j) = rrmean;
            end
        end

        onePersonMean(i) = rrmean;
        onePersonSd(i) = std(rr);
                
%         figure;
        % Task 4
%         plot(r_indices(1:end-1)/fs,(1./rr)*fs*60)
%         xlabel('Time[s]'); ylabel('Beats per minute')
%         pause
    end

    allMeans(ff,:) = onePersonMean;
    allSd(ff,:) = onePersonSd;

end 

figure; plot(allMeans'); legend('Athlete 1','Athlete 2','Athlete 3','Athlete 4'); ylabel('Mean BPM'); xlabel('Time[min]')
figure; plot(allSd'); legend('Athlete 1','Athlete 2','Athlete 3','Athlete 4'); ylabel('Standard deviation BPM'); xlabel('Time[min]')

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
