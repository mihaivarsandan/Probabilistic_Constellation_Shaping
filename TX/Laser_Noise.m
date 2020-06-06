function [out,PS] = Laser_Noise(in,PS,TX)
%LASER_NOISE Summary of this function goes here
%   Detailed explanation goes here
    var = PS.linewidth/(2*pi) *TX.PARAM.sampRate;
    mean = zeros(1,size(in,2));
    std =sqrt(var);
    phi_del = mean + std * randn(1,size(in,2))/TX.PARAM.sampRate;
    phi = zeros(1,size(in,2));
    out = zeros(size(in));
    out(:,1) = in(:,1).*exp(1i*phi(:,1));
    for j=1:(size(in,2)-1)
        phi(:,j+1)=phi(:,j)+phi_del(:,j);
        out(:,j+1)=in(:,j+1).*exp(1i*phi(:,j+1));
    end
    PS.phase_deviation=phi;
end

