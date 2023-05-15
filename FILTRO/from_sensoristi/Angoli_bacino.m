%% Calcolo distanze lati ed angoli generali

AB=sqrt((xA-xB)^2+(yA-yB)^2); %lunghezza AB
BC=sqrt((xB-xC)^2+(yB-yC)^2); %lunghezza BC
CD=sqrt((xC-xD)^2+(yC-yD)^2); %lunghezza CD
DA=sqrt((xD-xA)^2+(yD-yA)^2); %lughezza DA

dW=distanceFromWall;

pcAB=[(xB+xA)/2,(yB+yA)/2];
pcBC=[(xB+xC)/2,(yB+yC)/2];
pcCD=[(xC+xD)/2,(yC+yD)/2];
pcDA=[(xD+xA)/2,(yD+yA)/2];

thetaBC= acos(yB/BC);
%thetaBC=rad2deg(thetaBC)

thetaCD=acos(yD/CD);
%thetaCD=rad2deg(thetaCD)

gammaAB=acos((yB-yA)/AB);
thetaAB=pi-gammaAB;

gammaDA=acos((yA-yD)/DA);
%gammaDA=rad2deg(gammaDA)
%% calcolo punti centrali di ciascuna parete
% questa sequenza di codice genera il punto di inizio pattugliamento a
% distanza dW dalla parete AB
dbpc=sqrt((pcAB(1)-xB)^2+(pcAB(2)-yB)^2); %distanza dal punto centrale di AB a B
hpb=sqrt(dbpc^2 + dW^2); %ipotenusa B-puntocentrale-DW
alfa1=-acos(dbpc/hpb);%angolo fra hp e lato B-PC, necessario il meno!
gammaab=pi-(gammaAB+alfa1);
pcab1=[hpb*sin(gammaab),hpb*cos(gammaab)];
pipAB=[xB+pcab1(1),yB+pcab1(2),0];
pipABprof=[pipAB(1),pipAB(2),-depth];

%questa sequenza di codice genera il punto di inizio pattugliamento a
% distanza dW dalla parete BC
dcpc=sqrt(pcBC(1)^2+pcBC(2)^2);
hpc=sqrt(dcpc^2 + dW^2);
alfabc=acos(dcpc/hpc);
gammaBC=thetaBC+alfabc;
pipBC=[hpc*sin(gammaBC),hpc*cos(gammaBC),0];
pipBCprof=[pipBC(1),pipBC(2),-depth];

%questa sequenza di codice genera il punto di inizio pattugliamento a
% distanza dW dalla parete CD
dcdpc=sqrt(pcCD(1)^2+pcCD(2)^2);
hpcd=sqrt(dcdpc^2 + dW^2);
alfacd=acos(dcdpc/hpcd);
gammaCD=thetaCD-alfacd;
pipCD=[hpcd*sin(gammaCD),hpcd*cos(gammaCD),0];
pipCDprof=[pipCD(1),pipCD(2),-depth];

%questa sequenza di codice genera il punto di inizio pattugliamento a
% distanza dW dalla parete DA
dapc=sqrt((pcDA(1)-xA)^2+(pcDA(2)-yA)^2);
hpda=sqrt(dapc^2 + dW^2);
alfada=acos(dapc/hpda);
gammada=pi+(gammaDA+alfada);
pcda1=[hpda*sin(gammada),hpda*cos(gammada)];
pipDA=[xA+pcda1(1),yA+pcda1(2),0];
pipDA=[pipDA(1),pipDA(2),-depth];

%% Calcolo Punti sugli spigoli

% calcolo punto sullo spigolo B
BC1=BC-dW;
hypspigoloB=sqrt(BC1^2+dW^2);
beta1=acos(BC1/hypspigoloB);
betaB=thetaBC+beta1;
spigB=[hypspigoloB*sin(betaB),hypspigoloB*cos(betaB),-depth];

%calcolo punto sullo spigolo C
hypspigoloC=sqrt(dW^2+dW^2);
beta2=acos(dW/hypspigoloC);
betaC=thetaBC+beta2;
spigC=[hypspigoloC*sin(betaC),hypspigoloC*cos(betaC),-depth];

%calcolo punto sullo spigolo D
CD1=CD-dW;
hypspigoloD=sqrt(CD1^2+dW^2);
beta3=-acos(CD1/hypspigoloD);
betaD=thetaCD+beta3;
spigD=[hypspigoloD*sin(betaD),hypspigoloD*cos(betaD),-depth];

%calcolo punto sullo spigolo A
AB1=AB-dW;
hypspigoloA=sqrt(AB1^2+dW^2);
beta4=acos(AB1/hypspigoloA);
betaA=thetaAB+beta4;
spigA1=[hypspigoloA*sin(betaA),hypspigoloA*cos(betaA)];
spigA=[spigA1(1)+xB,spigA1(2)+yB,-depth];

%%
