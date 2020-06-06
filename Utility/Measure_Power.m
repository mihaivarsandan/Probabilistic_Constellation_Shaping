function [out] = Measure_Power(in)
%MEASURE_POWER Summary of this function goes here
%   Detailed explanation goes here
out=mean(sqrt(mean(abs(in).^2,2)));
end

