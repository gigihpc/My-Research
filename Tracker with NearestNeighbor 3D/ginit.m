RAW_COUNT = 0;
filterKALMAN = 3;
ToRadian = pi/180;
ToDegree = 180/pi;
GAMMA = 0.7;%2.43;
GAMMA_EXPAND = 2.43;%2.43;%6.6;%3.6; %For RANGE > RANGE_MAINTAINANCE 
VARIAN_THETA = 1/10^2;%0.00001; %in degree
VARIAN_RANGE = 1/10^2;%0.5;%1;%100; %in Nmi
CONTROL_TRACK = 0.014;
VARIAN_ELEVATION = 1/10^2;
RANGE_MAINTAINANCE = 3; 
covMATRIX = 1;
RPM = 6;
Q_POSISI = 1/10^14;
Q_VELOCITY = 1/10^14;
Q_VELOCITY_Z = 1/10^14;
IS_TIME = 0;
HEADING = 0;
B1= exp(-VARIAN_THETA/2);
B2= exp(-VARIAN_ELEVATION/2);
KNOT_TO_FEETPERMENIT = 101.269;
ALTITUDE_FEET_TO_NMI = 100*0.000164579;

TRACK_LIST = cell();
PREDICT_TRACKLIST = cell();
VELOCITY_TRACK = cell();
HEADING_TRACK = cell();