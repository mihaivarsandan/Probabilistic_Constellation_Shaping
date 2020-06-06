clear
close all 
%% Parameter Setup
alpha=0.09210;
%alpha=0;
gamma=1.3;
Beta_2 = -22.4 *1e-24;
%Beta_2=0;
Oversampling_Factor=8;
Bit_Rate= 200*1e9;
M=4;
Symbol=1/sqrt(2) + 1i * (1/sqrt(2));

%% Calculating the Sampling Rate
Symbol_Rate = Bit_Rate / log2(M);
T_symbol = 1/Symbol_Rate;
Sampling_Rate = 2 * Oversampling_Factor/ T_symbol;
dT = 1/Sampling_Rate;
SpS=2*Oversampling_Factor;


%% Creating the pulse
pulse = rcosdesign(0.5,6,SpS,'sqrt');
Signal=upfirdn(Symbol,pulse,SpS);
N=size(Signal,2);

t=0:dT:(N-1)*dT;
dW=2*pi/dT/N;
w=zeros(size(t));
w(1:(N+1)/2)=(0:1:(N-1)/2)*dW;
w((N+1)/2+1:end)=flip(-1*(1:1:(N-1)/2)*dW);
% w=(-(N-1)/2:1:(N-1)/2)*dW;
%  unique(angle(Signal));
%  Spectrum_Signal=fft(Signal);
%  Signal_Recovered=ifft(Spectrum_Signal);
%  plot(t./T_symbol,abs(Signal_Recovered))
%  figure()
%  plot(w,abs(Spectrum_Signal))
%  figure()
%  plot(t./T_symbol,abs(Signal))

Signal_Init=Signal;
Steps=1000;
Stepsize=50;
Amplification_Spacing=100;
h=1;

Signal_L=zeros(Steps/Stepsize+1,N);
Signal_L(1,:)=Signal_Init;

Phase =zeros(Steps+1,1);
Amplitude=zeros(size(Phase));
Phase(1,:) =angle(Signal_Init(:,(N+1)/2))/pi*180;
Amplitude(1,:)=abs(Signal_Init(:,(N+1)/2)^2);


for L=1:h:Steps

%Calculating Linear and Non-Linear Term
Non_Linear_Term =exp(-1i*h*gamma*abs(Signal).^2);  
Linear_Term = exp(-(1i*Beta_2* w.^2+alpha*ones(size(w)))*h/2);

% Apply SSFT
Fourier_Signal =fft(Signal.*Non_Linear_Term);
Signal =ifft(Fourier_Signal.*Linear_Term);


Phase(L+1,:)=angle(Signal(:,(N+1)/2))/pi*180;
Amplitude(L+1,:)=abs(Signal(:,(N+1)/2)^2);

%if rem(L,200)==0
    %Signal=ifft(fft(Signal).*exp(1i*Beta_2*w.^2*h*200/2));
%end

if rem(L,Amplification_Spacing)==0
    %Amplyfying by 20dB
    Signal =Signal * 100;
end


if rem(L,Stepsize)==0
        
    %Assigment
    Signal_L(L/Stepsize+1,:)=Signal;
end

end


L_vec=(0:Stepsize:Steps);

figure()
waterfall(t,L_vec,abs(Signal_L))

figure()
plot(Phase)

figure()
plot(Amplitude)







