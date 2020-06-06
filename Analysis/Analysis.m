function [BER_practice,MI,SNR,H_X,H_Y,Signal,DSP] = Analysis(Signal,TX,DSP,Channel)
%ANALYSIS Summary of this function goes here
%   Detailed explanation goes here

%% BER Calculation
Symbols_Analysis=Signal.Symbols_DSP;
BER_MIN=1;

Symbols_Decoded= signal2symbol(Symbols_Analysis,TX.QAM);
if TX.QAM.Probabilistic_Shaping==1 && TX.QAM.M==64
    TX.QAM.nBitsInfo = TX.QAM.nBitsInfo - (DSP.Truncating+DSP.Equaliser_Bottom)*TX.QAM.nBpS - (DSP.Truncating+DSP.Equaliser_Top)*TX.QAM.nBpS; 
    Bits_Decoded=ccdm.decode(Symbols_Decoded.',TX.QAM.symFreq,TX.QAM.nBitsInfo);
else
    Bits_Decoded=sym2bit(Symbols_Decoded,TX.QAM);
end

if Channel.SSFT==1 || Channel.Chromatic_Dispersion==1
    [BER_practice,Bits_Decoded,Symbols_Decoded,Symbols_TX_truncated,DSP]=get_BER_redundacy(Symbols_Analysis,Signal.Bits_TX{1},Signal.Symbols_TX{1},TX.QAM,DSP,50,40);
    Signal.Symbols_TX_truncated=Symbols_TX_truncated;
else
    BER_practice=get_BER(Bits_Decoded,Signal.Bits_TX{1},TX.QAM);
    Signal.Symbols_TX_truncated=Signal.Symbols_TX{1};
end

Signal.Symbols_RX= Symbols_Decoded;
Signal.Bits_RX=Bits_Decoded;



%% Mutual Information:
[MI,SNR,H_X,H_Y]=Mutual_Information(Signal.Symbols_DSP,Signal.Symbols_TX_truncated,TX.QAM.M,TX.QAM.IQmap,TX.QAM.sym2bitMap);
%MI=0;
%H_X=0;
%H_Y=0;
end

