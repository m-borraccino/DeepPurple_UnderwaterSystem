% close all
% clear all

% Questo programma plotta una traiettoria 'stimata' del veicolo, partendo
% da punto iniziale in superficie si porta al punto di inizio
% pattugliamento in superficie, si immerge, segue poi il percorso indicato
% dal file missionC. Al momento segue un percorso stabilito antiorario per
% gli spigoli B-A-D-C. Va generalizzato a leggere qualsiasi input. 
%per funzionare è necessario avere anche il programma Angoli_bacino che
%effettua il calcolo di punti notevoli.
run missionC.m;

cornerA = [43.781381,11.282793]; % Lat/Lon [decimal degrees]
       
cornerB = [43.780975,11.283505]; % Lat/Lon [decimal degrees]
       
cornerC = [43.780189,11.282698]; % Lat/Lon [decimal degrees]
       
cornerD = [43.780602,11.281956]; % Lat/Lon [decimal degrees]

initPoint = [ 43.780796;
              11.282739;
               0       ]; 
          
iP=initPoint;          
A=cornerA;
B=cornerB;
C=cornerC;
D=cornerD;

%Comment/Uncomment la terna da usare
% Terna Ned centrata nello spigolo C
wgs84 = wgs84Ellipsoid;
[xA,yA,zA] = geodetic2ned(A(1),A(2),0,C(1),C(2),0,wgs84);
[xB,yB,zB] = geodetic2ned(B(1),B(2),0,C(1),C(2),0,wgs84);
[xC,yC,zC] = geodetic2ned(C(1),C(2),0,C(1),C(2),0,wgs84);
[xD,yD,zD] = geodetic2ned(D(1),D(2),0,C(1),C(2),0,wgs84);
[xiP,yiP,ziP]=geodetic2ned(iP(1),iP(2),0,C(1),C(2),0,wgs84);

%coordinate del punto a 8m dal muro di inizio perlustrazione
xPP=48.435;
yPP=26.05;
zPP=0;
[i,o,u]=ned2geodetic(xPP,yPP,0,C(1),C(2),0,wgs84);
[xP,yP,zP]=geodetic2ned(i,o,u,D(1),D(2),0,wgs84);
%Riferimenti lat/long in ecef

% xA=A(1);
% yA=A(2);
% xB=B(1);
% yB=B(2);
% xC=C(1);
% yC=C(2);
% xD=D(1);
% yD=D(2);
% zA=0; zB=0; zC=0; zD=0;


x1 = linspace (xA,xB,200);
y1 = linspace (yA,yB,200);
x2 = linspace (xB,xC,200);
y2 = linspace (yB,yC,200);
x3 = linspace (xC,xD,200);
y3 = linspace (yC,yD,200);
x4 = linspace (xD,xA,200);
y4 = linspace (yD,yA,200);
x = [x1 x2 x3 x4];
y = [y1 y2 y3 y4];



h1 = -20; %Profondità bacino

z = [0];
h = 0:-.01:h1;
a = size (x);
b = size (h);
for i = 1:a(2)
    for j = 1:b(2)
        z(i,j) = h(j);
    end
end
run Angoli_bacino.m
%%
%{%}
plot3 (y,x,z)

hold on;
plot3(yiP, xiP,ziP,'ro', 'MarkerSize', 10);
hold on

% [PIPX,PIPY]=calcoloPIP(A,B,C,D,8,2)
% plot3(PIPX,PIPY,zP,'c*', 'MarkerSize', 10);
plot3(pipCD(2),pipCD(1),zP,'c*', 'MarkerSize', 10);
hold on
plot3(pipAB(2),pipAB(1),zP,'c*', 'MarkerSize', 10);
hold on
plot3(pipBC(2),pipBC(1),zP,'c*', 'MarkerSize', 10);
hold on
plot3(pipBCprof(2),pipBCprof(1),pipBCprof(3),'c*', 'MarkerSize', 10);
hold on
plot3(pipDA(2),pipDA(1),zP,'c*', 'MarkerSize', 10);
hold on
plot3(spigB(2),spigB(1),spigB(3),'c*', 'MarkerSize', 10);
hold on
plot3(spigC(2),spigC(1),spigC(3),'c*', 'MarkerSize', 10);
hold on
plot3(spigD(2),spigD(1),spigD(3),'c*', 'MarkerSize', 10);
hold on
plot3(spigA(2),spigA(1),spigA(3),'c*', 'MarkerSize', 10);

% %Uncomment se in NED
axis equal
xlabel('East');
ylabel('North');
zlabel('Down');

text(yC,xC+8,'C');
text(yD,xD+8,'D');
text(yA,xA+8,'A');
text(yB,xB+8,'B');

%Uncomment se in Ecef
% xlabel('Lat');
% ylabel('Long');
% zlabel('m');

hold on


