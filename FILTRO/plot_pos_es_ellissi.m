

hold on
plot(out.pos_es.data(2,:),out.pos_es.data(1,:),'b.');


xlabel('yEast [m]')
ylabel('xNorth [m]')

for i=1:10:5001
    xell = 3*sqrt(out.P_es.data(1,1,i));
    yell = 3*sqrt(out.P_es.data(2,2,i));
    [x,y] = getEllipse(yell,xell,[out.pos_es.data(2,i) out.pos_es.data(1,i)]);
    plot(x,y);
end
plot(GPS_ts.data(:,2),GPS_ts.data(:,1),'g*');

% for i=1:20:5001
%     xell = 3*sqrt(out.P_es1.data(1,1,i));
%     yell = 3*sqrt(out.P_es1.data(2,2,i));
%     [x,y] = getEllipse(yell,xell,[out.pos_es1.data(2,i) out.pos_es1.data(1,i)]);
%     plot(x,y);
% end
% plot(out.pos_es1.data(2,:),out.pos_es1.data(1,:),'y.');



function [x,y] = getEllipse(r1,r2,C)
    beta = linspace(0,2*pi,100);
    x = r1*cos(beta) - r2*sin(beta);
    y = r1*cos(beta) + r2*sin(beta);
    x = x + C(1,1);
    y = y + C(1,2);
end