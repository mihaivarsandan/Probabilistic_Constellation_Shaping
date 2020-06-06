function [bits] = QAM_PRBSgenerator(QAM,nSyms)

% Last Update: 30/08/2017

%% Input Parameters                                          % PRBS degree                                        % flag signaling if the sequence should be of even length (in that case, one 0 must be padded at the end of each PRBS)                              % flag signaling if bit delay should be applied to the generated/loaded PRBS sequences (between I and Q)
nPol = QAM.nPol;                                                            % number of transmitted polarization tributaries                                                     % number of parallel PRBSs (only if parallel bit to symbol assignment is used)

nBits = nSyms/nPol * QAM.nBpS;




%% Generate PRBS
bits = randi([0 1],nPol,nBits);


end


