function [out,Channel] = Chromatic_Dispersion(in,Channel,TX)
%CHROMATIC_DISPERSION Summary of this function goes here
%   Detailed explanation goes here

if TX.SIG.M==4
    K =3;
elseif TX.SIG.M==16
    K= 2;
elseif TX.SIG.M==64
    K= 1;
end

k = -K:K;
Channel.Disp_Taps=numel(k);

H = (1/TX.PARAM.sampRate)*sqrt(1/(-2*pi*1i*Channel.Beta_2*Channel.Lenght))*exp((-1j*k.^2)/(2*Channel.Beta_2*Channel.Lenght*TX.PARAM.sampRate^2));
%H = H/max(abs(H));
H=H/norm(H);
for m = 1:TX.SIG.nPol
%out(m,:) = conv(in(m,:),H,'same');
out(m,:) = filter(H,1,in(m,:));

end

%FFT
Channel.W_disp=H;
end

