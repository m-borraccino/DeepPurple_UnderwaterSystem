%% Sensors Parameteres
Variance_GPS = 3; %metri
Sample_time_GPS = 1;

Variance_depth1 = 0.2;  % metri
%Variance_depth2 = 0.4;  
Sample_time_depth = 0.1;

Variance_DVL = (0.012)^2; % m/s
Sample_time_dvl = 0.2;

% Variance_AHRS_pitch = 0.5; %gradi
% Variance_AHRS_roll = 0.5;
% Variance_AHRS_yaw = 0.1;
% Sample_time_AHRS = 0.1;

Variance_AHRS_pitch = 0.0087; %rad
Variance_AHRS_roll = 0.0087;
Variance_AHRS_yaw = 0.0017;
Sample_time_AHRS = 0.1;

% Variance_GYRO = (0.012)^2; % gradi/s
Variance_GYRO = 2.5133e-06; % rad/s
Sample_time_GYRO = 0.1;

Variance_sonar= 0.05;   %metri