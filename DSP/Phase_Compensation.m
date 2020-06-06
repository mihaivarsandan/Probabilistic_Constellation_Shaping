function [out] = Phase_Compensation(in,QAM,taps)
%PHASE_COMPENSATION Summary of this function goes here
%   Detailed explanation goes here
N=taps;
num=rem(size(in,1),N);
block = vec2mat(in,N);
M=QAM.M;
phase_prev=0;
c_prev=0;

if M==4   
    block_M = block.^M;
    sum_block = sum(block_M,2);
    phase = -1/M * angle(sum_block);
    for i=1:size(phase,1)
        if i==1
            m = floor(0.5-phase(i)*M/(2*pi));

        else
            m = floor(0.5+(phase(i-1)-phase(i))*M/(2*pi));
        end
        phase(i)= phase(i) + m*2*pi/M;
        block(i,:)=block(i,:).*exp(1i*phase(i));
    end
    
   

elseif M==16     
    for i=1:size(block,1)
        S_1=find(abs(block(i,:))>=1.17085 | abs(block(i,:))<=0.7236);
        
        phase = 1/4 * angle(sum(block(i,S_1).^4));
        if phase-phase_prev< -pi/4
            f=1;
        elseif phase-phase_prev >pi/4
            f=-1;
        else
            f=0;
        end
        
        c = c_prev + pi/2 * f;
        theta_est = phase + c;
        phase_prev=phase;
        c_prev=c;
        block(i,:)=block(i,:).*exp(-1i*theta_est);
    end                 

elseif M==64     
    for i=1:size(block,1)
        S_1=find(abs(block(i,:))>=1.42735 | abs(block(i,:))<=0.35305 | 0.57125<=abs(block(i,:))<=0.77715 | 0.9954<=abs(block(i,:))<=1.2092 );
        
        phase = 1/4 * angle(sum(block(i,S_1).^4));
        if phase-phase_prev< -pi/4
            f=1;
        elseif phase-phase_prev >pi/4
            f=-1;
        else
            f=0;
        end        
        c = c_prev + pi/2 * f;
        theta_est = phase + c;
        phase_prev=phase;
        c_prev=c;
        block(i,:)=block(i,:).*exp(-1i*theta_est);
    end                 
end

out = reshape(block.',[],1);
if num==0
    out = out(1:end);
else
    out=out(1:end-(N-num));
end
out = out*exp(-1i*pi/4); 
end

