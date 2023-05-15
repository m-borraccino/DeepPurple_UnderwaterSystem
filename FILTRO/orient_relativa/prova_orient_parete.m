
close
step=20;
step_deg=zeros(step,2);

for i= 1:step
pos_es =  [90 30 0]';
parete_attuale=1;
pitch=i*pi/180*(5)-pi/180*(50);

orient= [pi/180*(0) 0 pi/180*(25)]'; 
%orient= [pi/180*(50) pi/180*(0) pi/180*(60)]'; 
% orient= [0 0 0]'; 


hold on
plot(pos_es(2),pos_es(1),'g*')
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

Roll  = 0;
Pitch = 0;
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
% v_pos= J*[1 0 0]';          
%versore della retta lungo l'asse x (in body) in NED,
%cioè la direzione di riferimento di prua del veicolo     
v_pos= J*[plane_AB(1) plane_AB(2) 0]';

%selezione della parete di pattugliamento
switch parete_attuale                      
    case 1
        %% Piano di pattugliamento AB
        versore_plane_NED = [plane_AB(1) plane_AB(2) 0]';    %versore normale al piano
        versore_plane_NED = versore_plane_NED/norm(versore_plane_NED);

        %calcolo distanza e intersezione lungo la normale al piano
        t_ = -(pos_es(1)+plane_AB(2)*pos_es(2)+plane_AB(4))/(plane_AB(2)*versore_plane_NED(2)+versore_plane_NED(1));
        inter_perp=zeros(3,1);
        inter_perp(1) = pos_es(1) + versore_plane_NED(1)*t_;
        inter_perp(2) = pos_es(2) + versore_plane_NED(2)*t_;
        inter_perp(3) = pos_es(3) + versore_plane_NED(3)*t_;
        t_dist=t_;
%         plot([pos_es(2) inter_perp(2)],[pos_es(1) inter_perp(1)],'r--')
%         plot(inter_perp(2),inter_perp(1),'b*')

        %calcolo distanza e intersezione lungo la direzione di prua
        t_ = -(pos_es(1)+plane_AB(2)*pos_es(2)+plane_AB(4))/(plane_AB(2)*v_pos(2)+v_pos(1));
        inter_prua=zeros(3,1);
        inter_prua(1) = pos_es(1) + v_pos(1)*t_;
        inter_prua(2) = pos_es(2) + v_pos(2)*t_;
        inter_prua(3) = pos_es(3) + v_pos(3)*t_;
        
         plot([pos_es(2) inter_prua(2)],[pos_es(1) inter_prua(1)],'r')
         plot(inter_prua(2),inter_prua(1),'b*')

        coef = plane_AB;
        coef(4)=[];
        orient_parete = rad2deg(asin(abs(coef*v_pos)/(norm(coef)*norm(v_pos))));
        %se orient_parete è positiva, allora ci troviamo tra - 90 e + 90 rispetto alla normale della parete 
        if t_ > 0              
            if inter_prua(1) > inter_perp(1) && inter_prua(2) < inter_perp(2)
                orient_parete = orient_parete - 90;
            else
                orient_parete = -(orient_parete - 90);
            end
        else
            if inter_prua(1) > inter_perp(1) && inter_prua(2) < inter_perp(2)
                orient_parete = (orient_parete + 90);
            else
                orient_parete = -(orient_parete + 90);
            end
        end
        
