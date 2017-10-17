function [] = ValidationGate(z)
globals;

costMatrix(1:length(TRACK_LIST(1,:)),1:length(z(:,1))) = 1000;
cellPredict = cell();
cellVelocity = cell();
cellHeading = cell();
isNULL_ALT = 0;
isSwapTrack = 0;

for t=1:length(TRACK_LIST(1,:))
 for i=1:length(z(:,1))
  j = 1;
  cost_tTrack =[];
  while(j <= length(TRACK_LIST(:,t)))
     if(length(TRACK_LIST{j,t}) == 0)
        break;
     end
     cost_tTrack = [cost_tTrack;TRACK_LIST{j,t}];
     j = j+1;       
  end
  
  if(cost_tTrack(length(cost_tTrack(:,4)),4) != 0 && z(i,4) == 0)
    z(i,4) = cost_tTrack(length(cost_tTrack(:,4)),4);
    isNULL_ALT = 1;
  end 
  
  cost_tTrack =[cost_tTrack; z(i,:)];
  [count_costtTrack col] = size(cost_tTrack);
  %Filter To Kalman  
%  if(count_costtTrack > filterKALMAN)
%    temp_count = count_costtTrack-filterKALMAN;
%    cost_tTrack(1:temp_count,:) = [];
%    count_costtTrack = count_costtTrack-temp_count;
%  end

  if(count_costtTrack > 0)
    [predict innov covarian] = Kalman(cost_tTrack);
    Lat1 = B1^-1*B2^-1*cost_tTrack(count_costtTrack,1)*sin(cost_tTrack(count_costtTrack,2)*ToRadian)*cos(cost_tTrack(count_costtTrack,4)*ToRadian); 
    Lon1 = B1^-1*B2^-1*cost_tTrack(count_costtTrack,1)*cos(cost_tTrack(count_costtTrack,2)*ToRadian)*cos(cost_tTrack(count_costtTrack,4)*ToRadian);
    Elv1 = B1^-1*cost_tTrack(count_costtTrack,1)*sin(cost_tTrack(count_costtTrack,4)*ToRadian);
    Lat2 = predict(2,:); 
    Lon2 = predict(1,:);
    Elv2 = predict(3,:);
    costMatrix(t,i) = norm([Lon1;Lat1;Elv1] - [Lon2;Lat2;Elv2]);
    cellPredict(t,i) = predict;
    cellVelocity(t,i) = predict(6,:)*3600*KNOT_TO_FEETPERMENIT;%sqrt(predict(4,:)^2 + predict(5,:)^2)*3600;
    heading = calculateHeading(predict(4,:),predict(5,:));
    cellHeading(t,i) = heading;
  end
  if(isNULL_ALT ==1)
    z(i,4) = 0;
    isNULL_ALT = 0;
  end
 end
end

for t=1:length(TRACK_LIST(1,:))
  i = 1;
  tTrack =[];
   if(isSwapTrack == 1 && t != length(TRACK_LIST(1,:)))
    isSwapTrack = 0;
    t = t-1;
  end
  while(i <= length(TRACK_LIST(:,t)))
     if(length(TRACK_LIST{i,t}) == 0)
        break;
     end
     tTrack = [tTrack;TRACK_LIST{i,t}];
     i = i+1;       
  end
    [count_tTrack col] = size(tTrack);
    [costValue select] = min(costMatrix(t,:));
    plotValidGate = [];
    if(z(select,1) > RANGE_MAINTAINANCE)
        gamma = GAMMA_EXPAND;
    else
        gamma = GAMMA; 
    end
