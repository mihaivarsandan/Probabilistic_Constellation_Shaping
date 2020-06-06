function [BER_practice,Bits_RX_true,Symbols_RX_true,Symbols_TX_truncated,DSP] = get_BER_redundacy(Symbols_RX_Complex,Bits_TX,Symbols_TX,QAM,DSP,L,U)
%GET_BER_REDUNDACY Summary of this function goes here
%   Detailed explanation goes here
Bits_TX=Bits_TX(:,(DSP.Truncating+DSP.Equaliser_Bottom)*QAM.nBpS+1:end-(DSP.Truncating+DSP.Equaliser_Top)*QAM.nBpS);
Symbols_TX_truncated=Symbols_TX(:,(DSP.Truncating+DSP.Equaliser_Bottom)+1:end-(DSP.Truncating+DSP.Equaliser_Top));
if QAM.Probabilistic_Shaping==1 && QAM.M==64
    Bits_TX= ccdm.decode(Symbols_TX_truncated.',QAM.symFreq,QAM.nBitsInfo);
end
BER_MIN=1;
DSP.Truncating=0;
DSP.Equliser_Delay=0;

for iter=1:4

    Symbols_RX=signal2symbol(Symbols_RX_Complex,QAM);

    if QAM.Probabilistic_Shaping==1 && QAM.M==64
        Bits_Decoded=ccdm.decode(Symbols_RX.',QAM.symFreq,QAM.nBitsInfo);
    else
        Bits_Decoded=sym2bit(Symbols_RX,QAM);
    end
    Bits_RX=Bits_Decoded;

    BER_practice=0;
    for j=1:QAM.nPol
        BER = sum((Bits_TX(j,:)-Bits_RX(j,:)).^2 ~=0) / size(Bits_TX,2);
        BER_practice=BER_practice+BER;
    end
    BER_practice=BER_practice/QAM.nPol;

    if BER_practice<BER_MIN
        if QAM.Probabilistic_Shaping==1 && QAM.M==64
            Symbols_RX_true= Symbols_RX;
        else
            Symbols_RX_true= bit2sym(Bits_Decoded,log2(QAM.M));
        end
        Bits_RX_true=Bits_Decoded;
        BER_MIN=BER_practice;
    end

    Symbols_RX_Complex=Symbols_RX_Complex.*exp(1i*pi/2);
end

BER_practice=BER_MIN;
end

