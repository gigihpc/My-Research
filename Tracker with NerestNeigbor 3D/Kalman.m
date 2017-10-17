function [predicted innovation SPlus] = Kalman(data)
globals;

b1 = B1;
b2 = B2;
xhat =[b1^-1*b2^-1*data(1,1)*cos(data(1,2)*ToRadian)*cos(data(1,4)*ToRadian); 
       b1^-1*b2^-1*data(1,1)*sin(data(1,2)*ToRadian)*cos(data(1,4)*ToRadian);
       b1^-1*data(1,1)*sin(data(1,4)*ToRadian);
       0;
       0;
       0]; % state input 
T = RPM; %dt input
Q = [Q_POSISI 0 0 0 0 0;
     0 Q_POSISI 0 0 0 0;
     0 0 Q_POSISI 0 0 0;
     0 0 0 Q_VELOCITY 0 0;
     0 0 0 0 Q_VELOCITY 0;
     0 0 0 0 0 Q_VELOCITY_Z];
H = [1 0 0 0 0 0;
     0 1 0 0 0 0;
     0 0 1 0 0 0]; %Measurement Matrix
Pplus = [1 0 0 0 0 0;
         0 1 0 0 0 0;
         0 0 1 0 0 0;
         0 0 0 1 0 0;
         0 0 0 0 1 0;
         0 0 0 0 0 1]*20;

ThetaBar = [];
Rangebar = [];
VarTheta = 0;
VarRange = 0;
oriArray =[];
xhatArray =[];
InnovationArray =[];
CovarianArray =[];
ElementEllipAArray = [];

for i=1:length(data(:,1))-1

 if(IS_TIME == 1)
  T = (data(i+1,3)-data(i,3))/1000;
 else
  T = (data(i+1,3)-data(i,3));
 end
%  end
  
%  Rangebar = [Rangebar data(i,1)];
%  ThetaBar = [ThetaBar data(i,2)];
%  VarRange = VARIAN_RANGE;%std(Rangebar)^2;
%  VarTheta = VARIAN_THETA;%std(ThetaBar)^2;
%  end
  VarRange = VARIAN_RANGE;%std(Rangebar)^2;
  VarTheta = VARIAN_THETA;%std(ThetaBar)^2;

  F = [1 0 0 T 0 0; 
       0 1 0 0 T 0;
       0 0 1 0 0 T;
       0 0 0 1 0 0;
       0 0 0 0 1 0;
       0 0 0 0 0 1]; %State Transisi
       
  R11 = ((b1*b2)^-2 - 2)*data(i,1)^2*cos(data(i,2)*ToRadian)^2*cos(data(i,4)*ToRadian)^2 +...
        1/4*(data(i,1)^2+VARIAN_RANGE)*(1+b1^4*cos(2*data(i,2)*ToRadian))*(1+b2^4*cos(2*data(i,4)*ToRadian));
  R22 = ((b1*b2)^-2 - 2)*data(i,1)^2*sin(data(i,2)*ToRadian)^2*cos(data(i,4)*ToRadian)^2 +...
        1/4*(data(i,1)^2+VARIAN_RANGE)*(1-b1^4*cos(2*data(i,2)*ToRadian))*(1+b2^4*cos(2*data(i,4)*ToRadian));
  R33 = (b2^-2 - 2)*data(i,1)^2*sin(data(i,4)*ToRadian)^2 + 1/2*(data(i,1)^2+VARIAN_RANGE)*(1-b2^4*cos(2*data(i,4)*ToRadian));
  R12 = ((b1*b2)^-2 - 2)*data(i,1)^2*sin(data(i,2)*ToRadian)*cos(data(i,2)*ToRadian)*cos(data(i,4)*ToRadian)^2 +...
        1/4*(data(i,1)^2+VARIAN_RANGE)*b1^4*sin(2*data(i,2)*ToRadian)*(1+b2^4*cos(2*data(i,4)*ToRadian));
  R13 = (b1^-1*b2^-2 - b1^-1 - b1)*data(i,1)^2*cos(data(i,2)*ToRadian)*sin(data(i,4)*ToRadian)*cos(data(i,4)*ToRadian)+...
        1/2*(data(i,1)^2+VARIAN_RANGE)*b1*b2^4*cos(data(i,2)*ToRadian)*sin(2*data(i,4)*ToRadian);
  R23 = (b1^-1*b2^-1 - b1^-1 - b1)*data(i,1)^2*sin(data(i,2)*ToRadian)*sin(data(i,4)*ToRadian)*cos(data(i,4)*ToRadian)+...
        1/2*(data(i,1)^2+VARIAN_RANGE)*b1*b2^4*sin(data(i,2)*ToRadian)*sin(2*data(i,4)*ToRadian);

  R = [R11 R12 R13;
       R12 R22 R23;
       R13 R23 R33];

  %Predict     
  xhat = F * xhat;
  Pminus = F * Pplus * F' + Q;
  predicted = xhat;
%  xhatArray =[xhatArray xhat];
   
  %Correct
  K = Pminus * H' * inv(H * Pminus * H' + R);
  SPlus = inv(H * Pminus * H' + R); %covarian matrix
  CovarianArray = [CovarianArray SPlus]; 
  y = [b1^-1*b2^-1*data(i+1,1)*cos(data(i+1,2)*ToRadian)*cos(data(i+1,4)*ToRadian); 
       b1^-1*b2^-1*data(i+1,1)*sin(data(i+1,2)*ToRadian)*cos(data(i+1,4)*ToRadian);
       b1^-1*data(i+1,1)*sin(data(i+1,4)*ToRadian)];
  xhat = xhat + K * (y - H * xhat);
%  predicted = xhat;
  innovation = y - H * xhat;
  InnovationArray = [InnovationArray innovation];
  Pplus = (eye(6) - K * H) * Pminus * (eye(6) - K * H)' + K * R * K';
  
  RA = sqrt(SPlus(2,2))*sqrt((GAMMA - (SPlus(1,2)+SPlus(2,1))*innovation(1,:)*innovation(2,:))/SPlus(1,1)*SPlus(2,2));
  RB = sqrt(SPlus(1,1))*sqrt((GAMMA - (SPlus(1,2)+SPlus(2,1))*innovation(1,:)*innovation(2,:))/SPlus(1,1)*SPlus(2,2));
  
%  thetaEllip = 0;
%  if(length(xhatArray(1,:)) ==1)
%    thetaEllip = atan(xhatArray(2,:)/xhatArray(1,:))*ToDegree;
%  else
%     for theta=length(xhatArray(1,:)):length(xhatArray(1,:))
%        thetaEllip = atan((xhatArray(2,theta)-xhatArray(2,theta-1))/(xhatArray(1,theta)-xhatArray(1,theta-1)))*ToDegree;
%     end
%  end
%  drawEllip = [xhat(1,:) xhat(2,:) RA RB thetaEllip];
%  ElementEllipAArray =[ElementEllipAArray;drawEllip];

  oriArray =[oriArray y];
  xhatArray =[xhatArray xhat];

end