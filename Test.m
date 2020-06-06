
 








rolloff = 0.25; % Filter rolloff
span = 6;       % Filter span
sps = 8;        % Samples per symbol
M = 16;          % Size of the signal constellation
k = log2(M);    % Number of bits per symbol


rrcFilter = rcosdesign(rolloff, span, sps,'sqrt');


data = randi([0 M-1], 2, 1);


modData = qammod(data, M)
txSig = upfirdn(modData, rrcFilter, sps);
%EbNo = 7;
%snr = EbNo + 10*log10(k) - 10*log10(sps);
%rxSig = awgn(txSig, snr, 'measured');

rxFilt = upfirdn(txSig, rrcFilter, 1, sps);
rxFilt = rxFilt(span+1:end-span)

Create a scatterplot of the modulated data using the first 5000 symbols.

hScatter = scatterplot(sqrt(sps)* ...
    rxSig(1:sps*5000),...
    sps,0,'g.');
hold on
scatterplot(rxFilt(1:5000),1,0,'kx',hScatter)
title('Received Signal, Before and After Filtering')
legend('Before Filtering','After Filtering')
axis([-3 3 -3 3]) % Set axis ranges
hold off