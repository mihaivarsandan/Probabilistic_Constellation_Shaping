function [DSP] = create_DSP(TX,Channel,mu,K)
%CREATE)D Summary of this function goes here
%   Detailed explanation goes here
DSP.Truncating=0;
DSP.Equaliser_Top=0;
DSP.Equaliser_Bottom=0;
DSP.Adaptive_Equal_mu=mu;
DSP.Adaptive_Equal_taps=K;
switch Channel.Transmission_Goal
    case{'BER'}
        DSP.Nr_Transmission=30;
        DSP.Phase_Comp_Taps=250*ones(1,30);
    case{'Test'}
        if TX.PS.Laser_Noise_Debug==1
            DSP.Phase_Comp_Taps=1:2:400;
            DSP.Nr_Transmission=numel(DSP.Phase_Comp_Taps);
        else
            DSP.Phase_Comp_Taps=[250];
            DSP.Nr_Transmission=1;
        end
    case{'Pure'}
            DSP.Phase_Comp_Taps=[250];
            DSP.Nr_Transmission=1;
    otherwise
        error('Please Specify a Suitable Goal')
end
                   
end

