%% PLOT 2D CON COVARIANZE
%GRUPPO Navigation Systems Team C

%Eseguendo questo file viene creato uno schema 2D della posizione reale
%eseguita dall'AUV durante la missione e della sua posizione stimata.
%Si possono anche disegnare le ellissi d'incertezza con semiassi pari a tre
%volte le deviazioni standard.

close
figure('Name','Team C: Environment Model 2D','NumberTitle','off')
hold on

%creazione del bacino
plot(nav_A(2),nav_A(1),'r*')
text(nav_A(2),nav_A(1),' A')
plot(nav_B(2),nav_B(1),'g*')
text(nav_B(2),nav_B(1),' B')
plot(nav_C(2),nav_C(1),'r*')
text(nav_C(2),nav_C(1),' C')
plot(nav_D(2),nav_D(1),'r*')
text(nav_D(2),nav_D(1),' D')
plot([nav_A(2) nav_B(2)],[nav_A(1) nav_B(1)],'g')
plot([nav_B(2) nav_C(2)],[nav_B(1) nav_C(1)],'g')
plot([nav_C(2) nav_D(2)],[nav_C(1) nav_D(1)],'g')
plot([nav_D(2) nav_A(2)],[nav_D(1) nav_A(1)],'g')
xlabel('yEast [m]')
ylabel('xNorth [m]')

%disegno la traiettoria della posizione reale NED dal Vehicle Model
plot(out.Lon_ts.data,out.Lat_ts.data,'black-');

%disegno la traiettoria della posizione stimata NED dal Navigation System
plot(out.Lon_es.data,out.Lat_es.data,'r.');






%% Ciclo per disegnare gli ellissi

%Commentare da qui in poi per avere solo il plot senza ellissi 

for i=1:1:length(out.Lat_es.data)-1
    xell = 3*out.devx.data(i*10);
    yell = 3*out.devy.data(i*10);
    [x,y] = getEllipse(yell,xell,[out.Lon_es.data(i) out.Lat_es.data(i)]);
    plot(x,y);
end

function [x,y] = getEllipse(r1,r2,C)
    beta = linspace(0,2*pi,100);
    x = r1*cos(beta) - r2*sin(beta);
    y = r1*cos(beta) + r2*sin(beta);
    x = x + C(1,1);
    y = y + C(1,2);
end