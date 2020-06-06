function [out] = SSFT(in,Channel,TX)
%SSFT Summary of this function goes here
%   Detailed explanation goes here
h=1;
Signal=in.';

% for L=1:h:Channel.Lenght
% L
% %Calculating Linear and Non-Linear Term
% Non_Linear_Term =exp(-1i*h*Channel.Gamma*abs(Signal).^2);  
% Linear_Term = exp(-(1i*Channel.Beta_2* (TX.PARAM.w.').^2+Channel.Alpha*ones(size(TX.PARAM.w.')))*h/2);
% 
% % Apply SSFT
% Fourier_Signal =fft(Signal.*Non_Linear_Term);
% Signal =ifft(Fourier_Signal.*Linear_Term);
% 
% 
% %Amplyfying by 20dB
% if rem(L,Channel.Amplifier_Spacing)==0
%     Signal =Signal * 100;
% end
% end

Signal=ifft(fft(Signal).*exp(-1i*Channel.Beta_2* (TX.PARAM.w.').^2*Channel.Lenght/2));
%Signal = ifft(fft(Signal).*exp(1i*Channel.Beta_2* (TX.PARAM.w.').^2*Channel.Lenght/2));
out=Signal.';

