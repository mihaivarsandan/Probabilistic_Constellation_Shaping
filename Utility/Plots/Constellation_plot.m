function [] = Constellation_plot(symbols)
%CONSTELLATION_PLOT Summary of this function goes here
%   Detailed explanation goes here
figure()
scatter(real(symbols(1,:)),imag(symbols(1,:)))
xlabel("In-Phase")
ylabel("Quadrature")
drawnow()
end

