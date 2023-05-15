clear
clc

mkdir('C:\Users\Marco\Desktop\sub\Progetto\navigation\from_sensoristi')
addpath('C:\Users\Marco\Desktop\sub\Progetto\navigation\from_sensoristi','-end')


% disp('Loading System parameters...')

%% Environmental data

% rho = 1030;                 % [kg/m^3] Sea Water Density

%% Data for thrusters [Inspired to Bluerobotics model T200]

% D = 0.076;                  % [m] Propeller Diameter
% n_max = 340;                % [rad/s] Maximum propeller rotational speed
% dead_zone_limit = 31.5;     % [rad/s] Corresponding to about 350RPM
% omega = 0.1;                % []  Wake Fraction Number
% 
% % kT(J0) function characterisation
% alpha1 =  0.0113;          % [Ns^2/m/kg/rad^2]
% alpha2 = -0.0091;          % [Ns^2/m/kg/rad]
% 
% a1 =  rho * D^4 * alpha1;
% a2 = -rho * D^3 * alpha2 * (1 - omega);


%% Vehicle Model parameters
% here, the Vehicle Model parameters are included


%% Environment Model & Sensor Model parameters
% here, the Environment Model & Sensor Model parameters parameters are included


%% Mission Supervisor & Reference Generator parameters
% here, the Mission Supervisor & Reference Generator parameters parameters are included


%% Controller parameters
% here, the Controller parameters are included


%% Navigation System parameters
% here, the Navigation System parameters are included
run missionC.m;
disp('Loading Mission file parameters...')

run initialization_nav.m;
disp('Navigation Block Initializated...')

%simulation = 'sonar';
 simulation = 'real';

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROVA CON I DATI REALI SENZA SONAR
if strcmp(simulation, 'real')
    run timeseries_prova.m;
    disp('Timeseries data generated...')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PROVA CON I DATI DAI SENSORISTI CON I SONAR
%%
if strcmp(simulation, 'sonar')
    run plot_traject02.m
    run timeseries_prova_sonar.m;
    disp('Timeseries sonar generated...')
end

disp('READY')
%% System parameters loaded


%% LOAD Mission File
% file 'mission.m' is executed to load mission parameters (uncomment the right one)
%run missionC.m;
