%% Applica la conversione da ECEF a NED
%le variabili globali sono tali perché definite altrove all'inizio della
%simulazione e sono costanti
%ritorna un vettore con componenti [xNorth, yEast, zDown]

function  y = ECEFtoNED(x)
    
     global nav_wgs84 nav_lat0 nav_lon0 nav_h0
     
     [y(1),y(2),y(3)]= geodetic2ned(x(1),x(2),0,nav_lat0,nav_lon0,nav_h0,nav_wgs84);
end
        


