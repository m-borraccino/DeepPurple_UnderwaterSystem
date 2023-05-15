
clc

for i= -1-pi/2: 0.0873: 1+pi/2
    
    pos =  [80 30 0]';
    pos_es=pos;
    orient= [0 0 0]';               %orientazione fornita dall'AHRS
    versore_son_body = [1 0 0]';    %versore sonar in terna body
%     versore_son_body = versore_son_body/norm(versore_son_body); %normalizzo il versore
    
hold on
plot(pos(2),pos(1),'g*')
plot(A(2),A(1),'r*')
text(A(2),A(1),' A')
plot(B(2),B(1),'g*')
text(B(2),B(1),' B')
plot(C(2),C(1),'r*')
text(C(2),C(1),' C')
plot(D(2),D(1),'r*')
text(D(2),D(1),' D')
plot([A(2) B(2)],[A(1) B(1)],'g')
plot([B(2) C(2)],[B(1) C(1)],'g')
plot([C(2) D(2)],[C(1) D(1)],'g')
plot([D(2) A(2)],[D(1) A(1)],'g')
    
    
     Roll  = orient(1);
    Pitch = orient(2);
    Yaw   = orient(3);
    R_x = [    1           0           0     ;
               0       cos(Roll)   sin(Roll) ;
               0      -sin(Roll)   cos(Roll)];
    R_y = [cos(Pitch)      0      -sin(Pitch);
              0            1           0     ;
           sin(Pitch)      0      cos(Pitch)];
    R_z = [cos(Yaw)     sin(Yaw)       0     ;
           -sin(Yaw)    cos(Yaw)       0     ;
              0            0           1    ];
    J = (R_z'*R_y')*R_x';
    versore_son_NED = J*versore_son_body;         %versore terna NED sonar sx

    %imposto il sistema per trovare l'intersezione tra la retta con direzione
    %nota e uno dei piani delle pareti del bacino

    t_AB = -(pos(1)+plane_AB(2)*pos(2)+plane_AB(4))/(plane_AB(2)*versore_son_NED(2)+versore_son_NED(1));
    t_BC = -(pos(1)+plane_BC(2)*pos(2)+plane_BC(4))/(plane_BC(2)*versore_son_NED(2)+versore_son_NED(1));
    t_CD = -(pos(1)+plane_CD(2)*pos(2)+plane_CD(4))/(plane_CD(2)*versore_son_NED(2)+versore_son_NED(1));
    t_DA = -(pos(1)+plane_DA(2)*pos(2)+plane_DA(4))/(plane_DA(2)*versore_son_NED(2)+versore_son_NED(1));
    
intx_AB(1) = pos(1) + versore_son_NED(1)*t_AB;
intx_AB(2) = pos(2) + versore_son_NED(2)*t_AB;
intx_AB(3) = pos(3) + versore_son_NED(3)*t_AB;

intx_BC(1) = pos(1) + versore_son_NED(1)*t_BC;
intx_BC(2) = pos(2) + versore_son_NED(2)*t_BC;
intx_BC(3) = pos(3) + versore_son_NED(3)*t_BC;

intx_CD(1) = pos(1) + versore_son_NED(1)*t_CD;
intx_CD(2) = pos(2) + versore_son_NED(2)*t_CD;
intx_CD(3) = pos(3) + versore_son_NED(3)*t_CD;

intx_DA(1) = pos(1) + versore_son_NED(1)*t_DA;
intx_DA(2) = pos(2) + versore_son_NED(2)*t_DA;
intx_DA(3) = pos(3) + versore_son_NED(3)*t_DA;

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
           
    [dist, ind] = min([t_AB t_BC t_CD t_DA]);

    
if ind==1
    plot([pos(2) intx_AB(2)],[pos(1) intx_AB(1)],'r')
    plot(intx_AB(2),intx_AB(1),'b*')
end
if ind==2
    plot([pos(2) intx_BC(2)],[pos(1) intx_BC(1)],'r')
    plot(intx_BC(2),intx_BC(1),'b*')
end
if ind==3
    plot([pos(2) intx_CD(2)],[pos(1) intx_CD(1)],'r')
    plot(intx_CD(2),intx_CD(1),'b*')
