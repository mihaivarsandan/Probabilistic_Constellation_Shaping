function [syms] = bit2sym(bits,nBpS)
%bit2sym    Transform bits into symbol indices
%   This function takes a stream of transmitted/received bits and
%   calculates the corresponding symbol indices for a given number of bits
%   per symbol.
%
%   INPUTS:
%   bits    :=      array of bits [Nsig x Nbits]
%   nBps    :=      number of bits per symbol of a given constellation
%
%   OUTPUTS:
%   syms    :=      array of symbol indices [Nsig x Nsyms], taking values
%                   in [0 2^nBps-1]
%
%   Fernando Guiomar
%   Last Update: 02/03/2017

%% Validate Input Arguments
validateattributes(bits,{'numeric'},{'binary'},'','bits',1);
validateattributes(nBpS,{'numeric'},{'scalar','positive','integer'},'','nBpS',2);

%% Input Parameters
[nSig,nBits] = size(bits);
nSyms = nBits / nBpS;

%% Bit-to-Symbol Assignment
syms = zeros(nSig,nSyms);
for k = 1:nSig
    for n = 1:nBpS
        syms(k,:) = syms(k,:) + bits(k,n:nBpS:end)*2^(nBpS-n);
    end
end

