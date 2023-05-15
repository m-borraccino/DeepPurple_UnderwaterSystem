%% FILE BACKUP CON TUTTO FUNZIONANTE MA NON COMMENTATO
clear all
clc

%% Inizializzazione
% Coordinate degli spigoli del bacino in lat e long fornite dal file
% missionC.m

cornerA = [43.781381; 11.282793]; % Lat/Lon [decimal degrees]      
cornerB = [43.780975; 11.283505]; % Lat/Lon [decimal degrees]       
cornerC = [43.780189; 11.282698]; % Lat/Lon [decimal degrees]       
cornerD = [43.780602; 11.281956]; % Lat/Lon [decimal degrees]

% Definizione terna NED con origine (lat0,long0,h0) coincidente al 
% cornerD
wgs84 = wgs84Ellipsoid;
lat0 = cornerD(1);
lon0 = cornerD(2);
h0 = 0;

%% Conversione ECEF to NED
[A(1),A(2),A(3)] = geodetic2ned(cornerA(1),cornerA(2),0,lat0,lon0,h0,wgs84);
[B(1),B(2),B(3)] = geodetic2ned(cornerB(1),cornerB(2),0,lat0,lon0,h0,wgs84);
[C(1),C(2),C(3)] = geodetic2ned(cornerC(1),cornerC(2),0,lat0,lon0,h0,wgs84);
[D(1),D(2),D(3)] = geodetic2ned(cornerD(1),cornerD(2),0,lat0,lon0,h0,wgs84);

%% Calcolo delle distanze dalle pareti
% L'equazione del piano corrisponde a quella della retta perché il piano
% delle pareti è verticale, per cui si risolve un sistema lineare:
% l'equazione del piano deve soddisfare il passaggio da due punti.
% Il parametro a è libero, lo poniamo a=1, il parametro c relativo all'asse
% z sarà sempre pari a zero.

% questo è il sistema da risolvere
%{
syms b d;
[b d] = solve(A(1)+b*A(2)+d,B(1)+b*B(2)+d,b,d);
a_AB = 1;
b_AB = double(b);
c_AB = 0;
d_AB = double(d);

syms b d ;
[b d] = solve(B(1)+b*B(2)+d,C(1)+b*C(2)+d,b,d);
a_BC = 1;
b_BC = double(b);
c_BC = 0;
d_BC = double(d);
%}

% calcolo dei coefficienti del piano direttamente con la formula esplicita
plane_AB = coefficient_plane(A,B);
plane_BC = coefficient_plane(B,C);
plane_CD = coefficient_plane(C,D);
plane_DA = coefficient_plane(D,A);

%%

pos = [30 90 0];

%        phi teta  psi       vettore orientazione AHRS
orient= [ pi/6 0 0]';        %orientazione fornita dall'AHRS
sonar_sx_body = [0 1 0]';    %versore sonar  in terna body prua=[1 0 0]' sx=[0 -1 0]' dx=[0 1 0]'

%in questo script, il plot funziona solo se la retta interseca i piani AB,
%fateci attenzione alla combinazione di orientazione e versore del sonar
%%
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

sonar_sx_NED = jacob*sonar_sx_body; %conversione versore del sonar da body a NED

intx_AB = zeros(1,3);
intx_BC = zeros(1,3);


syms x y z t
xl = pos(1) + sonar_sx_NED(1)*t;        %equazioni parametriche che descrivono la retta passante per pos
yl = pos(2) + sonar_sx_NED(2)*t;        %e direzione lungo il versore del sonar
zl = pos(3) + sonar_sx_NED(3)*t;

% imposto il sistema per calcolare l'intersezione tra piano e retta
Eqn = subs(a_AB*x + b_AB*y + c_AB*z + d_AB == 0, {x y z},{xl yl zl});
t = double(solve(Eqn, t))   %trovato t, lo metto nell'equazione parametrica e trovo il punto di intersezione

%% 
% t senza solve, tramite la forma trovata espliciatamente dal sistema.
% Siccome il piano è verticale e abbiamo scelto a=1, la forma esplicita si calcola facilemte 

t1 = -(pos(1)+b_AB*pos(2)+d_AB)/(b_AB*sonar_sx_NED(2)+sonar_sx_NED(1))
% a noi interessano solo i t>0, (vedi commenti sotto)

% è preferibile usare questa che è più immediata rispetto al sistema e solve
%%
% intx_AB è l'intersezione con il piano AB
intx_AB(1) = pos(1) + sonar_sx_NED(1)*double(t);
intx_AB(2) = pos(2) + sonar_sx_NED(2)*double(t);
intx_AB(3) = pos(3) + sonar_sx_NED(3)*double(t);

% faccio lo stesso per il piano BC
syms x y z t
Eqn = subs(a_BC*x + b_BC*y + c_BC*z + d_BC == 0, {x y z},{xl yl zl});
t = solve(Eqn, t);
double(t)
intx_BC(1) = pos(1) + sonar_sx_NED(1)*double(t);
intx_BC(2) = pos(2) + sonar_sx_NED(2)*double(t);
intx_BC(3) = pos(3) + sonar_sx_NED(3)*double(t);

%plotto tutto
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

% teoricamente la distanza tra due punti nello spazio si applicando la norma alla
% differenza dei due punti.
dist_AB = norm(intx_AB-pos)             %formula generale

%formula esplicita ricavata da tutto il sistema
Dist_AB = ((sonar_sx_NED(1)*t1)^2+(sonar_sx_NED(2)*t1)^2+(sonar_sx_NED(3)*t1)^2)^(1/2)

dist_BC = norm(intx_BC-pos);


%% 
%la distanza dalla parete che ci serve è minore tra le due intersezioni
%trovate dei due piani. 
%quella minore la segno con la stellina blu

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

%%
%come si vede, c'è il calcolo sia del parametro t che della distanza.

%questi due valori coincidono perché il vettore che individua la direzione
%dei sonar è un versore.
%pensateci un po', nel caso cerco di nuovo di chiarirlo, è solo algebra
%alla fine. fatto sta che il calcolo della distanza, chiamata Dist_AB è
%intile. possiamo fermarci a t

%inoltre le formule così esprimono un valore di t negativo se
%l'intersezione tra la retta del sonar e il piano è opposta alla
%direzione del versore. in tal caso, nella realtà l'intersezione non c'è.
%quindi bisogna considerare solo i valori di t positivi.




