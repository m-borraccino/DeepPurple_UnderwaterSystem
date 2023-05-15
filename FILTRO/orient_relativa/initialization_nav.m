run 'missionC.m';
%% Questo script deve essere eseguito solo una volta durante la simulazione
% va eseguito solo una volta che sono stati caricati i dati del bacino
% 
% 1. Calcolo coefficenti dei piani delle pareti del bacino


%% TEMPO DI CAMPIONAMENTO FILTRO KALMAN

nav_DT = 0.1;
nav_contatore = 0;

%% 1. Calcolo coefficenti dei piani delle pareti del bacino

% Definizione terna NED con origine (lat0,long0,h0) coincidente al 
% cornerD

global nav_wgs84 nav_lat0 nav_lon0 nav_h0       %globale così queste variaibili sono accessibili dalla funzione ECEFtoNED
nav_wgs84 = wgs84Ellipsoid;             
nav_lat0 = cornerC(1);
nav_lon0 = cornerC(2);
nav_h0 = 0;

% Conversione ECEF to NED dei corner
A = ECEFtoNED(cornerA);
B = ECEFtoNED(cornerB);
C = ECEFtoNED(cornerC);
D = ECEFtoNED(cornerD);

%Calcolo coefficienti dei piani delle pareti
plane_AB = coefficient_plane(A,B);
plane_BC = coefficient_plane(B,C);
plane_CD = coefficient_plane(C,D);
plane_DA = coefficient_plane(D,A);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcolo coefficienti di un piano verticale passanti per due punti X1 e X2
% ritorna un vettore riga (1x4) con i coefficienti dell'equazione del piano
% cioè y = [a b c d] con equazione ax + by + cz + d = 0

function  y = coefficient_plane(x1,x2)     
	y(1) = 1;                               %coefficiente a = 1
    y(2) = (x1(1)-x2(1))/(x2(2)-x1(2));     %coefficiente b
    y(3) = 0;                               %coefficiente c = 0 (perché il piano è verticale)
    y(4) = -x1(1)-y(2)*x1(2);               %coefficiente d
end
