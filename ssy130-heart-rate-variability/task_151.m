
clear; clc;
M = 3;
dd = dir('dataB/*.mat');
Nfiles = length(dd);

L = 11730944;
offset = 4000; %Offset into the dataset

fs = 128;
Nr_min = 18; % Number of minutes to analyse, data is to big to analyse all minutes
NN = 7680*Nr_min; 

Mean_values = zeros(4,Nr_min);
STD_values = zeros(4,Nr_min);


 for ff = 1:Nfiles
     load(['dataB/',dd(ff).name]);
     x0 = data(offset+(1:NN),1);
     %Remove baseline wander
     [b,a] = butter(2,0.5/(fs/2),"high");
     x0_new = filter(b,a,x0);
     x_matrix = reshape(x0_new,7680,[]); 

     % Input mean and std maybe
     Mean_x = zeros(Nr_min,1);
     STD_x = zeros(Nr_min,1);

     %for interval = linspace(1,L-offset,NN)
    
     for i = 1:Nr_min-1
         m0 = 0 ; 
         p = 3;
         x = x_matrix(:,i);


         % Here is a lmfir_diff filter designed (needs to be completed)
         h1diff = lmfir_diff(@monofun,@monoderfun,p,M,m0);
         y1diff = filter(h1diff,1,x);
         
         
         %y1diff = x0; % uncomment this if directly peak-find on ECG trace.
         
         % You need to set MPH and MPD to some good values....
         [p,r_indices] = findpeaks(y1diff,'MinPeakHeight',0.1,'MinPeakDistance',60);
         
         % Calculate RR intervals
         rr = diff(r_indices);

         % Could implemepent outliers algorithm here

         Mean_x(i) = mean(rr);
         STD_x(i) = std(rr);
     end
    Mean_values(ff,:) =  Mean_x;
    STD_values(ff,:) = STD_x;
 end 
figure(1)
plot(Mean_values');
title('Mean values')
xlabel('minutes')
figure(2)
plot(STD_values')  
title('Standards deviations')
xlabel('minutes')
 
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
