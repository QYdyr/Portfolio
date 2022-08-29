function acclerometer_data_analysis
% acccelerometer data analysis using ODBA
%   Detailed explanation goes here

clearvars;
%% import accelerometer data
% variables in the csv file
% TagID   Date   Time   accX   accY   accZ  
% an entire accelerometer data file around 26 million rows
% 100 rows = 1 second data

%%%%%%%%%%%  low intensity & high intensity activities %%%%%%%
% low intensity: resting,sitting,standing
% high intensity: walking,running,jumping,fighting,wing flapping,flying

%% from 8:33:29 - 8:33:37
% standing 8:33:29 - 8:33:32
% walking: 8:33:32 - 8:33:33
% jumping & wing flapping 8:33:33 - 8:33:36
data= readtable('filename.csv');
data_test= data(614601:615501,2:6);

% accelerometer axes (directions to the animal)
% accX vertical direction 
% accY foward & back direction 
% accZ left & right direction 

% transpose accX to a row vector and add 1 to accX, transpose axxY and accZ

%%%%% acceleration data in 3 axes 8:33:29 - 8:33:37 %%%%%
X_axis = (data_test.accX)';
Y_axis = (data_test.accY)';
Z_axis = (data_test.accZ)';

% get time vector
acc_time = (data_test.Time)';

%% raw data plotting

subplot(3,1,1);
plot(acc_time,X_axis);
title('X acc ');    
xlabel('Time');
ylabel('X');

subplot(3,1,2);
plot(acc_time,Y_axis);
title('Y acc ');    
xlabel('Time');
ylabel('Y');

subplot(3,1,3);
plot(acc_time,Z_axis);
title('Z acc ');    
xlabel('Time');
ylabel('Z');

%% calculate static acceleration for each axis (running mean of 1 s or 2 s)
% sampling rata = 100 Hz means 100 data points per second
% so 1 s running mean = 100 points, 2 s running mean = 200 points

% moving average along the column --- movmean(A,k,1) , along the row movmean(A,k,2)
X_avg_2s= movmean(X_axis,200,2);
Y_avg_2s = movmean(Y_axis,200,2);
Z_avg_2s = movmean(Z_axis,200,2);

%% calculate dynamic acceleration for each axis (subtract static from raw)
X_dynamic = X_axis - X_avg_2s;
Y_dynamic = Y_axis - Y_avg_2s;
Z_dynamic = Z_axis - Z_avg_2s;

%% calculate ODBA (sum of the abs of 3 axes DBA) and |X|,|Y|,|Z|
ODBA = abs(X_dynamic) + abs(Y_dynamic) + abs(Z_dynamic);
X_DBA = abs(X_dynamic);
Y_DBA = abs(Y_dynamic);
Z_DBA = abs(Z_dynamic);

%% plot ODBA and |X|,|Y|,|Z|
% accX vertical direction 
% accY foward & back direction 
% accZ left & right direction 

subplot(4,1,1);
plot(acc_time,ODBA);
title('ODBA ');    
xlabel('Time');
ylabel('ODBA');

subplot(4,1,2);
plot(acc_time,X_DBA);
title('DBA |X| (vertical direction) ');    
xlabel('Time');
ylabel('|X|');

subplot(4,1,3);
plot(acc_time,Y_DBA);
title('DBA |Y| (foward & back direction) ');    
xlabel('Time');
ylabel('|Y|');

subplot(4,1,4);
plot(acc_time,Z_DBA);
title('DBA |Z| (left & right direction) ');    
xlabel('Time');
ylabel('|Z|');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






end

