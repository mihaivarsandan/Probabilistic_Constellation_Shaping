function [Stx_MSC,Stx,TX,txBits,txSyms] = Signal_Generator(TX)
%SIGNAL_GENERATOR Summary of this function goes here
%   Detailed explanation goes here
SIG = TX.SIG;
QAM = TX.QAM;
PS = TX.PS;
nSC=numel(SIG);
for k = 1:nSC
    fSC(k) = SIG(k).freq_SC;
end

if max(abs(fSC)) < 1e5
    fSC = fSC * 1e9;
end

SIG_SC = SIG(1);

% %     if QAM{k}.lambda
% %         [Stx{k},txSyms{k},txBits{k},TX.QAM{k}] = ...
% %             Tx_ProbShaping(QAM{k},PRBS_Params{k},nSyms);
% %     else
%     % Logical Part of Transmitter for SC #k:

for k = 1:nSC
    
    if QAM.Probabilistic_Shaping==1 && QAM.M==64
        [Stx{k},txSyms{k},txBits{k},QAM] = Tx_Probabilistic_Shaping(QAM,SIG_SC.nSyms);
    else
        [Stx{k},txSyms{k},txBits{k}] = Tx_QAM(QAM,SIG_SC.nSyms);
    end
    
end

% end


%% Set Sampling-Rate of MSC Signal
BW = fSC(end) - fSC(1) + SIG_SC.symRate;
SIG_SC.nSpS = 2*PS.Oversampling_Factor;
Fs_MSC =BW * SIG_SC.nSpS;
[TX.SIG.nSpS] = deal(SIG_SC.nSpS);
 
%% Replicate Transmitted Signal and Update Parameters
nSamples = (SIG_SC.nSyms/SIG_SC.nPol-1) * SIG_SC.nSpS + PS.nTaps*SIG_SC.nSpS+1;
ni = 1;
nf = nSamples;

PARAM_MSC = setSimulationParams(Fs_MSC,nSamples);

%% Create MSC Signal

nSamples = PARAM_MSC.nSamples;
t = PARAM_MSC.t - PARAM_MSC.t(ni);
t = repmat(t,size(Stx{k},1),1);% only required for versions previous to R2016b
Stx_MSC = zeros(SIG_SC.nPol,nSamples);
for k = 1:nSC
     % Pulse Shaping:
     [Stx_SC{k},PS] = pulseShaper(repmat(Stx{k},1,1),SIG_SC.nSpS,PS);
  
     % Shift to the SC #k frequency and add to the MSC signal:
     Stx_MSC = Stx_MSC + Stx_SC{k}.*exp(1j*2*pi*fSC(k)*t);
end

%% Truncate the Sequence
Stx_MSC = Stx_MSC(:,ni:nf);

%% Update Simulation and Signal Parameters
TX.PARAM = setSimulationParams(PARAM_MSC.sampRate,length(Stx_MSC));
for k = 1:nSC
    SIG_out(k) = setSignalParams(SIG(k),TX.PARAM);
end


%% Apply Laser
if PS.apply_Laser_Noise==1
    [Stx_MSC,PS]=Laser_Noise(Stx_MSC,PS,TX);
end
    
%% Atribution
TX.QAM = QAM;
TX.PS = PS;
TX.SIG = SIG_out;
end

