function [heart_rate] = fbpm(x,fs)
% start with w(n) = 1
Ndtft = length(x);
w = ones(Ndtft,1) ;
% w = chebwin(64)
% w = gausswin(64)
% Make DTFT
Xw = fft(w.*x,Ndtft);
% Get magnitude
Mag_Xw = abs(Xw);
Mag = Mag_Xw(1:Ndtft/2+1);  % from matlab description of fft
Mag(2:end-1) = 2*Mag(2:end-1); % -//-

% Find maximum magnitude and index. Since index represent frequency we could calculate frequency range from the heart rate interval 35-200.

[mval,idx] = max(Mag(7:33));
idx = idx + 7; % Have to take + 7 because otherwhise index 7 will become index 1 in the new vector.

heart_rate = 60*(idx-1)/(Ndtft/fs);
end
