function [BER] = BER_function(in)
%BER_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
%% General Transmission Parameters
nSC= 1;    %number of subcarriers
total_bitRate = 200*1e9;   %total bit rate
M=4;  %constellation size
nPol= 1; %polarization number
nSyms=100; %number of symbols
nSyms= 1e5; %number of symbols
Purpose='Test';
Probabilistic_Shaping =false;

%% Laser  Parameters
pulse_type='RRC';
rolloff =0.25;
Oversampling_Factor=4;
Linewidth=1e5;
Apply_Laser_Noise=false;
Laser_Noise_Debug=false;
PS_taps=6;

%% Channel  Parameters
L = 1000;
Amplifier_Spacing = 100;
beta_2 = -22.4 *1e-24;
alpha=0.09210;
gamma  = 0;
channel_type='AWGN';
Apply_SSFT =true;
Apply_Chromatic_Dispersion=true;
Dispersion_debug=false;
%% DSP paramters
K=in(1);
mu=in(2)*1e-6;

%% Simulation
Channel=create_Channel(Purpose,L,beta_2,alpha,gamma,Amplifier_Spacing,channel_type,Apply_Chromatic_Dispersion,Dispersion_debug,Apply_SSFT);
TX=create_TX(nSC,total_bitRate,M,nPol,nSyms,pulse_type,rolloff,Oversampling_Factor,Linewidth,Apply_Laser_Noise,PS_taps,Laser_Noise_Debug,Probabilistic_Shaping);
Results=create_Results(Channel,TX);
DSP=create_DSP(TX,Channel,mu,K);

[Signal.Signal_TX, Signal.Symbols_TX_Complex, TX,Signal.Bits_TX,Signal.Symbols_TX]=Signal_Generator(TX);

 for k=1:DSP.Nr_Transmission
     [Signal.Signal_RX,Channel]=Apply_Channel(Signal.Signal_TX,Channel,TX,k);
     [Signal.Symbols_DSP,DSP] = Apply_DSP(Signal.Signal_RX,TX,Channel,DSP,k);
     [Results.BER_Practice(k),Results.MI(k),Results.H_X(k),Results.H_Y(k),Signal,DSP]=Analysis(Signal,TX,DSP,Channel);
 end
BER=Results.BER_Practice(1)
end

