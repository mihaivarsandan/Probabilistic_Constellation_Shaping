function [Aout,PS] = pulseShaper(Ain,nSpS,PS)

% Last Update: 17/07/2017


%% Input Parser
nPol = size(Ain,1);

%% Select Pulse Shaping Filter
switch PS.type
    case {'Rect','rect','rectangular','none'}
%         for n = 1:nPol
%             Aout(n,:) = rectpulse(Ain(n,:),nSpS);
%         end
    case {'RC','raised-cosine','raisedCos','Nyquist'}
%         a = PS.rollOff;
%         if isfield(PS,'nTaps')
%             nTaps = PS.nTaps;
%         else
%             nTaps = 6 * nSpS;
%         end
%         k = -floor(nTaps/2):ceil(nTaps/2)-1;
%         tK = k/nSpS;
%         W = sinc(tK).*cos(a*pi*tK)./(1-4*a^2*tK.^2);
%         W(isinf(W)) = 0;
%               
%         for m = 1:nPol
%             Aout(m,:) = conv(upsample(Ain(m,:),nSpS),W,'same');
%         end
%         PS.W = W;
        
    case {'RRC','root-raised-cosine'}
        pulse = rcosdesign(PS.rolloff,PS.nTaps,nSpS);
        Aout = upfirdn(Ain.',pulse,nSpS).';
        PS.W = pulse;
        
    case 'Gaussian'
%         fcn = PS.fcn;
%         nTaps = PS.nTaps;
%         W = gaussdesign(fcn,nTaps/nSpS,nSpS);
%         W = W/max(abs(W));
%         for m = 1:nPol
%             Aout(m,:) = conv(upsample(Ain(m,:),nSpS),W,'same');
%         end
%         PS.W = W;
                
    otherwise
        error('Invalid Pulse Shaping Filter!');
end

