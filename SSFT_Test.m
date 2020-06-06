clc; clear all; close all; clf;
cputime=0;
tic;
ln=1;
i=sqrt(-1);
Po=.00064; %input pwr in watts
alpha=0; % Fiber loss value in dB/km
alph=alpha/(4.343); %Ref page#55 eqn 2.5.3 Fiber optic Comm by GP Agrawal
gamma=0.00003; %fiber non linearity in /W/m
to=125e-12; %initial pulse width in second
C=-2; %Input chirp parameter for first calculation
b2=-20e-27; %2nd order disp. (s2/m)
Ld=(to^2)/(abs(b2)); %dispersion length in meter
pi=3.1415926535;
Ao=sqrt(Po); %Amplitude
%----------------------------------------------------------
tau =- 4096e-12:1e-12: 4095e-12;%  dt=t/to
 dt=1e-12;
 rel_error=1e-5;
 h=1000;% step size
for ii=0.1:0.1:1.5 %the various fiber lengths can be varied and this vector can be changed
z=ii*Ld
    u=Ao*exp(-((1+i*(-C))/2)*(tau/to).^2);%page#47 G.P.AGrawal
    figure(1)
   plot(abs(u),'r');
   title('Input Pulse'); xlabel('Time'); ylabel('Amplitude');
grid on;
hold on;
l=max(size(u));  
%%%%%%%%%%%%%%%%%%%%%%%
fwhm1=find(abs(u)>abs(max(u)/2));
fwhm1=length(fwhm1);
dw=1/l/dt*2*pi;
w=(-1*l/2:1:l/2-1)*dw;
u=fftshift(u);
 w=fftshift(w);
spectrum=fft(fftshift(u)); %Pulse spectrum
for jj=h:h:z
spectrum=spectrum.*exp(-alph*(h/2)+i*b2/2*w.^2*(h/2)) ; 
f=ifft(spectrum);
f=f.*exp(i*gamma*((abs(f)).^2)*(h));
spectrum=fft(f);
spectrum=spectrum.*exp(-alph*(h/2)+i*b2/2*w.^2*(h/2)) ; 
end
f=ifft(spectrum);
op_pulse(ln,:)=abs(f);%saving output pulse at all intervals
fwhm=find(abs(f)>abs(max(f)/2));
fwhm=length(fwhm);
ratio=fwhm/fwhm1; %PBR at every value
pbratio(ln)=ratio;%saving PBR at every step size
dd=atand((abs(imag(f)))/(abs(real(f))));
phadisp(ln)=dd;%saving pulse phase
ln=ln+1;
end
toc;
cputime=toc;
figure(2);
mesh(op_pulse(1:1:ln-1,:));
title('Pulse Evolution');
xlabel('Time'); ylabel('distance'); zlabel('amplitude');
figure(3)
plot(pbratio(1:1:ln-1),'k');
xlabel('Number of steps');
ylabel('Pulse broadening ratio');
grid on;
hold on;
figure(5)
plot(phadisp(1:1:ln-1),'k');
xlabel('distance travelled');
ylabel('phase change');
grid on;
hold on;
disp('CPU time:'), disp(cputime);