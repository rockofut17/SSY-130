function [heart_rate] = fbpm_berlanga(x,fs)
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

% Find maximum magnitude and index
%Mag_int = Mag(6:33);
[mval,idx] = max(Mag(7:33));
idx = idx + 7; 

heart_rate = 60*(idx-1)/(Ndtft/fs);
end
