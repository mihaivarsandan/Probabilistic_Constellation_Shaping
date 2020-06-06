function [out] = Downsample(in,factor)
out =zeros(size(in(:,1:factor:end)));%Downsample
for j=1:size(in,1)
    out(j,:)=decimate(in(j,:),factor);
end 
end

