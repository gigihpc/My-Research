RAW_COUNT = 0;
filterKALMAN = 3;
ToRadian = pi/180;
ToDegree = 180/pi;
GAMMA = 0.7;%2.43;
GAMMA_EXPAND = 2.43; %For RANGE > RANGE_MAINTAINANCE 
VARIAN_THETA = 1;%0.00001; %in degree, semakin besar value nilai R semakin kecil 
VARIAN_RANGE = 1;%1;%100; %in Nmi, semakin besar value nilai R semakin kecil 
CONTROL_TRACK = 0.014;
RANGE_MAINTAINANCE = 3; 
covMATRIX = 1;
RPM = 6;
Q_POSISI = 1/10^3;
Q_VELOCITY = 1/10^5;
IS_TIME = 0;
HEADING = 0;

TRACK_LIST = cell();
PREDICT_TRACKLIST = cell();
VELOCITY_TRACK = cell();
HEADING_TRACK = cell();