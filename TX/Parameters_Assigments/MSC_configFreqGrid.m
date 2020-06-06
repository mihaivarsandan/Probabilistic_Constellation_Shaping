function [grid,MSC] = MSC_configFreqGrid(nSC,df,shiftBB)

% Last Update: 12/04/2017


%% Input Parser
if nargin < 3
    shiftBB = 0;
end
%% Create Multi-Subcarrier Grid
if numel(nSC) == 1
    if nSC == 1 || nSC > 1e6
        grid = 0;
    else
        grid = -df*(nSC-1)/2:df:df*(nSC-1)/2;
        grid = grid + sign(grid) * shiftBB;
    end
else
    Rs = nSC;
    nSC = numel(Rs);
    eta = df;
    dRs = movsum(Rs,2);
    df = eta .* dRs(2:end)/2;
    BW = Rs(1)/2 + sum(df) + Rs(end)/2;
    f0 = -BW/2;
    for k = 1:nSC
        grid(k) = f0 + Rs(1)/2 + sum(df(1:k-1));
    end
    shiftBB = 0;
end
%% Determine Subcarrier Slots
subCarrierSlot  = diff(grid);

%% Output WDM Struct
MSC.subCarrierSpacing   = df;                                               % frequency spacing between subcarriers
MSC.subCarrierSlot      = subCarrierSlot;                                   % subcarrier frequency slot
MSC.grid                = grid;                                             % subcarrier grid (relative subcarrier frequencies inside each channel)
MSC.basebandShift       = shiftBB;                                          % frequency shift to baseband

