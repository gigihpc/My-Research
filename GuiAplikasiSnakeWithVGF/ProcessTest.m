function [identifikasi, akurasi] = ProcessTest(network, datatest,kelas,fiturPerKelas)

Y = sim(network,datatest);
len_dttest=size(datatest);
akurasi=0;
identifikasi=0;

if len_dttest(2) > 1
    dist=0;
    correct=0;
    j=1;i=1;
    norm = round(Y);
    % tambahan
    hwb = waitbar (0, 'Proses Testing....', 'Name', 'Kelompok: Voice Recogintion');
    
    while(i<length(kelas))
        loop=length(kelas)/(length(norm)*2);
        while(loop>0)
            dist=sum((kelas(:,i)-norm(:,j)).^2)*0.5;
            if dist < 1.4 %< 1.4 sqrt(2) %==0% 
                correct=correct+1;
            end
            loop=loop-1;
            j=j+1;
            waitbar (i/length(kelas), hwb);
        end
        i=i+fiturPerKelas;
        waitbar (i/length(kelas), hwb);
    end
    close (hwb);
    correct
    akurasi=(correct/(length(norm)))*100
else
    mindist=100;
    for i=1:length(kelas)
        dist=sum((kelas(:,i)-Y(:,1)).^2)*0.5;
        if dist < mindist
            mindist=dist;
            identifikasi=i;
        end
    end
    identifikasi = ceil(identifikasi/fiturPerKelas);
end