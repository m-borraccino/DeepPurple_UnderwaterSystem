   
% chiedere ai sensoristi dove sono messi sonar e profondimetro rispetto al
% centro


%misvect=[Gps(1) Gps(2) Gps(3)/flag depth sonar_prua sonar_sx sonar_dx]




function [e,H] = virtual(x_k_k_1, mis_vect, flag_vect, orient, plane_AB, plane_BC, plane_CD, plane_DA, Jsimb)


    e = zeros(6,1); %innovazione
    h = zeros(6,1);
    z = zeros(6,1); % vettore delle misure
    H = zeros (6,3);
    
    % vengono aggiunti solamente i segnali che sono cambiati (ovvero i
    % segnali nuovi arrivati dai sensori).
    % il flag del GPS (= componente GPS(3)) serve per discriminare l'utilizzo o meno
    % del GPS nell'innovazione; se GPS(3)=1 viene inserita nel vettore
    % delle misure z il GPS, altrimenti vengono inseriti i segnali dai
    % sonar
    
    %deciso di inserire tutti i segnali nel medesimo vettore z (6x1)
    % la matrice H ha quindi dimensione 6x3
    
    %valutazione misure GPS
    if mis_vect(3)==1                                   %se i dati del GPS sono validi
        if flag_vect(1) == 1 && flag_vect(2) == 1       %se i dati del GPS sono nuovi
            
            z = z + [mis_vect(1) mis_vect(2) 0 0 0 0]; 
            h = h + [x_k_k_1(1) x_k_k_1(2) 0 0 0 0]; 
            H(1,:)= [ 1 0 0];
            H(2,:)= [ 0 1 0];
        end
    end
    %valutazione misure depth
    if flag_vect(3) == 1                                  %se i dati del profondimetro sono nuovi
            
            z = z + [0 0 mis_vect(4) 0 0 0]; 
            h = h + [0 0 x_k_k_1(3) 0 0 0];
            H(3,:)= [0  0 1];
    end
    
    %valutazione misure sonar se gps no valido(GPS(3) ==0) 
   
    if mis_vect(3)==0  
        
        % se sonar_prua ha nuovo segnale in arrivo
        if flag_vect(5)==1  
        
            [distanza, plane] = inter(x_k_k_1, orient, [1 0 0]', plane_AB, plane_BC, plane_CD, plane_DA);
            z = z + [0 0 0 mis_vect(5) 0 0]; 
            h = h + [0 0 0 distanza 0 0];
            
            H(4,1)=sign(x_k_k_1(1) + plane(4) + x_k_k_1(2)*plane(2))/abs(cos(orient(3))*cos(orient(2)) + plane(2)*cos(orient(2))*sin(orient(3)));
            H(4,2)=(plane(2)*sign(x_k_k_1(1) + plane(4) + x_k_k_1(2)*plane(2)))/abs(cos(orient(3))*cos(orient(2)) + plane(2)*cos(orient(2))*sin(orient(3)));
            H(4,3)= 0;
        end
        
        if flag_vect(6)==1     % se sonar_sx ha nuovo segnale in arrivo
            
            [distanza, plane] = inter(x_k_k_1, orient, [0 -1 0]', plane_AB, plane_BC, plane_CD, plane_DA);
            z = z + [0 0 0 0 mis_vect(6) 0]; 
            h = h + [0 0  0 0 distanza 0];
            
            H(5,1)=sign(x_k_k_1(1) + plane(4) + x_k_k_1(2)*plane(2))/abs(plane(2)*(cos(orient(1))*cos(orient(3)) + sin(orient(1))*sin(orient(3))*sin(orient(2))) - cos(orient(1))*sin(orient(3)) + cos(orient(3))*sin(orient(1))*sin(orient(2)));
            H(5,2)=(plane(2)*sign(x_k_k_1(1) + plane(4) + x_k_k_1(2)*plane(2)))/abs(plane(2)*(cos(orient(1))*cos(orient(3)) + sin(orient(1))*sin(orient(3))*sin(orient(2))) - cos(orient(1))*sin(orient(3)) + cos(orient(3))*sin(orient(1))*sin(orient(2)));
            H(5,3)=0;   
        end
        
        if flag_vect(7)==1     % se sonar_dx ha nuovo segnale in arrivo
            
            [distanza, plane] = inter(x_k_k_1, orient, [0 1 0]', plane_AB, plane_BC, plane_CD, plane_DA);
            z = z + [0 0 0 0 0 mis_vect(7)]; 
            h = h + [0 0 0 0 0 distanza];
            
            H(6,1)=sign(x_k_k_1(1) + plane(4) + x_k_k_1(2)*plane(2))/abs(plane(2)*(cos(orient(1))*cos(orient(3)) + sin(orient(1))*sin(orient(3))*sin(orient(2))) - cos(orient(1))*sin(orient(3)) + cos(orient(3))*sin(orient(1))*sin(orient(2)));
            H(6,2)=(plane(2)*sign(x_k_k_1(1) + plane(4) + x_k_k_1(2)*plane(2)))/abs(plane(2)*(cos(orient(1))*cos(orient(3)) + sin(orient(1))*sin(orient(3))*sin(orient(2))) - cos(orient(1))*sin(orient(3)) + cos(orient(3))*sin(orient(1))*sin(orient(2)));
            H(6,3) =0;           
        end
    end
    
    e = z - h;
end
    


%%
    %funzione che prende in ingresso direzione sonar in terna body, posizione e
%orientazione veicolo e da in uscita la misura del sonar (ovvero distanza
%dalla parete che sonar sta colpendo) e la parete colpita


function [distanza, plane] = inter(pos, orient, versore_son_body, plane_AB, plane_BC, plane_CD, plane_DA,Jsimb)
    
    J = double(subs(Jsimb,{orient(1) orient(2) orient(3)},{orient(1) orient(2) orient(3)}));
    versore_son_NED = J*versore_son_body;         %versore terna NED sonar sx
    %imposto il sistema per trovare l'intersezione tra la retta con direzione
    %nota e uno dei piani delle pareti del bacino
    t_AB = -(pos(1)+plane_AB(2)*pos(2)+plane_AB(4))/(plane_AB(2)*versore_son_NED(2)+versore_son_NED(1));
    t_BC = -(pos(1)+plane_BC(2)*pos(2)+plane_BC(4))/(plane_BC(2)*versore_son_NED(2)+versore_son_NED(1));
    t_CD = -(pos(1)+plane_CD(2)*pos(2)+plane_CD(4))/(plane_CD(2)*versore_son_NED(2)+versore_son_NED(1));
    t_DA = -(pos(1)+plane_DA(2)*pos(2)+plane_DA(4))/(plane_DA(2)*versore_son_NED(2)+versore_son_NED(1));
    
    
    if t_AB < 0
        t_AB = inf;
    end
    if t_BC < 0
        t_BC = inf;
    end
    if t_CD < 0
        t_CD = inf;
    end
    if t_DA < 0
        t_DA = inf;
    end
           
    [distanza, index] = min([t_AB t_BC t_CD t_DA]);
    % tolto il raggio del robot 28.5 cm dato che i sonar sono posizionati
    % sulla superficie dell'AUV
    distanza= distanza-0.285; 
    
    switch index
        case 1
        plane = plane_AB;
        case 2
        plane = plane_BC;
        case 3
        plane =plane_CD;
        case 4
        plane=plane_DA;
    end
end