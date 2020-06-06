function [out,DSP] = Adaptive_Equaliser(in,QAM,DSP)
%EQUALISATION Summary of this function goes here
%   Detailed explanation goes here
k = 16;
M = 2*k + 1;
N = size(in,2);
nPol=size(in,1);
K=N-M+1;
Signal=in;
mu = 0.002;
X=zeros(M,K,nPol);
for j=1:nPol
    for i=1:K
        X(:,i,j)=Signal(j,i+M-1:-1:i);
    end
end
W = zeros(M,1);
W(k+1) = 1/sqrt(2)*(1+1j);
%W(2)=1 + 0*i;


error=ones(size(in,2),1);
for epoch=1:1
    if QAM.M==4
        for j=1:nPol
            for i=1:K
                y= W.'*X(:,i,j);
                error(i)  =y*(1-abs(y)^2);
                error(i);
                W = W + mu * conj(error(i)) *X(:,i,j);            
            end
        end
            
    elseif QAM.M==16
        for j=1:nPol
            for i=1:K
                y= W'*X(:,i,j);
                if abs(real(y))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_R = QAM.radius(1);
                elseif abs(real(y))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2
                    R_2_R = QAM.radius(2);
                else
                    R_2_R = QAM.radius(3);
                end

                if abs(imag(y))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_I = QAM.radius(1);
                elseif abs(imag(y))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2
                    R_2_I = QAM.radius(2);
                else
                    R_2_I = QAM.radius(3);
                end

                err_R=real(y)*(abs(real(y))^2-R_2_R);
                err_I=imag(y)*(abs(imag(y))^2-R_2_I);
                error(i)=err_R+1j*err_I;
                W = W - mu * conj(error(i)) *X(:,i,j);
            end
        end
            
    elseif QAM.M==64
        for j=1:nPol
            for i=1:K
                y= W'*X(:,i,j);
                if abs(real(y))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_R = QAM.radius(1);
                elseif abs(real(y))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 & abs(real(y))>(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2 
                    R_2_R = QAM.radius(2);
                elseif abs(real(y))<(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 & abs(real(y))>(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 
                    R_2_R = QAM.radius(3);
                elseif abs(real(y))<(sqrt(QAM.radius(4))+sqrt(QAM.radius(5)))/2 & abs(real(y))>(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 
                    R_2_R = QAM.radius(4);
                elseif abs(real(y))<(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 & abs(real(y))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(4)))/2 
                    R_2_R = QAM.radius(5);
                elseif abs(real(y))<(sqrt(QAM.radius(6))+sqrt(QAM.radius(7)))/2 & abs(real(y))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 
                    R_2_R = QAM.radius(6);
                else
                    R_2_R = QAM.radius(7);
                end

                if abs(imag(y))<(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2
                    R_2_I = QAM.radius(1);
                elseif abs(imag(y))<(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 & abs(imag(y))>(sqrt(QAM.radius(1))+sqrt(QAM.radius(2)))/2 
                    R_2_I = QAM.radius(2);
                elseif abs(imag(y))<(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 & abs(imag(y))>(sqrt(QAM.radius(2))+sqrt(QAM.radius(3)))/2 
                    R_2_I = QAM.radius(3);
                elseif abs(imag(y))<(sqrt(QAM.radius(4))+sqrt(QAM.radius(5)))/2 & abs(imag(y))>(sqrt(QAM.radius(3))+sqrt(QAM.radius(4)))/2 
                    R_2_I = QAM.radius(4);
                elseif abs(imag(y))<(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 & abs(imag(y))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(4)))/2 
                    R_2_I = QAM.radius(5);
                elseif abs(imag(y))<(sqrt(QAM.radius(6))+sqrt(QAM.radius(7)))/2 & abs(imag(y))>(sqrt(QAM.radius(5))+sqrt(QAM.radius(6)))/2 
                    R_2_I = QAM.radius(6);
                else
                    R_2_I = QAM.radius(7);
                end

                err_R=real(y)*(abs(real(y))^2-R_2_R);
                err_I=imag(y)*(abs(imag(y))^2-R_2_I);
                error(i)=err_R+1j*err_I;
                W = W - mu * conj(error(i)) *X(:,i,j);
            end
        end
    end
end

out=filter(W,1,Signal.').';
out=out(:,k+1:end-k);
DSP.W_Equaliser=W;
DSP.Truncating=k;
DSP.Equaliser_error=abs(error);
end

