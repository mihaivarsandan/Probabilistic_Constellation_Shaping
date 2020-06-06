%CCDM.INITIALIZE
% CCDM.INITIALIZE(p,n) 
% select a desired distribution vektor p, desired output length n.
%
% [p_quant,num_info_bits,n_i] = CCDM.INITIALIZE(p,n)
% p_quant is the n-type distribution approximating p.
% num_info_bits is the input length for the encoder.
% n_i is the counting vector whose jth entry is the number of times the
% letter j will occure in the output sequences of ccdm.encode. Note that
% p_quant = n_i./n.
%
% See also CCDM.ENCODE, CCDM.DECODE, MINIEXAMPLE

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


function [p_quant,num_info_bits,n_i] = initialize(p,n)
% quantize to n-type distribution
[n_i,p_quant] = ccdm.idquant(p,n);

% calculate actual supported input length
num_info_bits = floor(ccdm.n_choose_ks_recursive_log2(n,n_i));
end