function [BER_practice] = get_BER(Bits_RX,Bits_TX,QAM)
%GET_BER Summary of this function goes here
%   Detailed explanation goes here
BER_practice=0;
for j=1:QAM.nPol
    BER = sum((Bits_TX(j,:)-Bits_RX(j,:)).^2 ~=0) / size(Bits_TX,2);
    BER_practice=BER_practice+BER;
end
BER_practice=BER_practice/QAM.nPol;
end