end
if ind==4
    plot([pos(2) intx_DA(2)],[pos(1) intx_DA(1)],'r')
    plot(intx_DA(2),intx_DA(1),'b*')
end




parete_attuale=1;
%% orientazione parete

    Roll  = orient(1);
    Pitch = orient(2);
    Yaw   = orient(3);
    R_x = [    1           0           0     ;
               0       cos(Roll)   sin(Roll) ;
               0      -sin(Roll)   cos(Roll)];
    R_y = [cos(Pitch)      0      -sin(Pitch);
              0            1           0     ;
           sin(Pitch)      0      cos(Pitch)];
    R_z = [cos(Yaw)     sin(Yaw)       0     ;
           -sin(Yaw)    cos(Yaw)       0     ;
              0            0           1    ];
    J = (R_z'*R_y')*R_x';
%     v_pos= J*[1 0 0]';          %versore della retta lungo l'asse x in NED
    v_pos = J*versore_son_body;
    %selezione della parete di pattugliamento
    switch parete_attuale                      
        case 1
           coef = plane_AB; %coefficiente parete attuale
        case 2
           coef = plane_BC;
        case 3
           coef = plane_CD;
        case 4
           coef = plane_DA;
        otherwise
           coef=[0 0 0 0];
           disp('errore nella scelta del piano')
    end
    
    
%     orient_parete_c = acos(abs(coef(1)*v_pos(1)+coef(2)*v_pos(2)+coef(3)*v_pos(3))/...
%         (sqrt(coef(1)^2+coef(2)^2+coef(3)^2)*sqrt(v_pos(1)^2+v_pos(2)^2+v_pos(3)^2)));
%     
%     rad2deg(orient_parete_s)
% %   rad2deg(orient_parete_c)
    
    %% calcolo intersezione con la perpendicolare
    versore_son_body = [plane_AB(1) plane_AB(2) 0]';    %versore sonar  in terna body
    versore_son_NED = versore_son_body/norm(versore_son_body); %normalizzo il versore
    
%     t_ = -(pos(1)+plane_AB(2)*pos(2)+plane_AB(4))/(plane_AB(2)*versore_son_NED(2)+versore_son_NED(1));
%     dpp = abs(coef(1)*pos_es(1)+coef(2)*pos_es(2)-coef(3)*pos_es(3)+coef(4))/norm([coef(1) coef(2) coef(3)]);
    
 %la t, cioè la dpp, me la faccio passare dall'altro blocco
    pp_AB(1) = pos(1) + versore_son_NED(1)*t_;
    pp_AB(2) = pos(2) + versore_son_NED(2)*t_;
    pp_AB(3) = pos(3) + versore_son_NED(3)*t_;

    %% qui conosco l'intersezine sulla perpendicolare e quella reale
    %devo solo definire il segno
    
    coef(4)=[];
    orient_parete_s = rad2deg(asin((coef*v_pos)/(norm(coef)*norm(v_pos))));
    
    if orient_parete_s > 0    
        if intx_AB(1) > pp_AB(1) && intx_AB(2) < pp_AB(2)
                orient_parete_s = orient_parete_s -90
        else
                orient_parete_s = -orient_parete_s+90
        end
    else
        orient_parete_s=NaN;
        disp('out of border')
    end
 

    
    
   
    
end %for iniziale

% v_pos=[plane_AB(1) plane_AB(2) plane_AB(3)];
%     orient_parete_AB = rad2deg(acos(abs(coef(1)*v_pos(1)+coef(2)*v_pos(2)+coef(3)*v_pos(3))/...
%         (sqrt(coef(1)^2+coef(2)^2+coef(3)^2)*sqrt(v_pos(1)^2+v_pos(2)^2+v_pos(3)^2))))
%     
% v_pos=[plane_BC(1) plane_BC(2) plane_BC(3)];
% orient_parete_BC = rad2deg(acos(abs(coef(1)*v_pos(1)+coef(2)*v_pos(2)+coef(3)*v_pos(3))/...
%     (sqrt(coef(1)^2+coef(2)^2+coef(3)^2)*sqrt(v_pos(1)^2+v_pos(2)^2+v_pos(3)^2))))

    
    
    
    
    