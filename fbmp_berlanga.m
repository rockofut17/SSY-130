function [heart_rate,mval] = fbmp(x,fs)
% start with w(n) = 1
Ndtft = length(x);
w = ones(Ndtft,1) ;
% Make DTFT
Xw = fft(w.*x,Ndtft);
% Get magnitude
Mag_Xw = abs(Xw);
Mag = Mag_Xw(1:Ndtft/2+1);  % from matlab description of fft
Mag(2:end-1) = 2*Mag(2:end-1); % -//-

%tp = 1/fs; % sample period
%time_vec = (0:Ndtft-1)*tp ;

% Find maximum value, but first choose interval
%Iset = Mag > 6 & Mag < 33; % Returns indices
% Find maximum magnitude and index
[mval,idx] = max(Mag(6:33));
% tänk på index
heart_rate = 60*(idx-1)/10;

 % 10 kommer från 5000/500
end