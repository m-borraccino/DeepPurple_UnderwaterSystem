



x=out.pos_es.data(1,:);
y=out.pos_es.data(2,:);
z=out.pos_es.data(3,:);
comet3(y, x,-z)
hold on
xlabel('yEast')
ylabel('xNorth')
zlabel('zDepth')