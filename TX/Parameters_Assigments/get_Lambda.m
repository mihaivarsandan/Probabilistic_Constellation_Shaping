function [lambda,H] = get_Lambda(nBpS,M)

% Last Update: 07/04/2017


%% Input Parser
% if nargin < 3
%     OH_FEC = 0.2;
% end
OH_FEC=0.4;
%% Get Lambda

nBpS_net = nBpS/(1 + OH_FEC);
H = nBpS_net + log2(M)*(1-1/(1 + OH_FEC));
if H == log2(M)
    lambda = 0;
else
    lambda = entropy2lambda(H,M);
end


