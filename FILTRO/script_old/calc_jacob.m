clear all
clc

% calcolo del jabiano simbolico in relazione all'orientazione e agli errori
% sugli angoli RPY

syms phi teta psi w_phi w_teta w_psi


R_x = [1        0              0;
      0 cos(phi+w_phi)  sin(phi+w_phi);
      0 -sin(phi+w_phi) cos(phi+w_phi)];
  
R_y = [cos(teta+w_teta) 0 -sin(teta+w_teta);
          0           1         0;
       sin(teta+w_teta) 0 cos(teta+w_teta)];
   
R_z = [cos(psi+w_psi) sin(psi+w_psi) 0;
      -sin(psi+w_psi) cos(psi+w_psi) 0;
          0                 0        1];

jaco = (R_z'*R_y');
jacob = jaco*R_x'               %jacobiano simbolico

% angoli ricevuti dall'AHRS
orient = [0 0 0];
w_orient= [0 0 0];

%associamo i valori alle variabili e calcoliamo numericamente lo jacobiano
phi = orient(1);
teta = orient(2);
psi = orient(3);
w_phi = w_orient(1);
w_teta = w_orient(2);
w_psi = w_orient(3);

double(subs(jacob))