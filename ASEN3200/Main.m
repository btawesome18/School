%% Problem 1: 11.7
p = [10,1,1,1;10,-1,-1,-1;8,4,-4,4;8,-2,2,-2;12,3,-3,-3;12,-3,3,3]; %Table in weight,x,y,z format
w = p(1:6,1);
W = sum(w); %Total mass
%Finds Center of Mass
cg_x = sum(w.*p(1:6,2))/W;
cg_y = sum(w.*p(1:6,3))/W;
cg_z = sum(w.*p(1:6,4))/W;
%Offsets cordinates to Be centered at CG
p1 = p;
p1(1:6,2) = p1(1:6,2)-cg_x;
p1(1:6,3) = p1(1:6,3)-cg_y;
p1(1:6,4) = p1(1:6,4)-cg_z;
%Find moments of inerta along axises.
Ixx = p1(1:6,1).*((p1(1:6,3).^2)+(p1(1:6,4).^2));
Iyy = p1(1:6,1).*((p1(1:6,2).^2)+(p1(1:6,4).^2));
Izz = p1(1:6,1).*((p1(1:6,3).^2)+(p1(1:6,2).^2));
Ixy = -p1(1:6,1).*p1(1:6,2).*p1(1:6,3);
Ixz = -p1(1:6,1).*p1(1:6,2).*p1(1:6,4);
Iyz = -p1(1:6,1).*p1(1:6,3).*p1(1:6,4);

%Put everything togeather in a tensor
I = [sum(Ixx),sum(Ixy),sum(Ixz);sum(Ixy),sum(Iyy),sum(Iyz);sum(Ixz),sum(Iyz),sum(Izz)]
%% Problem 2: 11.8

%Define new Axis line 
newAxisPoint = [1;2;2];
%Make unit vector
newAxisPoint = newAxisPoint/norm(newAxisPoint);
%Find inertia of intrest using I = V dot I*V;
Ia = dot(I*newAxisPoint,newAxisPoint)