%         text(pos_es(2)-5,pos_es(1)-5,num2str(orient_parete))
%         text(pos_es(2)+1,pos_es(1)-5,'°')
        text(pos_es(2)-5,pos_es(1)-5,num2str(t_dist))
        text(pos_es(2)+11,pos_es(1)-5,'m')

    
    case 2
        %% Piano di pattugliamento BC
      	versore_plane_NED = [plane_BC(1) plane_BC(2) 0]';    %versore normale al piano
        versore_plane_NED = versore_plane_NED/norm(versore_plane_NED);

        %calcolo distanza e intersezione lungo la normale al piano
        t_ = -(pos_es(1)+plane_BC(2)*pos_es(2)+plane_BC(4))/(plane_BC(2)*versore_plane_NED(2)+versore_plane_NED(1));
        inter_perp=zeros(3,1);
        inter_perp(1) = pos_es(1) + versore_plane_NED(1)*t_;
        inter_perp(2) = pos_es(2) + versore_plane_NED(2)*t_;
        inter_perp(3) = pos_es(3) + versore_plane_NED(3)*t_;
        
        plot([pos_es(2) inter_perp(2)],[pos_es(1) inter_perp(1)],'r--')
        plot(inter_perp(2),inter_perp(1),'b*')

        %calcolo distanza e intersezione lungo la direzione di prua
        t_ = -(pos_es(1)+plane_BC(2)*pos_es(2)+plane_BC(4))/(plane_BC(2)*v_pos(2)+v_pos(1));
        inter_prua=zeros(3,1);
        inter_prua(1) = pos_es(1) + v_pos(1)*t_;
        inter_prua(2) = pos_es(2) + v_pos(2)*t_;
        inter_prua(3) = pos_es(3) + v_pos(3)*t_;
        
        plot([pos_es(2) inter_prua(2)],[pos_es(1) inter_prua(1)],'r')
        plot(inter_prua(2),inter_prua(1),'b*')

        coef = plane_BC;
        coef(4)=[];
        v_pos=-v_pos;
        orient_parete = rad2deg(asin(abs(coef*v_pos)/(norm(coef)*norm(v_pos))));
        %se orient_parete è positiva, allora ci troviamo tra - 90 e + 90 rispetto alla normale della parete 
        if t_ > 0              
            if inter_prua(1) > inter_perp(1) && inter_prua(2) > inter_perp(2)
                orient_parete = orient_parete - 90;
            else
                orient_parete = -(orient_parete - 90);
            end
        else
            if inter_prua(1) > inter_perp(1) && inter_prua(2) > inter_perp(2)
                orient_parete = orient_parete + 90;
            else
                orient_parete = -(orient_parete + 90);
            end
        end
        
        text(pos_es(2)-5,pos_es(1)-5,num2str(orient_parete))
        text(pos_es(2)+1,pos_es(1)-5,'°')
    case 3
        %% Piano di pattugliamento CD
      	versore_plane_NED = [plane_CD(1) plane_CD(2) 0]';    %versore normale al piano
        versore_plane_NED = versore_plane_NED/norm(versore_plane_NED);

        %calcolo distanza e intersezione lungo la normale al piano
        t_ = -(pos_es(1)+plane_CD(2)*pos_es(2)+plane_CD(4))/(plane_CD(2)*versore_plane_NED(2)+versore_plane_NED(1));
        inter_perp=zeros(3,1);
        inter_perp(1) = pos_es(1) + versore_plane_NED(1)*t_;
        inter_perp(2) = pos_es(2) + versore_plane_NED(2)*t_;
        inter_perp(3) = pos_es(3) + versore_plane_NED(3)*t_;
        
        plot([pos_es(2) inter_perp(2)],[pos_es(1) inter_perp(1)],'r--')
        plot(inter_perp(2),inter_perp(1),'b*')

        %calcolo distanza e intersezione lungo la direzione di prua
        t_ = -(pos_es(1)+plane_CD(2)*pos_es(2)+plane_CD(4))/(plane_CD(2)*v_pos(2)+v_pos(1));
        inter_prua=zeros(3,1);
        inter_prua(1) = pos_es(1) + v_pos(1)*t_;
        inter_prua(2) = pos_es(2) + v_pos(2)*t_;
        inter_prua(3) = pos_es(3) + v_pos(3)*t_;
        
        plot([pos_es(2) inter_prua(2)],[pos_es(1) inter_prua(1)],'r')
        plot(inter_prua(2),inter_prua(1),'b*')

        coef = plane_CD;
        coef(4)=[];
         v_pos=-v_pos;
        orient_parete = rad2deg(asin(abs(coef*v_pos)/(norm(coef)*norm(v_pos))));
        %se orient_parete è positiva, allora ci troviamo tra - 90 e + 90 rispetto alla normale della parete 
        if t_ > 0              
            if inter_prua(1) > inter_perp(1) && inter_prua(2) < inter_perp(2)
                orient_parete = -orient_parete + 90;
            else
                orient_parete = orient_parete - 90;
            end
        else
             if inter_prua(1) > inter_perp(1) && inter_prua(2) < inter_perp(2)
                orient_parete = -orient_parete - 90;
            else
                orient_parete = orient_parete + 90;
            end
        end
        
        text(pos_es(2)-5,pos_es(1)-5,num2str(orient_parete))
    case 4
        %% Piano di pattugliamento DA
      	versore_plane_NED = [plane_DA(1) plane_DA(2) 0]';    %versore normale al piano
        versore_plane_NED = versore_plane_NED/norm(versore_plane_NED);

        %calcolo distanza e intersezione lungo la normale al piano
        t_ = -(pos_es(1)+plane_DA(2)*pos_es(2)+plane_DA(4))/(plane_DA(2)*versore_plane_NED(2)+versore_plane_NED(1));
        inter_perp=zeros(3,1);
        inter_perp(1) = pos_es(1) + versore_plane_NED(1)*t_;
        inter_perp(2) = pos_es(2) + versore_plane_NED(2)*t_;
        inter_perp(3) = pos_es(3) + versore_plane_NED(3)*t_;
        
        plot([pos_es(2) inter_perp(2)],[pos_es(1) inter_perp(1)],'r--')
        plot(inter_perp(2),inter_perp(1),'b*')

        %calcolo distanza e intersezione lungo la direzione di prua
        t_ = -(pos_es(1)+plane_DA(2)*pos_es(2)+plane_DA(4))/(plane_DA(2)*v_pos(2)+v_pos(1));
        inter_prua=zeros(3,1);
        inter_prua(1) = pos_es(1) + v_pos(1)*t_;
        inter_prua(2) = pos_es(2) + v_pos(2)*t_;
        inter_prua(3) = pos_es(3) + v_pos(3)*t_;
        
        plot([pos_es(2) inter_prua(2)],[pos_es(1) inter_prua(1)],'r')
        plot(inter_prua(2),inter_prua(1),'b*')

        coef = plane_DA;
        coef(4)=[];
        orient_parete = rad2deg(asin(abs(coef*v_pos)/(norm(coef)*norm(v_pos))));
        %se orient_parete è positiva, allora ci troviamo tra - 90 e + 90 rispetto alla normale della parete 
        if t_ > 0              
            if inter_prua(1) < inter_perp(1) && inter_prua(2) < inter_perp(2)
                orient_parete = orient_parete - 90;
            else
                orient_parete = -orient_parete + 90;
            end
        else
            if inter_prua(1) < inter_perp(1) && inter_prua(2) < inter_perp(2)
                orient_parete = orient_parete + 90;
            else
                orient_parete = -orient_parete - 90;
            end
        end
        
        text(pos_es(2)-5,pos_es(1)-5,num2str(orient_parete))
    otherwise
        %%
       coef=[0 0 0 0];
       disp('errore nella scelta del piano')
end
step_deg(i,1)=i*5-50;
step_deg(i,2)=orient_parete+38.2036;
end
step_deg

hold off