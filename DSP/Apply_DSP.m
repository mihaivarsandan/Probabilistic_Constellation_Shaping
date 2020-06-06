function [Symbols_DPS_Out,DSP] = Apply_DSP(Signal,TX,Channel,DSP,eval)
%APPLY_DSP Summary of this function goes here
%   Detailed explanation goes here

%% Matching and Downsampling
[Symbols_Matched,DSP] = Matched_Filter(Signal,TX.PS,TX.SIG.nSpS,DSP);
Symbols_DSP=Symbols_Matched;
TX = Update_Param(Symbols_DSP,TX);


%% Static Equalisation
if Channel.SSFT ==1
    
    [Symbols_Equalised,DSP]=Static_Equaliser(Symbols_DSP,Channel,TX,DSP);   
    DSP.Symbols_before_StaticEqual=downsample(Symbols_DSP,2,1);
    DSP.Symbols_after_StaticEqual= downsample(Symbols_Equalised,2,1);
    Symbols_Equalised=Unity_Power(Symbols_Equalised);
    %Measure_Power(Symbols_Equalised)
    Symbols_DSP=Symbols_Equalised;
    
end
Symbols_DSP = downsample(Symbols_DSP,2,1);
TX = Update_Param(Symbols_DSP,TX);
%% 1st Adaptive Equaliser
if Channel.Chromatic_Dispersion==1
    %[Symbols_Equalised,DSP]=Adaptive_Equaliser(Symbols_DSP,TX.QAM,DSP);
    [Symbols_Equalised,DSP]=Adaptive_Equaliser_2(Symbols_DSP,TX.QAM,DSP);
    %Symbols_Equalised=Unity_Power(Symbols_Equalised);
    
    DSP.Symbols_before_AdaptEqual=Symbols_DSP;
    DSP.Symbols_after_AdaptEqual= Symbols_Equalised;
    
    Symbols_DSP=Symbols_Equalised;
end


%% Phase Compensation
if TX.PS.apply_Laser_Noise==1
    for j=1:size(Symbols_DSP,1)
        Symbols_Compensated(j,:)=Phase_Compensation(Symbols_DSP(j,:).',TX.QAM,DSP.Phase_Comp_Taps(eval)).';
    end
    if eval==DSP.Nr_Transmission
        DSP.Symbols_before_Compensation=Symbols_DSP;
        DSP.Symbols_after_Compensation=Symbols_Compensated;
    end
    Symbols_DSP=Symbols_Compensated;
end



%% Decoding
Symbols_DPS_Out =Symbols_DSP;

end

