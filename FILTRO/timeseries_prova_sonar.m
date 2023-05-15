%per il test con il sonar
%genero dei campioni con il GPS
x = [67.4425 67.4423 67.4426]';
y = [3.305 3.308 3.306]';
z = [1 1 0]';
t=[0.1 1 2]';
GPS_ts = timeseries([x,y,z],t);
 
%genero campioni di un DVL
[timE,~]=size(xt);
DVL_vel_x=zeros(timE,1);
DVL_vel_y=zeros(timE,1);
DVL_vel_z=zeros(timE,1);
DVL_timE_s=zeros(timE,1);
for i=1:timE-1  
    DVL_vel_x(i,1) = xt(i+1,2)-xt(i,2)+0.001*randn(1,1);
    DVL_vel_y(i,1) = yt(i+1,2)-yt(i,2)+0.001*randn(1,1);
    DVL_timE_s(i,1)=i;
end

% for i=85:100 
%     DVL_vel_x(i,1) = 999;
%     DVL_vel_y(i,1) = 999;
%     
% end
DVL_sonar=timeseries([DVL_vel_x, DVL_vel_y, DVL_vel_z],DVL_timE_s);

parete_attuale = zeros(timE,1);
par_time=zeros(180,1);
for i=1:180
    par_time(i)=i;
    parete_attuale(i)=2;
    if i > 60
        parete_attuale(i)=1;
     if i > 80
            parete_attuale(i)=4;
         if i > 100
                parete_attuale(i)=3;
             if i > 120
                    parete_attuale(i)=2;
             end
         end
     end
    end
    
end
par_ts=timeseries([parete_attuale],par_time);



prof_sonar=zeros(10*timE,1);
prof_timE_s=zeros(10*timE,1);
for i=1:(10*(timE))
    prof_sonar(i,1)=0.001*randn(1,1);
    prof_timE_s(i,1)=i/10;
end
prof_sonar=timeseries([prof_sonar],prof_timE_s);



