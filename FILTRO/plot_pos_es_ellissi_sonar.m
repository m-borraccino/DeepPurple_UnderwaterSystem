

hold on
plot(out.pos_es.data(2,:),out.pos_es.data(1,:),'y.');
plot (yt(:,2),xt(:,2),'r.')


for i=1:5:1800
    xell = 3*sqrt(out.P_es.data(1,1,i));
    yell = 3*sqrt(out.P_es.data(2,2,i));
    [x,y] = getEllipse(yell,xell,[out.pos_es.data(2,i) out.pos_es.data(1,i)]);
    plot(x,y);
end

function [x,y] = getEllipse(r1,r2,C)
    beta = linspace(0,2*pi,100);
    x = r1*cos(beta) - r2*sin(beta);
    y = r1*cos(beta) + r2*sin(beta);
    x = x + C(1,1);
    y = y + C(1,2);
end