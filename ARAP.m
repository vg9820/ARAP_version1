function [x,t,vt]=ARAP(fname, tolerance)

fullname=[fname,'.obj'];
[x,t,vt]=LoadOBJ(fullname);

%%  Pre-Computations 
EV=CalEdgeVectors(x,t);   %Calculate edge vectors of all the triangles
C=CalCots(x,t);   %Calculate cot weights of each angle in each triangle 
L=laplacian(x,t,C);  %Compute cot Laplacian of the mesh
L(1,size(L,1)+1)=1;
L(size(L,1)+1,1)=1;
Linv = inv(L);

%% Local/Global Algorithm 

E=-1;
Epre=0;
iterations=0;
while abs(Epre-E)>tolerance     %Iteration stops when the energy converges 
    iterations=iterations+1;    %to the tolerance, which is specified by
    Epre=E;                     %user.
    R = ARAP_Local(vt,t,EV,C);
    vt = ARAP_Global(EV,Linv,t,C,R);
    E = CalRigidEnergy(EV,t,vt,C,R);
   
end
E
%%  Show para result
figure
trimesh(t,vt(:,1),vt(:,2));
axis equal;
title1=num2str(iterations);
title2=[title1,' Iterations'];
title(title2);


%% Output the .obj file with texture coordinates to the disk, called 'originalname_ARAP.obj'
newfilename=[fname,'_ARAP.obj'];
WriteOBJ(newfilename, x, t, vt);
end