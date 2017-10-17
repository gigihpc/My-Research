clc; clear all; close all;
load DataTrain.txt
dtTrain = size(DataTrain);
for i=1:dtTrain(2)%kolom
    maxvalue = max(DataTrain(:,i));
    minvalue = min(DataTrain(:,i));
    for j=1:dtTrain(1)%baris
        norm_DataTrain(j,i) = (DataTrain(j,i)- minvalue)/(maxvalue-minvalue);
    end
end
fiturPerKelas = 35;
[net, kelas]= ProcessIdentifikasi(norm_DataTrain, fiturPerKelas);

load DataTest.txt
dtTest = size(DataTest);
for i=1:dtTest(2)%kolom
    maxvalue = max(DataTest(:,i));
    minvalue = min(DataTest(:,i));
    for j=1:dtTest(1)%baris
        norm_datatest(j,i) = (DataTest(j,i)- minvalue)/(maxvalue-minvalue);
    end
end
[identifikasi, akurasi] = ProcessTest(net, norm_datatest,kelas,fiturPerKelas);