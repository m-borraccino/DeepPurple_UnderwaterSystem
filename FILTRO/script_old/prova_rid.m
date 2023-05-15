H=[1 2 3; 4 5 6;7 8 9;10 11 12;13 14 15;16 17 18];
e=[1 2 3 4 5 6]';

mis_vect= [0 0 1 0 0 0 0];
flag_vect= [1 1 0 1 0 1 0];


i=0;
    if mis_vect(3) == 0                    %se i dati del GPS non sono validi
        H(1-i,:) = [];
        e(1-i) = [];
        i=i+1;
        H(2-i,:) = [];
        e(2-i) = [];
        i=i+1;
        if flag_vect(4) == 0               %se i dati del profondimetro non sono nuovi
            H(3-i,:) = [];
            e(3-i) = [];
            i=i+1;
        end
        if flag_vect(5) == 0               %se i dati del sonar di prua non sono nuovi
            H(4-i,:) = [];
            e(4-i) = [];
            i=i+1;
        end
        if flag_vect(6) == 0               %se i dati del sonar sinistro non sono nuovi
            H(5-i,:) = [];
            e(5-i) = [];
            i=i+1;
        end
        if flag_vect(7) == 0               %se i dati del sonar destro non sono nuovi
            H(6-i,:) = [];
            e(6-i) = [];
        end
    % da qui invece abbiamo il GPS valido
    else
        if flag_vect(1)==0 || flag_vect(2)==0  %se i dati del GPS non sono nuovi
            H(1-i,:) = [];
            e(1-i) = [];
            i=i+1;
            H(2-i,:) = [];
            e(2-i) = [];
            i=i+1;
        end
        
        if flag_vect(4) == 0               %se i dati del profondimetro non sono nuovi
            H(3-i,:) = [];
            e(3-i) = [];
            i=i+1;
        end
        
        H(4-i,:) = [];                      %annulliamo le misure dei sonar
        e(4-i) = [];
        i=i+1;
        H(5-i,:) = [];
        e(5-i) = [];
        i=i+1;
        H(6-i,:) = [];        
        e(6-i) = [];
    end