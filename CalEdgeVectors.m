function EV=CalEdgeVectors(x,t)

EV=[];
for i=1:size(t,1)
    idx1=t(i,1);
    idx2=t(i,2);
    idx3=t(i,3);
    v1=x(idx1,:);
    v2=x(idx2,:);
    v3=x(idx3,:);
    a=norm(v1-v2);
    b=norm(v2-v3);
    c=norm(v3-v1);
    angle=acos((a^2+c^2-b^2)/(2*a*c));
%%  Flatten the triangle to 2D plane while keeping rigidity
    p1=[0,0];
    p2=[a,0];
    p3=[c*cos(angle), c*sin(angle)];
    EV(i,1,:)=p3-p2;
    EV(i,2,:)=p1-p3;
    EV(i,3,:)=p2-p1;
end