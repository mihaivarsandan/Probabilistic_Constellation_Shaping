function [Signal_Out, Channel] = Apply_Channel(Signal,Channel,TX,noise_val)
%APPLY_CHANNEL Summary of this function goes here
%   Detailed explanation goes here
Signal_Ch=Signal;

%% Apply SSFT
if Channel.SSFT ==1
    Signal_Ch=SSFT(Signal_Ch,Channel,TX);
end


%% Apply AWGN
switch Channel.Transmission_Goal
    case{'Pure'}
        Signal_Ch=Signal_Ch;
    
    case{'Test'}
        Signal_Ch=awgn(Signal_Ch,Channel.Es_No_dB(1)-10*log10(TX.SIG.nSpS),'measured');
        
    otherwise   
    Signal_Ch=awgn(Signal_Ch,Channel.Es_No_dB(noise_val)-10*log10(TX.SIG.nSpS),'measured');
end
%% Apply Chromatic Dispersion
if Channel.SSFT ~= 1
    if Channel.Chromatic_Dispersion == 1
        [Signal_Ch,Channel]=Chromatic_Dispersion(Signal_Ch,Channel,TX);
    end
end

Signal_Out=Signal_Ch;

end

