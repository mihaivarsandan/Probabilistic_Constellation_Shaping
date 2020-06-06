function [out,DSP] = Static_Equaliser(symbols,Channel,TX,DSP)
%STATIC_EQUALISER Summary of this function goes here
%   Detailed explanation goes here
M=floor(pi*abs(Channel.Beta_2)*Channel.Lenght*TX.PARAM.sampRate^2);
N=2*M+1;
k = -M:1:M;
H = ( 1/(TX.PARAM.sampRate * sqrt(-1i*2*pi*Channel.Beta_2*Channel.Lenght)) )*exp(-(1i*k.^2) * 1/(TX.PARAM.sampRate^2 * 2*Channel.Beta_2*Channel.Lenght));
H = H./1.2;
%fvtool(H)
H_filter = [H , zeros(1,N)];
num=rem(size(symbols,2),2*N);
in = [symbols, zeros(size(symbols,1),(2*N-num)+N)];
out= zeros(size(in)-N);
H_fft = fft(H_filter);
for j=0:N:size(in,2)-2*N
    values = ifft(H_fft.*fft(in(j+1:1:j+2*N)));
    out(j+1:1:j+N)= values(N+1:end); 
end
out=out(1:end-(2*N-num));

out=out(2*N+1:end-2*N);
DSP.Static_Equal_H=H;
DSP.Truncating=DSP.Truncating+N;
if rem(M,2)==0
    DSP.Equaliser_Top = M/2;
    DSP.Equaliser_Bottom = M/2+1;
else
    DSP.Equaliser_Top = (M+1)/2;
    DSP.Equaliser_Bottom= (M+1)/2;
end
out=out(1:end-2*M-1);


end
