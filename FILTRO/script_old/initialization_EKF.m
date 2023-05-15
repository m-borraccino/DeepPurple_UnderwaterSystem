%% Questo script deve essere eseguito solo una volta durante la simulazione
% va eseguito solo una volta all'inizio
%
% 1. Calcolo dello jacobiano simbolico
% 2. Definizione funzione h
% 3. Calcolo della matrice H 
% 4. Calcolo della matrice L (18)

syms nav_phi nav_teta nav_psi ...
     nav_w_phi nav_w_teta nav_w_psi ...
     nav_xDVL nav_yDVL nav_zDVL ...
     nav_wxDVL nav_wyDVL nav_wzDVL  real

DT = 0.1;


%% 1. calcolo dello jacobiano simbolico
% in relazione all'orientazione e agli errori sugli angoli RPY

R_x_w = [1        0              0;
      0 cos(nav_phi+nav_w_phi)  sin(nav_phi+nav_w_phi);
      0 -sin(nav_phi+nav_w_phi) cos(nav_phi+nav_w_phi)];
  
R_y_w = [cos(nav_teta+nav_w_teta) 0 -sin(nav_teta+nav_w_teta);
          0           1         0;
       sin(nav_teta+nav_w_teta) 0 cos(nav_teta+nav_w_teta)];
   
R_z_w = [cos(nav_psi+nav_w_psi) sin(nav_psi+nav_w_psi) 0;
      -sin(nav_psi+nav_w_psi) cos(nav_psi+nav_w_psi) 0;
          0                 0        1];

Jsimb_w = (R_z_w'*R_y_w')*R_x_w';          %jacobiano simbolico con i rumori

R_x = [1        0              0;
      0 cos(nav_phi)  sin(nav_phi);
      0 -sin(nav_phi) cos(nav_phi)];
  
R_y = [cos(nav_teta) 0 -sin(nav_teta);
          0           1         0;
       sin(nav_teta) 0 cos(nav_teta)];
   
R_z = [cos(nav_psi) sin(nav_psi) 0;
      -sin(nav_psi) cos(nav_psi) 0;
          0                 0        1];

Jsimb= (R_z'*R_y')*R_x';                   %jacobiano simbolico

%% 2. Calcolo della matrice h

%% 3. Calcolo della matrice H

%}
syms nav_x nav_y nav_z...
     nav_plane_a nav_plane_b nav_plane_c nav_plane_d real
 
nav_sonar_prua_NED = Jsimb*[1  0 0]';
nav_sonar_sx_NED   = Jsimb*[0 -1 0]';
nav_sonar_dx_NED   = Jsimb*[0  1 0]';

pos_simb   = [nav_x nav_y nav_z]';
plane_simb = [nav_plane_a nav_plane_b nav_plane_c nav_plane_d];

nav_t_prua = abs(-(pos_simb(1)+plane_simb(2)*pos_simb(2)+plane_simb(4))/(plane_simb(2)*nav_sonar_prua_NED(2)+nav_sonar_prua_NED(1)));
nav_H_prua_dx = diff(nav_t_prua,nav_x)
nav_H_prua_dy = diff(nav_t_prua,nav_y)
nav_H_prua_dz = diff(nav_t_prua,nav_z)



syms nav_x nav_y nav_z...
     nav_plane_a nav_plane_b nav_plane_c nav_plane_d ...
     nav_sonar_x_NED nav_sonar_y_NED nav_sonar_z_NED real

nav_sonar_NED = [nav_sonar_x_NED nav_sonar_y_NED nav_sonar_z_NED]';
pos_simb   = [nav_x nav_y nav_z]';
plane_simb = [nav_plane_a nav_plane_b nav_plane_c nav_plane_d];

nav_t_prua = abs(-(pos_simb(1)+plane_simb(2)*pos_simb(2)+plane_simb(4))/(plane_simb(2)*nav_sonar_NED(2)+nav_sonar_NED(1)));
nav_H_prua_dx = diff(nav_t_prua,nav_x)
nav_H_prua_dy = diff(nav_t_prua,nav_y)
nav_H_prua_dz = diff(nav_t_prua,nav_z)


%% 4. Calcolo della matrice L simbolica

vectDVL_w = [nav_xDVL+nav_wxDVL nav_yDVL+nav_wyDVL nav_zDVL+nav_wzDVL]';
f = DT*Jsimb_w*vectDVL_w;
Lsimb =  [diff(f,nav_w_phi) diff(f,nav_w_teta) diff(f,nav_w_psi) diff(f,nav_wxDVL) diff(f,nav_wyDVL) diff(f,nav_wzDVL)];
%calcolato con w=0
Lsimb = subs(Lsimb,{nav_w_phi nav_w_teta nav_w_psi nav_wxDVL nav_wyDVL nav_wzDVL},{0 0 0 0 0 0});
