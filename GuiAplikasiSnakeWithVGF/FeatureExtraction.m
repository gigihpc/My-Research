function [stats, result1, result2, result3, result4, Gabor, LBP] = FeatureExtraction(I)
% tambahkah fungsi yang ada di folder
% extraksi
addpath extraksi/efficientLBP
addpath extraksi/Gabor
addpath extraksi/Log

I

% GLCM
% I = imread('circuit.tif');
dataAkhir = zeros(1,16);

GLCM2 = graycomatrix(I,'Offset',[0 1]);
stats = graycoprops(GLCM2,{'all'});

ar1 = mean2(stats.Contrast(1,:))
ar2 = mean2(stats.Correlation(1,:))
ar3 = mean2(stats.Energy(1,:))
ar4 = mean2(stats.Homogeneity(1,:))

dataAkhir(1,1) = ar1;
dataAkhir(1,2) = ar2;
dataAkhir(1,3) = ar3;
dataAkhir(1,4) = ar4;
% Laplacian Gaussian with mean, standard deviation, skewness and kurtosis
% values = 0.25, 0.50, 1, and 2
% I = imread('circuit.tif');
%h1 = fspecial('log',[1 4],0.25);
%result1 = filter2(h1,I);

%h2 = fspecial('log',[1 4],0.5);
%result2 = filter2(h2,I);

%h3 = fspecial('log',[1 4],1);
%result3 = filter2(h3,I);

%h4 = fspecial('log',[1 4],2);
%result4 = filter2(h4,I);

LOG = kp_log(I,25);
menLog = abs(mean2(LOG(:,2:3)));
stdLog = abs(std2(LOG(:,2:3)))
skeLog = abs(mean2(skewness(LOG(:,2:3))))
kurLog = abs(mean2(kurtosis(LOG(:,2:3))))

dataAkhir(1,5) = menLog;
dataAkhir(1,6) = stdLog;
dataAkhir(1,7) = skeLog;
dataAkhir(1,8) = kurLog;

% GaborFeature
Gabor = abs(GaborFeature(I));
menGab = abs(mean2(Gabor));
stdGab = abs(std2(Gabor));
skeGab = abs(mean2(skewness(Gabor)));
kurGab = abs(mean2(kurtosis(Gabor)));

dataAkhir(1,9) = menGab;
dataAkhir(1,10) = stdGab;
dataAkhir(1,11) = skeGab;
dataAkhir(1,12) = kurGab;


%Local Binary Pattern
LBP = efficientLBP(I);
lbp = im2double(LBP);

menLbp = abs(mean2(lbp));
stdLbp = abs(std2(lbp));
skeLbp = abs(mean2(skewness(lbp)));
kurLbp = abs(mean2(kurtosis(lbp)));

dataAkhir(1,13) = menLbp;
dataAkhir(1,14) = stdLbp;
dataAkhir(1,15) = skeLbp;
dataAkhir(1,16) = kurLbp;


%save _hasilTxt/hasilExtraksi.txt dataAkhir -ascii;
fid = fopen('_hasilTxt/hasilExtraksi.txt', 'a+');
fprintf (fid, '%.4f\t', dataAkhir);
fprintf (fid, '\n');
% 