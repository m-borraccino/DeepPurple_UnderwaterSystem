figure(1)
hold on
grid on

for i=1:5:5001
    plot (i,3*sqrt(out.P_es.data(1,1,i)),'r.')
    plot (i,3*sqrt(out.P_es.data(2,2,i)),'g.')
    plot (i,3*sqrt(out.P_es.data(3,3,i)),'b.')
end


