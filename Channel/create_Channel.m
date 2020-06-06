function [Channel] = create_Channel(Purpose,L,beta_2,alpha,gamma,Amplifier_Spacing,channel_type,Apply_Chromatic_Dispersion,Dispersion_debug,Apply_SSFT)
%CREATE_CHANNEL Summary of this function goes here
%   Detailed explanation goes here
Channel.Transmission_Goal=Purpose;
Channel.Lenght=L;
Channel.Beta_2=beta_2;
Channel.Alpha = alpha;
Channel.Gamma = gamma;
Channel.Amplifier_Spacing =Amplifier_Spacing;
Channel.SSFT =Apply_SSFT; 
Channel.Type =channel_type;
Channel.Chromatic_Dispersion=Apply_Chromatic_Dispersion;
Channel.Dispersion_debug=Dispersion_debug;

Es_No_dB = 1:30;
Es_No = 10.^(Es_No_dB./10);

switch Channel.Transmission_Goal
    case{'BER'}
        Channel.Es_No=Es_No;
        Channel.Es_No_dB=Es_No_dB;
        
    case{'Pure'}
        Channel.Es_No=[1000];
        Channel.Es_No_dB=[100];
    case{'Test'}
        Channel.Es_No=[Es_No(5)];
        Channel.Es_No_dB=[Es_No_dB(10)];
end

end

