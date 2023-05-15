%% Calcolo coefficienti di un piano verticale passanti per due punti X1 e X2
% ritorna un vettore riga con i coefficienti dell'equazione del piano
% cioè [a b c d] con equazione ax + by + cz + d = 0

function  y = coefficient_plane(x1,x2)     
	y(1) = 1;                               %coefficiente a = 1 libero
    y(2) = (x1(1)-x2(1))/(x2(2)-x1(2));     %coefficiente b
    y(3) = 0;                               %coefficiente c = 0 (perché il piano è verticale)
    y(4) = -x1(1)-y(2)*x1(2);               %coefficiente d
end