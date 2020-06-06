function PARAM = setSimulationParams(varargin)

% Last Update: 11/04/2017


%% Input Parser

sampRate = varargin{1};
nSamples = varargin{2};

%% Secondary Parameters
tWindow = nSamples / sampRate;
dt = 1 / sampRate;
dw = 2* pi * sampRate / nSamples;
%dw =2* pi * sampRate;
t = (0:nSamples-1)*dt;
% w = (-(nSamples-1)/2:1:(nSamples-1)/2)*dw;
w=zeros(size(t));
if rem(nSamples,2)==0
    w(1:nSamples/2)=(0:1:nSamples/2-1)*dw;
    w(nSamples/2+1:end)=flip(-1*(1:1:nSamples/2)*dw);
else
    w(1:(nSamples+1)/2)=(0:1:(nSamples-1)/2)*dw;
    w((nSamples+1)/2+1:end)=flip(-1*(1:1:(nSamples-1)/2)*dw);
    
end

%% Set PARAM fields
PARAM.sampRate = sampRate;
PARAM.nSamples = nSamples;
PARAM.tWindow = tWindow;
PARAM.dw = dw;
PARAM.dt = dt;
PARAM.t = t;
PARAM.w = w;

