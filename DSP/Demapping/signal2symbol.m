function syms = signal2symbol(varargin)
%signal2symbol  Convert a complex signal into constellation symbols
%
%   This function converts an input complex signal into the corresponding
%   constellation symbols, employing minimum distance detection. 
%
%   INPUTS:
%   Sin     :=  input complex signal at 1 sample/symbol [nPol x nSyms]
%   symMap  :=  symbol mapping
%   IQmap   :=  IQ mapping
%
%   Alternatively, signal2symbol also accepts symMap and IQmap to be parsed
%   as fields of a struct array, QAM:
%   symMap = QAM.symbolMapping;
%   IQmap = QAM.IQmap;
%
%   OUTPUTS:
%   syms    :=  array of contellation symbols [nPol x nSyms]
%   
%
%   Author: Fernando Guiomar
%   Last Update: 25/06/2017

%% Input Parser
% Get Input Signal:
Sin = varargin{1};
% Get Symbol Map and IQ Map:
if nargin == 2
    QAM = varargin{2};
    if isstruct(QAM) && isfield(QAM,'symbolMapping') && isfield(QAM,'IQmap')
        symMap = QAM.symbolMapping;
        IQmap = QAM.IQmap;
    else
        error('When only 2 arguments are used, the 2nd argument must be a struct with "symbolMapping" and "IQmap" as required fields.');
    end
elseif nargin == 3
    symMap = varargin{2};
    IQmap = varargin{3};
    if ~isnumeric(symMap) || ~isnumeric(IQmap)
        error('When 3 arguments are used, both the 2nd and 3rd arguments must be numeric inputs.');
    end
end

%% Input Parameters
[nPol,nSyms] = size(Sin);
nQAM = numel(IQmap);

%% Symbol Decoder
syms = zeros(nPol,nSyms)-1;
err = zeros(nQAM,nSyms);
for m = 1:nPol
    for n = 1:nQAM
        % Determine the closest symbol in the ideal constellation:
        err(n,:) = abs(IQmap(n) - Sin(m,:));
    end
    [~,ind] = min(err);
    if QAM.Probabilistic_Shaping==1
        syms(m,:)=ind-1;
    else
        syms(m,:) = symMap(ind);
    end
end

