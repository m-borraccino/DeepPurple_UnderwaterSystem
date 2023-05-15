clear all
clc
%% Inizializzazione
% Coordinate degli spigoli del bacino in lat e long fornite dal file
% missionC.m
% DA CAPIRE COME E QUANDO PRENDERE QUESTE INFO SU SIMULINK

cornerA = [43.781381; 11.282793]; % Lat/Lon [decimal degrees]
       
cornerB = [43.780975; 11.283505]; % Lat/Lon [decimal degrees]
       
cornerC = [43.780189; 11.282698]; % Lat/Lon [decimal degrees]
       
cornerD = [43.780602; 11.281956]; % Lat/Lon [decimal degrees]

% Definizione terna NED con origine (lat0,long0,h0) coincidente al 
% cornerD

global nav_wgs84 lat0 lon0 h0           %globale così è accessibile dalla funzione ECEFtoNED

wgs84 = wgs84Ellipsoid;             
lat0 = cornerD(1);
lon0 = cornerD(2);
h0 = 0;

%% Conversione ECEF to NED

A = ECEFtoNED(cornerA);
B = ECEFtoNED(cornerB);
C = ECEFtoNED(cornerC);
D = ECEFtoNED(cornerD);

%% Calcolo jacobiano (vedi calc_jacob.m) 

pos = [30 90 0]; 
%        phi teta  psi      vettore orientazione AHRS
orient= [ pi/2    pi/3    -pi]';        %orientazione fornita dall'AHRS
sonar_sx_body = [1 0 0]';       %versore sonar sinistro in terna body

%calcolo jacobiano
R_x = [1        0              0;
      0 cos(orient(1))  sin(orient(1));
      0 -sin(orient(1)) cos(orient(1))];
  
R_y = [cos(orient(2)) 0 -sin(orient(2));
          0           1         0;
       sin(orient(2)) 0 cos(orient(2))];
   
R_z = [cos(orient(3)) sin(orient(3)) 0;
      -sin(orient(3)) cos(orient(3)) 0;
          0                 0        1];
jaco = (R_z'*R_y');
jacob = jaco*R_x';

sonar_sx_NED = jacob*sonar_sx_body;         %versore terna NED sonar sx
%% 
%imposto il sistema per trovare l'intersezione tra la retta con direzione
%nota e uno dei piani delle pareti del bacino
intx_AB = zeros(1,3);
intx_BC = zeros(1,3);


syms x y z t
xl = pos(1) + sonar_sx_NED(1)*t;
yl = pos(2) + sonar_sx_NED(2)*t;
zl = pos(3) + sonar_sx_NED(3)*t;

Eqn = subs(a_AB*x + b_AB*y + c_AB*z + d_AB == 0, {x y z},{xl yl zl});
t = solve(Eqn, t);
double(t)

%t senza solve (soluzione alternativa)

t1 = -(pos(1)+b_AB*pos(2)+d_AB)/(b_AB*sonar_sx_NED(2)+sonar_sx_NED(1))
%sono valide solo le intersezioni per t>0

%%
intx_AB(1) = pos(1) + sonar_sx_NED(1)*double(t);
intx_AB(2) = pos(2) + sonar_sx_NED(2)*double(t);
intx_AB(3) = pos(3) + sonar_sx_NED(3)*double(t);


syms x y z t
Eqn = subs(a_BC*x + b_BC*y + c_BC*z + d_BC == 0, {x y z},{xl yl zl});
t = solve(Eqn, t);
double(t)
intx_BC(1) = pos(1) + sonar_sx_NED(1)*double(t);
intx_BC(2) = pos(2) + sonar_sx_NED(2)*double(t);
intx_BC(3) = pos(3) + sonar_sx_NED(3)*double(t);

hold on
plot(pos(1),pos(2),'g*')
plot(A(1),A(2),'r*')
plot(B(1),B(2),'r*')
plot(C(1),C(2),'r*')
plot(D(1),D(2),'r*')
plot([A(1) B(1)],[A(2) B(2)],'r')
plot([B(1) C(1)],[B(2) C(2)],'r')
plot([C(1) D(1)],[C(2) D(2)],'r')
plot([D(1) A(1)],[D(2) A(2)],'r')

% calcolo la distanza utilizzando la norma tra posizione e intersezione
dist_AB = norm(intx_AB-pos)

%%
% applicando questa formula bella e fatta, senza usare solve ecc, ho la
% distanza dall'intersezione con il piano alla posizione
% QUESTA E' LA h(eta1,eta2)
Dist_AB = ((sonar_sx_NED(1)*t1)^2+(sonar_sx_NED(2)*t1)^2+(sonar_sx_NED(3)*t1)^2)^(1/2)

%%
dist_BC = norm(intx_BC-pos);

if dist_AB > dist_BC
plot([pos(1) intx_AB(1)],[pos(2) intx_AB(2)],'r')
plot([pos(1) intx_AB(1)],[pos(2) intx_AB(2)],'r')
plot(intx_AB(1),intx_AB(2),'r*')
plot(intx_BC(1),intx_BC(2),'b*')
end

if dist_AB < dist_BC
plot([pos(1) intx_BC(1)],[pos(2) intx_BC(2)],'r')
plot([pos(1) intx_BC(1)],[pos(2) intx_BC(2)],'r')
plot(intx_AB(1),intx_AB(2),'b*')
plot(intx_BC(1),intx_BC(2),'r*')
end



