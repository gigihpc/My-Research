function [heading] = calculateHeading(Vx,Vy)
%globals;
%dx = 0;
%dy = 0;
%if(HEADING == 1)
%  dx = current_track(1,:) - prev_track(1,:);
%  dy = current_track(2,:) - prev_track(2,:);
%else
%  dx = (current_track(1,1)*cos(current_track(1,2)*pi/180) - prev_track(1,1)*cos(prev_track(1,2)*pi/180));
%  dy = (current_track(1,1)*sin(current_track(1,2)*pi/180) - prev_track(1,1)*sin(prev_track(1,2)*pi/180));
%end
heading = (atan2(Vy,Vx)*180/pi); %- 90;

if(heading < 0)
  heading = 360 + heading;
end
