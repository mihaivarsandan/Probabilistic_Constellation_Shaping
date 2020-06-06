function [MI,SNR,H_X,H_Y] = Mutual_Information(Srx,Stx,M,IQmap,sym2bitmap)
%MUTUAL_INFORMATION Summary of this function goes here
%   Detailed explanation goes here
Ntx=size(Srx,1);
Ns =size(Srx,2);
centroids=zeros(M,1);
sigma2 = zeros(M,1);                                                         % variance of each centroid
MI = zeros(Ntx,1); 
Stx=Stx+ones(size(Stx));
%% Calculate centroids, variance and MI
y = Srx;
% get nn-th transmit signal
i_tx = repmat(Stx(mod(0,size(Stx,1))+1,:),1,1);           % nn-th transmit indexes
pos = bsxfun(@eq,int16(i_tx),(1:M).');                                 % indexes of this point
P_symb = sum(pos,2)/Ns;                                               % probability of point

for i = 1:M                                                            % for all transmitted symbols
    rx_s = y(pos(i,:));                                                % get received points relative to i-th TX symbol
    centroids(i) = mean(rx_s);                                         % calculate centroid
    sigma2(i) = var(rx_s)+eps;                                         % calculate variance (never to zero)
end
SNR = 10*log10(mean(abs(centroids).^2)./mean(sigma2)); % calculate SNR
centroids;
sigma2;
%% Calculate MI
 P_y = sum(exp(bsxfun(@rdivide,-abs(bsxfun(@minus,y,centroids)).^2,sigma2)),2)/Ns;
 H_X = -sum(P_symb.*log2(P_symb));
 H_Y = -sum(P_y.*log2(P_y));
 %MI_den = sum(bsxfun(@times,P_y,P_symb),2)% cumulate MI
 MI_den = sum(bsxfun(@times,exp(bsxfun(@rdivide,-abs(bsxfun(@minus,y,centroids)).^2,sigma2)),P_symb),2);% cumulate MI
 MI = -mean(log2(MI_den))+1/log(2);                             % convert to bits

end

