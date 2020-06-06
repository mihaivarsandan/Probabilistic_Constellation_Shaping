function [Aout,DSP] = Matched_Filter(Ain,PS,nSpS,DSP)
%PULSE_SHAPING Summary of this function goes here
%   Detailed explanation goes here
switch PS.type 
    case {'RRC','root-raised-cosine'}
        Aout = upfirdn(Ain.',PS.W).';
        Aout = Aout(:,PS.nTaps*nSpS+1:end-PS.nTaps*nSpS);
        Aout = downsample(Aout,nSpS/2);
        DSP.pulse_matching = PS.W;
    otherwise
        error('Invalid Pulse Shaping Filter!');
end

end