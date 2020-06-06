function [Stx,txSyms,txBits] = Tx_QAM(QAM,nSyms)

% Last Update: 02/03/2017


%% Generate Transmitted Bits
txBits = QAM_PRBSgenerator(QAM,nSyms);

%% Generate Symbols from Bits
txSyms = bit2sym(txBits,log2(QAM.M));

% txSyms =ones(size(txSyms))+ txSyms;

 
%% Generate Signal Constellation from Symbols
Stx = symbol2signal(txSyms,QAM);

end

