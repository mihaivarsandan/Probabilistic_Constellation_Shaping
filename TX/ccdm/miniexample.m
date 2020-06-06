%MINIEXAMPLE
% Run this basic example to understand how to initialize, encode and decode
% a message using CCDM. You can adjust the choosen output distribution and
% the output length.
%
% See also CCDM.INITIALIZE, CCDM.ENCODE, CCDM.DECODE, INSTALL


% Copyright (c) 2015, Patrick Schulte, Georg Böcherer
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
% 1. Redistributions of source code must retain the above copyright notice,
%    this list of conditions and the following disclaimer.
%
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation 
%    and/or other materials provided with the distribution.
%
% 3. Neither the name of the copyright holder nor the names of its contributors may
%    be used to endorse or promote products derived from this software without 
%    specific prior written permission.
%
% 4. In case results are published that rely on this source code, please cite
%    our paper entitled "Constant Composition Distribution Matching" [1]. 
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
% IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
% INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
% NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
% OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%
% [1] http://arxiv.org/abs/1503.05133

% choose aribtray target distribution and output length
pOpt = [0.0,0.2,0.3,0.5];
n = 10;
% calculate  input length m, and the optimal n-type approximation 
[p_quant,num_info_bits,n_i] = ccdm.initialize(pOpt,n)

% generate uniform bits of input length m
src_symbols = randi(2,1,num_info_bits)-1
% encode with distribution matcher
tic;
code_symbols = ccdm.encode(src_symbols,n_i)
% decode with distribution matcher
src_symbols_hat = ccdm.decode(code_symbols,n_i,num_info_bits)
toc;
% check equality
display(sum(src_symbols_hat ~= src_symbols));
% check distribution
hist(code_symbols,0:length(p_quant)-1);