Nc=10; %numero di campioni per tratto di ispezione
XiPspigB=linspace(xiP,pipBC(1),Nc); %da punto inizio missione a punto inizio ispezione in sup.
YiPspigB=linspace(yiP,pipBC(2),Nc);
ZiPspigB=linspace(ziP,pipBC(3),Nc);
iPspigB=[XiPspigB;YiPspigB;ZiPspigB];
Xpipbcprof=linspace(pipBC(1),pipBCprof(1),Nc);%da pip in sup a pip in prof
Ypipbcprof=linspace(pipBC(2),pipBCprof(2),Nc);
Zpipbcprof=linspace(pipBC(3),pipBCprof(3),Nc);
pipbcprof=[Xpipbcprof;Ypipbcprof;Zpipbcprof];
Xpipbcpsb=linspace(pipBCprof(1),spigB(1),Nc);%da pip in prof a spigolo B
Ypipbcpsb=linspace(pipBCprof(2),spigB(2),Nc);
Zpipbcpsb=linspace(pipBCprof(3),spigB(3),Nc);
pipbcpsb=[Xpipbcpsb;Ypipbcpsb;Zpipbcpsb];
Xsbsa=linspace(spigB(1),spigA(1),Nc); %da spigolo B a spigolo A
Ysbsa=linspace(spigB(2),spigA(2),Nc);
Zsbsa=linspace(spigB(3),spigA(3),Nc);
sbsa=[Xsbsa;Ysbsa;Zsbsa];
Xsasd=linspace(spigA(1),spigD(1),Nc);%da spigolo A a spigolo D
Ysasd=linspace(spigA(2),spigD(2),Nc);
Zsasd=linspace(spigA(3),spigD(3),Nc);
sasd=[Xsasd;Ysasd;Zsasd];
Xsdsc=linspace(spigD(1),spigC(1),Nc);%da spigolo D a spigolo C
Ysdsc=linspace(spigD(2),spigC(2),Nc);
Zsdsc=linspace(spigD(3),spigC(3),Nc);
sdsc=[Xsdsc;Ysdsc;Zsdsc];
Xscpipprof=linspace(spigC(1),pipBCprof(1),Nc);%da spigolo C a pip in profondità
Yscpipprof=linspace(spigC(2),pipBCprof(2),Nc);
Zscpipprof=linspace(spigC(3),pipBCprof(3),Nc);
scpipprof=[Xscpipprof;Yscpipprof;Zscpipprof];
Xpipppips=linspace(pipBCprof(1),pipBC(1),Nc);%da pip in prof a pip in sup
Ypipppips=linspace(pipBCprof(2),pipBC(2),Nc);
Zpipppips=linspace(pipBCprof(3),pipBC(3),Nc);
pipppips=[Xpipppips;Ypipppips;Zpipppips];
Xpipip=linspace(pipBC(1),xiP,Nc);%da pip in sup a ip
Ypipip=linspace(pipBC(2),yiP,Nc);
Zpipip=linspace(pipBC(3),ziP,Nc);
pipip=[Xpipip;Ypipip;Zpipip];

xtraj=[iPspigB(1,:),pipbcprof(1,:),pipbcpsb(1,:),sbsa(1,:),sasd(1,:),sdsc(1,:),scpipprof(1,:),pipppips(1,:),pipip(1,:)];
ytraj=[iPspigB(2,:),pipbcprof(2,:),pipbcpsb(2,:), sbsa(2,:),sasd(2,:),sdsc(2,:),scpipprof(2,:),pipppips(2,:),pipip(2,:)];

len=size(xtraj);

xt_time = [0:1:len(2)-1]';
xt_signals_values = xtraj';
xt=[xt_time xt_signals_values];

yt_time = [0:1:len(2)-1]';
yt_signals_values = ytraj';
yt=[yt_time yt_signals_values];

xtraj1=[iPspigB(1,:);pipbcprof(1,:);pipbcpsb(1,:);sbsa(1,:);sasd(1,:);sdsc(1,:);scpipprof(1,:);pipppips(1,:);pipip(1,:)];
ytraj1=[iPspigB(2,:);pipbcprof(2,:);pipbcpsb(2,:); sbsa(2,:);sasd(2,:);sdsc(2,:);scpipprof(2,:);pipppips(2,:);pipip(2,:)];
ztraj1=[iPspigB(3,:);pipbcprof(3,:);pipbcpsb(3,:);sbsa(3,:);sasd(3,:);sdsc(3,:);scpipprof(3,:);pipppips(3,:);pipip(3,:)];
len1=size(xtraj1);
%iP->pipBC->pipBC(-h)->spigB->spigA->spigD->spigC->pipBC(-h)->pipBC->iP
for j=1:len1(1)
    va=rand(1,1);
    vb=rand(1,1);
    vc=rand(1,1);
for i=1:len1(2)-1
    
%    %  plottaggio "traiettoria
      h=plot3(ytraj1(j,i:i+1),xtraj1(j,i:i+1),ztraj1(j,i:i+1),'linewidth',2)
       set(h,'Color',[va vb vc])
%    %  plottaggio "punto" della traiettoria
      plot3(ytraj1(j,i+1),xtraj1(j,i+1),ztraj1(j,i+1),'o','markerfacecolor','r')
       pause(0.1)
    
end
end


