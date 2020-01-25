function [predicted xhat Pplus SPlus] = Kalman(data)

globals;

if(IS_BIAS == 0 && covMATRIX != 3)
  b1 = 1;
else
  b1 = BIAS;
end

xhat =[b1^-1*data(1,1)*cos(data(1,2)*ToRadian); b1^-1*data(1,1)*sin(data(1,2)*ToRadian); 0; 0]; % state input 
T = RPM; %dt input
Q = [Q_POSISI 0 0 0;
     0 Q_POSISI 0 0;
     0 0 Q_VELOCITY 0;
     0 0 0 Q_VELOCITY];
H = [1 0 0 0;
     0 1 0 0]; %Measurement Matrix
Pplus = [1 0 0 0;
         0 1 0 0;
         0 0 1 0;
         0 0 0 1]*20;

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
%  if(i==1)
%  Rangebar = [Rangebar data(i,1)];
%  ThetaBar = [ThetaBar data(i,2)];
%  continue;
%  else
  
%  if(length(data(:,1))==2 && i==2)
%    T = (data(i,3)-data(i-1,3));
%  else
%   if(length(data(:,1))==2)
%    i = i-1;
%   end
%   if(length(data(:,1))==3 && i==4)
%    i = i-1;
%   end
%   if(i>length(data(:,1)))
%      i=i-1;
%   end 
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

  F = [1 0 T 0; 
       0 1 0 T;
       0 0 1 0;
       0 0 0 1]; %State Transisi
       
  if(covMATRIX == 1) %Ra -->
    R11 = data(i,1)^2 * exp(-2*VarTheta) *(cos(data(i,2)*ToRadian)^2*(cosh(2*VarTheta*ToRadian) - cosh(VarTheta*ToRadian))...
          + sin(data(i,2)*ToRadian)^2*(sinh(2*VarTheta*ToRadian)-sinh(VarTheta*ToRadian))) + VarRange * exp(-2*VarTheta)...
          *(cos(data(i,2)*ToRadian)^2*(2*cosh(2*VarTheta*ToRadian)-cosh(VarTheta*ToRadian)) + sin(data(i,2)*ToRadian)^2*(2*sinh(2*VarTheta*ToRadian)-sinh(VarTheta*ToRadian)));
    R22 = data(i,1)^2 * exp(-2*VarTheta)*(sin(data(i,2)*ToRadian)^2*(cosh(2*VarTheta*ToRadian)-cosh(VarTheta*ToRadian) + ...
          cos(data(i,2)*ToRadian)*(2*sinh(VarTheta*ToRadian)-sinh(VarTheta*ToRadian))) + VarRange * exp(-2*VarTheta)...
          *(sin(data(i,2)*ToRadian)^2 *(2*cosh(2*VarTheta*ToRadian)-cosh(VarTheta*ToRadian)) + cos(data(i,2)*ToRadian)^2*(2*sinh(2*VarTheta*ToRadian)-sinh(VarTheta*ToRadian))));
    R12 = sin(data(i,2)*ToRadian)*cos(data(i,2)*ToRadian)*exp(-4*VarTheta)*(VarRange+(data(i,1)^2+VarRange)*(1-exp(-VarTheta)));
    
  elseif(covMATRIX == 2)%Rt--> untuk range besar dan kesalahan bearing besar
    R11 = data(i,1)^2 * exp(-VarTheta)*(cos(data(i,2)*ToRadian)^2*(cosh(VarTheta*ToRadian)-1) + sin(data(i,2)*ToRadian)^2*sinh(VarTheta*ToRadian)) +...
          VarRange*exp(-VarTheta) * (cos(data(i,2)*ToRadian)^2 * cosh(VarTheta*ToRadian) + sin(data(i,2)*ToRadian)^2*sinh(VarTheta*ToRadian));
    R22 = data(i,1)^2 * exp(-VarTheta)*(sin(data(i,2)*ToRadian)^2*(cosh(VarTheta*ToRadian)-1) + cos(data(i,2)*ToRadian)^2 * sinh(VarTheta*ToRadian)) +...
          VarRange*exp(-VarTheta) * (sin(data(i,2)*ToRadian)^2*cosh(VarTheta*ToRadian) + cos(data(i,2)*ToRadian)^2*sinh(VarTheta*ToRadian));
    R12 = sin(data(i,2)*ToRadian) * cos(data(i,2)*ToRadian) * exp(-2*VarTheta) *(VarRange + data(i,1)^2*(1-exp(-VarTheta)));
    
  elseif(covMATRIX == 3)
    R11 = (b1^-2 - 2)*data(i,1)^2*cos(data(i,2)*ToRadian)^2 + (data(i,1)^2+VARIAN_RANGE)*(1+b1^4*cos(2*data(i,2)*ToRadian))/2;
    R22 = (b1^-2 - 2)*data(i,1)^2*sin(data(i,2)*ToRadian)^2 + (data(i,1)^2+VARIAN_RANGE)*(1-b1^4*cos(2*data(i,2)*ToRadian))/2;
    R12 = (b1^-2*(data(i,1)^2)/2 + (data(i,1)^2+VARIAN_RANGE)*(b1^4)/2 - data(i,1)^2)*sin(2*data(i,2)*ToRadian);
    
  else %RL --> kesalahan karena linierisasi
    R11 = data(i,1)^2 * VarTheta * sin(data(i,2)*ToRadian)^2 + VarRange * cos(data(i,2)*ToRadian)^2;
    R22 = data(i,1)^2 * VarTheta * cos(data(i,2)*ToRadian)^2 + VarRange * sin(data(i,2)*ToRadian)^2;
    R12 = (VarRange^2 - data(i,1)^2*VarTheta) * sin(data(i,2)*ToRadian)^2*cos(data(i,2)*ToRadian)^2;

  end  
%  if(i==2)
    R = [R11 R12;
         R12 R22];
%  end
%      R = eye(2);
  
  %Handle Predict 
%  temp_T =T;
%  while(temp_T>6)
%  T=(data(i,3)-data(i-1,3));;
%  F = [1 0 T 0; 
%       0 1 0 T;
%       0 0 1 0;
%       0 0 0 1]; %State Transisi
%       
%  %Predict     
%  xhat = F * xhat;
%  Pminus = F * Pplus * F' + Q;
%  predicted = xhat;
%
%  temp_T = temp_T-6;
%  %xhatArray =[xhatArray xhat];
%  end
%  T=temp_T;
  F = [1 0 T 0; 
       0 1 0 T;
       0 0 1 0;
       0 0 0 1]; %State Transisi
  %End handle   

  %Predict     
  xhat = F * xhat;
  Pminus = F * Pplus * F' + Q;
  predicted = xhat;
%  xhatArray =[xhatArray xhat];
   
  %Correct
  K = Pminus * H' * inv(H * Pminus * H' + R);
  SPlus = H * Pminus * H' + R; %covarian matrix
  CovarianArray = [CovarianArray SPlus]; 
  y = [b1^-1*data(i+1,1)*cos(data(i+1,2)*ToRadian); b1^-1*data(i+1,1)*sin(data(i+1,2)*ToRadian)];
  xhat = xhat + K * (y - H * xhat);
%  predicted = xhat;
  innovation = y - H * xhat;
  InnovationArray = [InnovationArray innovation];
  Pplus = Pminus - K * SPlus * K';%(eye(4) - K * H) * Pminus * (eye(4) - K * H)' + K * R * K';
  
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