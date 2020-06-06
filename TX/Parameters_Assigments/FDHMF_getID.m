function [modFormat] = FDHMF_getID(M,nPol)
% FDHMF_getID   Get ID for FDHMF signal
%   This function generates an ID of the for M-M-...-M-M for a given FDHMF
%   signal.
%
%   INPUTS:
%   M       :=  QAM constellation sizes [1 x nSC]
%   lambda  :=  shaping parameter for constellation shaping [1 x nSC]
%
%   OUTPUTS:
%   ID      :=  string identifying the FDHMF format
%   MF      :=  cell array of string identifying the modulation format of
%               each FDHMF subcarrier [1 x nSC]
%
%
%   Examples:
%       [ID,MF] = FDHMF_getID([8 8 16 32 16 8 8]);
%       [ID,MF] = FDHMF_getID([8 8 16 32 16 8 8],[0 0.1 0.5 0.7 0.6 0.9]);
%
%
%   Author: Fernando Guiomar
%   Last Update: 24/06/2017


%% Set FDHMF Modulation Formats
%     if nargin==2 && any(lambda)
%         MF_prefix = 'PS:PM-';

if nPol==2
    MF_prefix = 'DP-';
else
    MF_prefix = 'PM-';
end
    
if M==4
    modFormat = [MF_prefix,'QPSK'];
else
    modFormat = [MF_prefix,num2str(M),'QAM'];
end
   
end
