function [TX] = Create_TX(nSC,total_bitRate,M,nPol,nSyms,pulse_type,rolloff,Oversampling_Factor,Linewidth,Apply_Laser_Noise,PS_taps,Laser_Noise_Debug,Probabilistic_Shaping)
%CREATE_TX Summary of this function goes here
%   Detailed explanation goes here
nBpS_gross = log2(M);
symRate_SC = total_bitRate/(nSC*log2(M));
bitRate_SC = total_bitRate/(nSC);
nSyms_SC= nSyms/nSC;
for k=1:nSC
    TX.SIG(k) = setSignalParams('symRate',symRate_SC,'M',M,'nBpS',nBpS_gross,'nSyms',nSyms_SC,'nPol',nPol);
end
TX.MSC = setMSCparams(TX.SIG);

for k = 1:nSC
    TX.SIG(k).freq_SC = TX.MSC.grid(k);
end

modFormat = FDHMF_getID(M,nPol);
TX.QAM = QAM_config(modFormat);

TX.QAM.Probabilistic_Shaping = Probabilistic_Shaping;
TX.PS.type=pulse_type;
TX.PS.rolloff=rolloff;
TX.PS.Oversampling_Factor=Oversampling_Factor;
TX.PS.linewidth=Linewidth;
TX.PS.apply_Laser_Noise=Apply_Laser_Noise;
TX.PS.nTaps=PS_taps;
TX.PS.Laser_Noise_Debug=Laser_Noise_Debug;

end

