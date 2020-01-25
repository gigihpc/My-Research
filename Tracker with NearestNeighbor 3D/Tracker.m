function [] = Tracker(measurement) %(range,bearing,time)
globals;

if(RAW_COUNT == 0)
  RAW_COUNT = RAW_COUNT+1;
  for i = 1:length(measurement(:,1))
    TRACK_LIST(1,i) = measurement(i,:);
  end
 return;
end

%for t=1:length(TRACK_LIST)
%   track = TRACK_LIST{1,t};
%   temp_dist = [];
%   for i=1:length(measurement)
%      dist= (measurement(i,1)*cos(measurement(i,2)*ToRadian)-track(:,1)*cos(track(:,2)*ToRadian))^2 +...
%            (measurement(i,1)*sin(measurement(i,2)*ToRadian)-track(:,1)*sin(track(:,2)*ToRadian))^2;
%      dist = sqrt(dist);
%      
%      temp_dist =[temp_dist dist];           
%   end
%   [val min_idx] = min(temp_dist);
%   TRACK_LIST(2,t) = measurement(min_idx,:);
%   measurement(min_idx,:) =[];
%end
%
%%Inisialize
%for t=1:length(TRACK_LIST)
%  if(length(TRACK_LIST(t)) == 2)
%     tTrack =[];
%     for i=1:length(TRACK_LIST(:,t))
%        tTrack =[tTrack; TRACK_LIST{i,t}];
%     end
%     [xhat innov Splus] = Kalman(tTrack);
%     tTrack(i,4) = xhat; tTrack(i,5) = innov; tTrack(i,6) = Splus;
%     TRACK_LIST(i,t) = tTrack(i,:);
%  end
%end

%Proses Validasi Gate
ValidationGate(measurement);
