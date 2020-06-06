function QAM = QAM_config(modFormat)
%QAM_config     Configure QAM struct based on a selected format 
%   This functions configures a struct with QAM properties based on the
%   specified modulation format. Currently supported formats are:
%   QPSK (square)
%   16QAM (square)
%   64QAM (square)
%   256QAM (square)
%
%   INPUTS:
%   modFormat   :=  modulation format string. It must contain the 'mQAM'
%                   string in it (e.g. 'QPSK','4QAM','8QAM','1024QAM') and
%                   it may also contain a string to indicate the use of
%                   dual-polarization (either 'DP' or 'PM')
%
%   OUTPUTS:
%   QAM         :=  struct with QAM parameters
%
%
%   Examples:
%       QAM = QAM_config('1024QAM')
%       QAM = QAM_config('PM-QPSK')
%       QAM = QAM_config('DP-4QAM')
%       QAM = QAM_config('PM-32QAM')
%
%       scatterplot(QAM.IQmap);
%
%
%   Author: Fernando Guiomar
%   Last Update: 22/06/2017


%% Configure Modulation Format Parameters
% Determine number of polarizations:
if ~isempty(strfind(modFormat,'DP'))
    nPol = 2;
else
    nPol = 1;
end
% Load QAM Constellation:
[const,M,symbolMap,modFormat] = QAM_loadConstellation(modFormat);
% Determine all radii in the constellation:

% If there are two polarization, change modulation format ID accordingly:
if nPol == 2
    modFormat = ['DP-' modFormat];
end

%% Determine Constellation Mapping
% Normalize constellation maximum I/Q to 1:

const_unity=Unity_Power(const);
radius = unique(abs(const_unity));
radius = sort(radius,2,'descend');

S(1,:) = real(const_unity);
S(2,:) = imag(const_unity);

S_meanP = Measure_Power(S(1,:) + 1j*S(2,:));
S_maxP = max(abs(S(1,:) + 1j*S(2,:)).^2);
if nPol == 2
    S_2pol(1:2,:) = repmat(S,1,M);
    S_2pol(3:4,:) = rectpulse(S',M)';
end
% In-phase and quadrature mapping:
IQmap = (S(1,:) + 1j*S(2,:)).';
% Symbol mapping and indices:
symbolInd = zeros(1,M);
for n = 0:M-1
    symbolInd(n+1) = find(symbolMap==n);
end
% IQmap = IQmap(symbolInd);
% Mapping symbols to bits:
if ~mod(log2(M),1)
    a = dec2bin(0:M-1,log2(M));
    sym2bitMap  = zeros(M,log2(M));
    for n = 1:log2(M)
        sym2bitMap(:,n) = str2num(a(:,n));
    end
    sym2bitMap_2pol(:,1:log2(M)) = repmat(sym2bitMap,M,1);
    
    sym2bitMap_2pol(:,log2(M)+1:2*log2(M)) = rectpulse(sym2bitMap,M);
end

[lambda,H]=get_Lambda(log2(M),M);
lambda = 0.1;
pOpt = exp(-lambda*abs(IQmap)*(sqrt(M)-1)/(sqrt(2)/2));
pOpt = pOpt/sum(pOpt);

%% Output QAM Struct

QAM.modFormat = modFormat;                                                  % modulation format                                                      % QAM mode (square, cross)
QAM.M = M;                                                                  % constellation number of symbols
QAM.nBpS = log2(M);                                                         % number of bits per symbol
QAM.S = S;                                                                  % ideal constellation (1-pol)
QAM.radius = radius;                                                        % constellation radius
QAM.nPol = nPol;                                                            % number of polarization components
QAM.meanConstPower = S_meanP;                                               % mean constellation power
QAM.maxConstPower = S_maxP;                                                 % mean constellation power
QAM.IQmap = IQmap;                                                          % mapping between constellation symbols and IQ
QAM.symbolMapping = symbolMap;                                              % mapping between constellation symbols and IQ
QAM.symbolIndex = symbolInd;                                                % symbol indices
if ~mod(log2(M),1)
    QAM.sym2bitMap = sym2bitMap;                                            % map symbols to bits
    if nPol == 2
        QAM.sym2bitMap_2pol = sym2bitMap_2pol;                              % map symbols to bits
    end
end
if nPol == 2
    QAM.S_2pol = S_2pol;                                                    % ideal constellation (2-pol)
end
QAM.pOpt =pOpt;
QAM.entropy = H;

