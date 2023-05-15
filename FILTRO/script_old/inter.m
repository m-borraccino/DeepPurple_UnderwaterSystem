
function dist = inter(pos, orient, versore_son_body,plane_AB,plane_BC,plane_CD,plane_DA)
    
    J = double(subs(Jsimb,{nav_phi nav_teta nav_psi},{orient(1) orient(2) orient(3)}));
    versore_son_NED = J*versore_son_body;         %versore terna NED sonar sx

    %calcolo della distanza dalla posizione ai piani delle pareti seguendo
    %la direzione data dal versore del sonar

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
           
    dist = min([t_AB t_BC t_CD t_DA]);

end