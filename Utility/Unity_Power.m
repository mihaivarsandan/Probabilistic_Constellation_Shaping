function [out] = Unity_Power(in)
%UNITY_POWER Summary of this function goes here
%   Detailed explanation goes here
power=mean(sqrt(mean(abs(in).^2,2)));
out=in./power;
end

