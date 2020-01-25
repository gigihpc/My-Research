close all; clear all; clc;

globals;
%ginit_plessey;
%ginit_pr800;
ginit;
Z = load('astrx_SUB1.txt');
measurements = [];

for i=1:length(Z(:,1))
  if(norm(Z(i,:)) == 0)
    if(length(measurements) == 0)
      continue;
    end
    Tracker(measurements);
    measurements = [];
  else
    elv = asin(Z(i,5)*ALTITUDE_FEET_TO_NMI/Z(i,2))*180/pi;
    measurements = [measurements;[Z(i,2:4) elv]];
  end
end

figure
cmap = hsv(length(TRACK_LIST));
for t=1:length(TRACK_LIST(1,:))
  track =[];
  for j=1:length(TRACK_LIST(:,t))
    track = [track;TRACK_LIST{j,t}];
  end
  drawtrack =[];
  if(length(track) < 1)
    continue;
  end
  for i=1:length(track(:,1))
    drawtrack =[drawtrack;[track(i,1)*sin(track(i,2)*ToRadian) track(i,1)*cos(track(i,2)*ToRadian)]];
  end
  plot(drawtrack(:,1),drawtrack(:,2),'-*r');
  hold on;
end

%for t=1:length(PREDICT_TRACKLIST(1,:))
%  track =[];
%  for j=1:length(PREDICT_TRACKLIST(:,t))
%    track = [track PREDICT_TRACKLIST{j,t}];
%  end
%  drawtrack =[];
%  if(length(track) < 1)
%    continue;
%  end
%  for i=1:length(track(1,:))
%    drawtrack =[drawtrack;[track(2,i) track(1,i)]];
%  end
%  if(t==1)
%    plot(drawtrack(:,1),drawtrack(:,2),'-*b');
%  elseif(t==3)
%    plot(drawtrack(:,1),drawtrack(:,2),'-*m');
%  elseif(t==5)
%    plot(drawtrack(:,1),drawtrack(:,2),'-*c');
%  else
%    plot(drawtrack(:,1),drawtrack(:,2),'-*g');
%  end
%  hold on;
%end

p1 =[0,200;0,-300];
p2 = [-100,0;250,0];
plot(p1(:,1),p1(:,2),'-b');
hold on; 
plot(p2(:,1),p2(:,2),'-b');

%figure(2) %velocity track
%for t=1:length(VELOCITY_TRACK(1,:))
%  track =[];
%  for j=1:length(VELOCITY_TRACK(:,t))
%    track = [track VELOCITY_TRACK{j,t}];
%  end
%  drawtrack =[];
%  if(length(track) < 1)
%    continue;
%  end
%  if(t==1 || t==2 || t==3)
%    plot(track,'-*b');
%    title('VELOCITY TRACK');
%  end
%  hold on;
%end

%figure(3) %heading track
%for t=1:length(HEADING_TRACK(1,:))
%  track =[];
%  for j=1:length(HEADING_TRACK(:,t))
%    track = [track HEADING_TRACK{j,t}];
%  end
%  drawtrack =[];
%  if(length(track) < 1)
%    continue;
%  end
%  if(t==1)
%    plot(track,'-*b');
%  elseif(t==3)
%    plot(track,'-*m');
%  elseif(t==5)
%    plot(track,'-*c');
%  end
%  title('HEADING TRACK');
%  hold on;
%end

%figure(4)
%for t=1:length(PREDICT_TRACKLIST(1,:))
%  track =[];
%  for j=1:length(PREDICT_TRACKLIST(:,t))
%    track = [track PREDICT_TRACKLIST{j,t}];
%  end
%  drawtrack =[];
%  if(length(track) < 1)
%    continue;
%  end
%  for i=1:length(track(1,:))
%    drawtrack =[drawtrack;[track(6,i)]];
%  end
%    plot(drawtrack(:,1)*3600*KNOT_TO_FEETPERMENIT,'-*g');
%  hold on;
%  title('VERTICAL SPEED');
%end

%velocityArray = [];
%for t=1:length(PREDICT_TRACKLIST(1,:))
%  velocity =[];
%  for i=1:length(PREDICT_TRACKLIST(:,t))
%    v = PREDICT_TRACKLIST{i,t};
%    velocity=[velocity;sqrt(v(3,:)^2+v(4,:)^2)];
%  end
%  velocityArray = [velocityArray velocity];
%%  std(velocityArray)^2
%end
%
%figure(2)
%for i=1:length(velocityArray(1,:))
%  plot(velocityArray(:,i),'-*r');
%  hold on;
%end