%     gamma = GAMMA; 
    
    if(count_tTrack > 0 && costValue <= gamma )
       [costValue_track select_track] = min(costMatrix(:,select));
       control = abs(costValue-costValue_track);
       if(costValue_track < costValue && control > CONTROL_TRACK)
        isSwapTrack = 1;
        t = select_track;
        tmp_tTrack =[];
        j = 1;
        while(j <= length(TRACK_LIST(:,t)))
          if(length(TRACK_LIST{j,t}) == 0)
             break;
          end
          tmp_tTrack = [tmp_tTrack;TRACK_LIST{j,t}];
          j = j+1;       
        end
        [count_tTrack col] = size(tmp_tTrack);
       end
       if(z(select,4) == 0)
          z(select,4) = tTrack(count_tTrack,4);
       end
       TRACK_LIST(count_tTrack+1,t) = z(select,:);
       PREDICT_TRACKLIST(count_tTrack,t) = cellPredict(t,select);
       VELOCITY_TRACK(count_tTrack,t) = cellVelocity(t,select);
       HEADING_TRACK(count_tTrack,t) = cellHeading(t,select);
%       if(count_tTrack > 1)
%          [heading] = calculateHeading(PREDICT_TRACKLIST{count_tTrack-1,t},cellPredict(t,select));
%          HEADING_TRACK(count_tTrack,t) = heading;
%       end
       costMatrix(t,:) = 1000; %max value
       costMatrix(:,select) = 1000;
       z(select,:) = 0;
    end
end

for i=1:length(z(:,1))
   if(norm(z(i,:)) != 0)
    len =length(TRACK_LIST(1,:));
    TRACK_LIST(1,len+1) = z(i,:);
   end
end   

%Older Tracker
%for t=1:length(TRACK_LIST)
%%  for i=1:length(TRACK_LIST(:,t))
%  i = 1;
%  tTrack =[];
%  while(i <= length(TRACK_LIST(:,t)))
%     if(length(TRACK_LIST{i,t}) == 0)
%        break;
%     end
%     tTrack = [tTrack;TRACK_LIST{i,t}];
%     i = i+1;       
%  end
%  k = 1;
%  plotValidGate =[];
%  while(k <= length(z(:,1)))
%    tTrack = [tTrack; z(k,:)];
%    [count_tTrack col] = size(tTrack);
%      
%    probArray =[];
%    if(count_tTrack > 1)
%%      kal_tTrack = tTrack(count_tTrack-1:count_tTrack,:); 
%      [predict innov covarian] = Kalman(tTrack);
%      Lat1 = sin(tTrack(count_tTrack-1,2)*ToRadian)*tTrack(count_tTrack-1,1); 
%      Lon1 = cos(tTrack(count_tTrack-1,2)*ToRadian)*tTrack(count_tTrack-1,1);
%      Lat2 = predict(2,:); 
%      Lon2 = predict(1,:);
%      if(norm([Lon1;Lat1] - [Lon2;Lat2]) <= GAMMA)
%         cost_dist = norm([Lon1;Lat1] - [Lon2;Lat2]);
%         plotValidGate = [plotValidGate;[z(k,:) cost_dist]];%Kolom keempat untuk nilai probabilitasnya
%         tTrack(count_tTrack,:) = [];
%%        TRACK_LIST(count_tTrack,t) = z(k,:);
%         z(k,:) = [];
%%        break;
%      else
%         tTrack(count_tTrack,:) = [];
%      end
%     k = k+1;
%    end
%
%    %Jika ada nilai probabilitasnya.
%%    if(length(probArray) > 0)
%%    [val select] = min(probArray);
%%    TRACK_LIST(count_tTrack+1,i)= z(select,1);
%%    z(select,1) =[];
%%    end
%  end
%%   
% %Setting TRACK_LIST
% if(length(plotValidGate) > 0)
%   if(length(plotValidGate(:,1))>1)
%     costArray =[];
%     for i= 1:length(plotValidGate(:,1))
%        costArray =[costArray plotValidGate(i,4)];      
%%        printf('Need Probability Setting, plot valid more than 1\n');
%     end
%     [val choice] = min(costArray);
%     TRACK_LIST(count_tTrack,t) = plotValidGate(choice,1:3);
%     plotValidGate(choice,:) = [];
%     z = [z; plotValidGate(:,1:3)];
%   else
%     TRACK_LIST(count_tTrack,t) = plotValidGate(1,1:3);
%   end
% end
%     
%end  
%
%for i=1:length(z(:,1))
%   len =length(TRACK_LIST);
%   TRACK_LIST(1,len+1) = z(i,:);
%end   
