function signal = symbol2signal(syms,varargin)
%symbol2signal  Convert constellation symbols into a complex signal
%
%   This function converts an input array of constellation symbols into a
%   complex signal, using the pre-defined IQ mapping.
%
%   INPUTS:
%   syms    :=  array of constellation symbols [nPol x nSyms]
%   IQmap   :=  mapping between symbols and IQ complex points
%   symIdx  :=  array of symbol indices
%
%   Alternatively, symbol2signal also accepts IQmap and symIdx to be parsed
%   as fields of a struct array, QAM:
%   IQmap = QAM.IQmap;
%   symIdx = QAM.symbolIndex;
%
%   OUTPUTS:
%   signal  :=  array of complex-valued signal [nPol x nSyms]
%
%
%   Author: Fernando Guiomar
%   Last Update: 25/07/2017

%% Input Parameters
[nSig,nSyms] = size(syms);
if nargin == 2
    QAM = varargin{1};
    if isstruct(QAM) && all(isfield(QAM,{'IQmap','symbolIndex'}))
        IQmap = QAM.IQmap;
        symIndex = QAM.symbolIndex;
    else
        error('When only 2 arguments are used, the 2nd argument must be a struct with "IQmap" and "symIndex" as required fields.');
    end
end
%% Signal to Symbol
signal = zeros(nSig,nSyms);
for n = 1:nSig
    signal(n,:) = IQmap(symIndex(syms(n,:)+1));
end

