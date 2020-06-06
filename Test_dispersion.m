Tmax = 20.00; 
N = 0128;
T0 = 1.0; 
beta2 = +25; 
z = 0.07;
C= +0.0;

v= linspace(0,N-1,N);
dT = Tmax/N;
T = -Tmax/2 + v*dT;
dOmega = 2*pi/Tmax;

p = find(v > floor(N/2));

v(p) = v(p)-N;
Omega = v*dOmega
return


A = exp(-((1+1i*C)/2)*(T/T0).^2); 
A0 = A;
% Gaussian input pulse
% copy the initial Gaussian
% % % These three lines set up the frequency grid in the storage form employed by Matlab.

At0 = fft(A);
Atilde = At0.*exp(1i*beta2*Omega.^2*z/2);
A = ifft(Atilde);

plot(T,abs(A).^2,T,abs(A0).^2,'--'); 
set(gca,'FontSize',15);
xlabel('T (ps)');
ylabel('|A(z,T)|^2');
title('Initial pulse (dash) final pulse (solid)');