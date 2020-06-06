function [const,M,symbolMap,MF] = QAM_loadConstellation(MF)

% Last Update: 22/06/2017


%% Assign Modulation Format

if ~isempty(strfind(MF,'64QAM'))
    MF = '64QAM';
    M = 64;
elseif ~isempty(strfind(MF,'16QAM'))
    MF = '16QAM';
    M = 16;
elseif ~isempty(strfind(MF,'QPSK'))
    MF = 'QPSK';
    M = 4;
end

%% Load Constellation
load(['/Users/mihaivarsandan/Desktop/Cambridge/Cambridge 4th year/Master Project/Master Project 2.0/TX/Constellations/',MF])
const = Constellation;
symbolMap = Symbol_Mapping;
