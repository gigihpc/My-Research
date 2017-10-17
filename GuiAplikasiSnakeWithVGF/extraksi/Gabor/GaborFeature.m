function [featureVector] = GaborFeature(img)
% img = imread('cameraman.tif');
[n,m] = size(img);
n = factor(n);
m = factor(m);
gaborArray = gaborFilterBank(5,8,39,39);  % Generates the Gabor filter bank
featureVector = gaborFeatures(img,gaborArray,n(1),m(1));   % Extracts Gabor feature vector, 'featureVector', from the image, 'img'.