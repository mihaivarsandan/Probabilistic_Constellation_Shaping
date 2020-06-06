function [out,DSP] = Adaptive_Equaliser_2(in,QAM,DSP,TX)
%ADAPTIVE_EQUALISER_2 Summary of this function goes here
%   Detailed explanation goes here
K = double(int16(DSP.Adaptive_Equal_taps));
N = 2*K + 1;
x = [zeros(size(in,1),K), in,zeros(size(in,1),K)];
W =zeros(1,N);
%W(K+1)=1/sqrt(2)*(1+1j);
W(K+1)=1;
out = zeros(size(in));
error = zeros(1,size(in,2));
mu=DSP.Adaptive_Equal_mu;

for epoch=1:2
    if QAM.M==4
        for pol=1:size(in,1)
            for j=1:size(in,2)
                out(pol,j)=x(pol,j:j+N-1)*W.';
                error(j)= 1 - abs(out(pol,j)^2);
                W = W + 2*mu * error(j) * out(pol,j) * conj(x(pol,j:j+N-1)).*gausswin(N)';
            end
        end
        
    elseif QAM.M==16
        for pol=1:size(in,1)
            for j=1:size(in,2)
                out(pol,j)= x(pol,j:j+N-1)*W.';
                if abs(real(out(pol,j)))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_R = QAM.radius(1);
                elseif abs(real(out(pol,j)))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2
                    R_2_R = QAM.radius(2);
                else
                    R_2_R = QAM.radius(3);
                end

                if abs(imag(out(pol,j)))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_I = QAM.radius(1);
                elseif abs(imag(out(pol,j)))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2
                    R_2_I = QAM.radius(2);
                else
                    R_2_I = QAM.radius(3);
                end

                err_R=real(out(pol,j))*(abs(real(out(pol,j)))^2-R_2_R);
                err_I=imag(out(pol,j))*(abs(imag(out(pol,j)))^2-R_2_I);
                error(j)=err_R+1j*err_I;
                W = W - 2*mu *error(j)*conj(x(pol,j:j+N-1)).*gausswin(N)';
            end
        end
        
    elseif QAM.M==64
        for pol=1:size(in,1)
            for j=1:size(in,2)
                out(pol,j)= x(pol,j:j+N-1)*W.';
                if abs(real(out(pol,j)))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_R = QAM.radius(1);
                elseif abs(real(out(pol,j)))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 & abs(real(out(pol,j)))>(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2 
                    R_2_R = QAM.radius(2);
                elseif abs(real(out(pol,j)))<(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 & abs(real(out(pol,j)))>(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 
                    R_2_R = QAM.radius(3);
                elseif abs(real(out(pol,j)))<(sqrt(QAM.radius(4))+sqrt(QAM.radius(5)))/2 & abs(real(out(pol,j)))>(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 
                    R_2_R = QAM.radius(4);
                elseif abs(real(out(pol,j)))<(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 & abs(real(out(pol,j)))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(4)))/2 
                    R_2_R = QAM.radius(5);
                elseif abs(real(out(pol,j)))<(sqrt(QAM.radius(6))+sqrt(QAM.radius(7)))/2 & abs(real(out(pol,j)))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 
                    R_2_R = QAM.radius(6);
                else
                    R_2_R = QAM.radius(7);
                end

                if abs(imag(out(pol,j)))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_I = QAM.radius(1);
                elseif abs(imag(out(pol,j)))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 & abs(imag(out(pol,j)))>(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2 
                    R_2_I = QAM.radius(2);
                elseif abs(imag(out(pol,j)))<(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 & abs(imag(out(pol,j)))>(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 
                    R_2_I = QAM.radius(3);
                elseif abs(imag(out(pol,j)))<(sqrt(QAM.radius(4))+sqrt(QAM.radius(5)))/2 & abs(imag(out(pol,j)))>(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 
                    R_2_I = QAM.radius(4);
                elseif abs(imag(out(pol,j)))<(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 & abs(imag(out(pol,j)))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(4)))/2 
                    R_2_I = QAM.radius(5);
                elseif abs(imag(out(pol,j)))<(sqrt(QAM.radius(6))+sqrt(QAM.radius(7)))/2 & abs(imag(out(pol,j)))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 
                    R_2_I = QAM.radius(6);
                else
                    R_2_I = QAM.radius(7);
                end

                err_R=real(out(pol,j))*(abs(real(out(pol,j)))^2-R_2_R);
                err_I=imag(out(pol,j))*(abs(imag(out(pol,j)))^2-R_2_I);
                error(j)=err_R+1j*err_I;
                W = W - 2*mu *error(j)*conj(x(pol,j:j+N-1)).*gausswin(N)';
            end
        end
    end
       

    
end
out = out(:,K+1:end-K);
%out = out*exp(-1i* pi/4);
DSP.W_Equaliser=W;
DSP.Truncating=DSP.Truncating + K;
DSP.Equaliser_error=abs(error);


