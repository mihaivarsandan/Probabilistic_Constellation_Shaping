function out= AWGN(in,Es_No)
%AWGN Summary of this function goes here
%   Detailed explanation goes here
noise_std =sqrt(1/(2*Es_No));
noise_real=noise_std.*randn(size(in));
noise_imag=noise_std.*randn(size(in));
out = in + noise_real + 1i * noise_imag;
end

