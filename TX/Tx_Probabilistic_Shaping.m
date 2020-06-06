function [Stx,txSyms,txBits,QAM] = Tx_Probabilistic_Shaping(QAM,nSyms)
%TX_PROBABILISTIC_SHAPING Summary of this function goes here
%   Detailed explanation goes here
% Last Update: 30/08/2017


%% Input Parameters
C = QAM.IQmap;
symIndex = QAM.symbolIndex;
pOpt = QAM.pOpt;


%% Initialize CCDM

[p_quant,nBitsInfo,n_i] = ccdm.initialize(pOpt,nSyms);
QAM.meanConstPower = sum(abs(C).^2.*p_quant);
QAM.nBitsInfo = nBitsInfo;
QAM.symFreq = n_i;
QAM.symProb = p_quant;

%nRep = floor(nSyms/nSyms_ccdm);
%nTail = nSyms - nSyms_ccdm*nRep;
nRep=1;
nTail=1;
%% Generate PRBS
txBits = randi(2,1,QAM.nBitsInfo)-1;

%% Encode with Distribution Matcher

if QAM.nPol==1
    i_TX=ccdm.encode(txBits(1,:),n_i).'+1;
    IQ = C(i_TX);
    %IQ = [repmat(IQ,nRep,1); IQ(1:nTail)];
    %IQ = repmat(IQ,nRep,1);
    txSyms = i_TX.'-1;
    Stx = IQ.';
else
    i_TX_x = ccdm.encode(txBits(1,:),n_i).' + 1;
    IQ_x = C(i_TX_x);
    i_TX_y = ccdm.encode(txBits(2,:),n_i).' + 1;
    IQ_y = C(i_TX_y);
    IQ_x = [repmat(IQ_x,nRep,1); IQ_x(1:nTail)];
    IQ_y = [repmat(IQ_y,nRep,1); IQ_y(1:nTail)];
    txSyms = [i_TX_x.'-1; i_TX_y.'-1];
    Stx = [IQ_x.';IQ_y.'];
end


end

