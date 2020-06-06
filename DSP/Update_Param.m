function [TX] = Update_Param(signal,TX)
%UPDATE_PARAM Summary of this function goes here
%   Detailed explanation goes here
nsamples = size(signal,2);
[TX.SIG.nSpS] = deal(ceil(nsamples/TX.SIG.nSyms));
[TX.SIG.nSpB] = deal(TX.SIG.nSpS/log2(TX.SIG.M));


BW = TX.SIG(end).freq_SC - TX.SIG(1).freq_SC + TX.SIG.symRate;
Sampling_Frequency =BW * TX.SIG.nSpS;
TX.PARAM = setSimulationParams(Sampling_Frequency,nsamples);

end

