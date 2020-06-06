function MSC = setMSCparams(SIG)

% Last Update: 29/08/2017


%% Assign Parameters
MSC.nSubCarriers = numel(SIG);                                              % total number of electronic subcarriers
% MSC.symRate = sum([SIG.symRate]);
MSC.symRate = [SIG.symRate];
MSC.symRate_MSC = sum([SIG.symRate]);
if isfield(SIG,'bitRate')
    MSC.bitRate_MSC = sum([SIG.bitRate]);
end
if isfield(SIG,'nPol')
    MSC.nPol = SIG(1).nPol;
end
MSC.M = [SIG.M];
MSC.nBpS = [SIG.nBpS];
% if isfield(SIG,'lambda')
%     MSC.lambda = [SIG.lambda];
% end
% if isfield(SIG,'fSC')
%     MSC.fSC = [SIG.fSC];
% end
% if isfield(SIG,'fWDM')
%     MSC.fWDM = SIG(1).fWDM;
% end

MSC.grid = MSC_configFreqGrid(MSC.nSubCarriers,50*1e9);
end


