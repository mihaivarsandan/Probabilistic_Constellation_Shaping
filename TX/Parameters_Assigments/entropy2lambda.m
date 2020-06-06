function [lambda] = entropy2lambda(H,M)

% Last Update: 14/03/2017


%% SNR vs MI Table
fileName = ['/Users/mihaivarsandan/Documents/Cambridge 4th year/Master Project/FernandoGuiomar-OptDSP-7a3e4b5/TOOLS/performanceMetrics/SNR2MI/',num2str(M) 'QAM'];
SNR_vs_MI = load(fileName);
H_LUT = SNR_vs_MI.MIs(end,:);
lambda_LUT = SNR_vs_MI.lambdas;

%% Linear interpolation to find the best-fit lambda for the query H values
lambda = interp1(H_LUT,lambda_LUT,H,'linear');
