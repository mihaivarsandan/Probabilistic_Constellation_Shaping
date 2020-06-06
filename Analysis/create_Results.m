function [Results] = create_Results(Channel,TX)
%CREATE_RESULTS Summary of this function goes here
%   Detailed explanation goes here
Results.Transmission_Goal=Channel.Transmission_Goal;
Results.BER_Practice=zeros(size(Channel.Es_No));
Results.MI=zeros(size(Channel.Es_No));
Results.H_X=zeros(size(Channel.Es_No));
Results.H_Y=zeros(size(Channel.Es_No));
Results.Shannon = log2(ones(size(Channel.Es_No))+Channel.Es_No);

if TX.QAM.M==4  
    Results.BER_Theoretical =  1/2 * erfc(sqrt(Channel.Es_No./2));
elseif TX.QAM.M==16
    Results.BER_Theoretical =  3/8 * erfc(sqrt(Channel.Es_No./10));
elseif TX.QAM.M==64
    Results.BER_Theoretical = 7/24 * erfc(sqrt(Channel.Es_No./42));
end

end

