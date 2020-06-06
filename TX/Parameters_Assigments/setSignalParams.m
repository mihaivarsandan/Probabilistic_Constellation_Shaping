function SIG = setSignalParams(varargin)

% Last Update: 10/06/2017


%% Input Parameters
if nargin <= 3
    SIG = varargin{1};
    symRate = SIG.symRate;
    M = SIG.M;
    if isfield(SIG,'nBpS')
        nBpS = SIG.nBpS;
    end
    if isfield(SIG,'nPol')
        nPol = SIG.nPol;
    end
%     if isfield(SIG,'lambda')
%         lambda = SIG.lambda;
%     end
    if isfield(SIG,'maxEntropy')
        maxEntropy = SIG.maxEntropy;
    end
    if isfield(SIG,'OH')
        OH = SIG.OH;
    end
    if nargin == 2
        PARAM = varargin{2};
        sampRate = PARAM.sampRate;
        nSamples = PARAM.nSamples;
    elseif nargin == 3
        sampRate = varargin{2};
        nSamples = varargin{3};
    end
else
    for n = 1:2:nargin
        varName = varargin{n};
        varValue = varargin{n+1};
        switch varName
            case {'symRate','symbol-rate'}
                symRate = varValue;
            case {'M'}
                M = varValue;
            case {'nBpS'}
                nBpS = varValue;
            case {'nPol'}
                nPol = varValue;
            case {'sampRate'}
                sampRate = varValue;
            case {'nSamples'}
                nSamples = varValue;
            case {'nSpS'}
                nSpS = varValue;
            case {'nSyms'}
                nSyms = varValue;
            case {'lambda'}
                lambda = varValue;
            case {'maxEntropy'}
                maxEntropy = varValue;
            case {'OH'}
                OH = varValue;
        end
    end
end
if ~exist('M','var')
    error('You must specify the constellation size, M');
end
if ~exist('nPol','var')
    error('You must specify number of Polarizations, nPol');
end

% if ~exist('OH','var')
%     OH.FEC = 0.2;
%     OH.total = 0.28;
% end
% if exist('lambda','var')
%     maxEntropy = lambda2entropy(lambda,M);
%     nBpS = maxEntropy - OH.FEC*(log2(M)-maxEntropy);
% else
%     if exist('nBpS','var')
%         lambda = ProbShaping_getLambda(nBpS,M,OH.FEC);
%         maxEntropy = lambda2entropy(lambda,M);
%     elseif exist('maxEntropy','var')
%         lambda = ProbShaping_getLambda(nBpS,M,OH.FEC);
%     else
%         lambda = 0;
%         nBpS = log2(M);
%         maxEntropy = nBpS;
%     end
% end
nBpS = log2(M);
maxEntropy = nBpS;
if ~exist('sampRate','var')
    if exist('nSpS','var')
        SIG.nSpS = nSpS;
        sampRate = nSpS * symRate;
    end
end
if ~exist('nSamples','var')
    if exist('nSyms','var')
        SIG.nSyms = nSyms;
        if exist('sampRate','var')
            nSamples = sampRate/symRate * nSyms;
        end
    end
end
% if ~exist('lambda','var')
%     lambda = 0;
% end

%% Secondary Parameters
bitRate = symRate * log2(M);
tSym = 1/symRate;
tBit = 1/bitRate;

%% Signal Parameters that Depend on the Simulation Parameters
if exist('sampRate','var') && exist('nSamples','var')
    SIG.nSpS = sampRate / symRate;
    SIG.nSpB = sampRate / (symRate * maxEntropy);
    SIG.nBits = nSamples / SIG.nSpB;
end


%% Set QAM fields
SIG.symRate = symRate;
SIG.bitRate = bitRate;
SIG.M = M;
SIG.nBpS = nBpS;
SIG.maxEntropy = maxEntropy;
% SIG.lambda = lambda;
SIG.nPol = nPol;
SIG.tSym = tSym;
SIG.tBit = tBit;
