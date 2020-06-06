function [bits] = sym2bit(syms,QAM_sym2bitMap)
%sym2bit    Convert QAM symbols into bits
%   This function converts a stream of input QAM symbols into the
%   corresponding stream of bits, applying the defined symbol-to-bit
%   mapping.
%
%   INPUTS:
%   syms            :=  input QAM symbols [nPol x nSyms]
%   QAM_sym2bitMap  :=  symbol-to-bit mapping [M x nBits/symbol]
%
%   Alternatively, sym2bit also accepts QAM_sym2bitMap to be parsed as a
%   field of a struct array, QAM:
%   sym2bitMap = QAM_sym2bitMap;
%
%   OUTPUTS:
%   bits            :=  array of bits [nPol x log2(M)*nSyms]
%
%
%   Author: Fernando Guiomar
%   Last Update: 01/09/2017

%% Input Parser
if isstruct(QAM_sym2bitMap)
    sym2bitMap = QAM_sym2bitMap.sym2bitMap;
elseif isnumeric(QAM_sym2bitMap)
    sym2bitMap = QAM_sym2bitMap;
end
%% Input Params
[nPol,nSyms] = size(syms);
M = size(sym2bitMap,1);

%% Transform Symbols into Bits
bits = zeros(nPol,log2(M)*nSyms);
for m = 1:nPol
    b = sym2bitMap(syms(m,:)+1,:);
    bits(m,:) = reshape(b',1,numel(b));
end