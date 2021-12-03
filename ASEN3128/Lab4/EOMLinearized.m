function dsdt = EOMLinearized(t,state,constants)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
%state = [x;y;z;phi;theta;psi;u;v;w;p;q;r]
%constants = [m;r;k_m;I_x;I_y;I_z;nu;mu;f1;f2;f3;f4;g];
A = constants(2)/sqrt(2);
km = constants(3);
m = constants(1);
g = constants(13);
vecTemp = [-1,-1,-1,-1;-A,-A,A,A;A,-A,-A,A;km,-km,km,-km]*constants(9:12);
%Zc = vecTemp(1);
controlInput = sum(constants(9:12));
Zc = vecTemp(1);%-controlInput;
Lc = vecTemp(2);
Mc = vecTemp(2);
Nc = vecTemp(2);
Ix = constants(4);
Iy = constants(5);
Iz = constants(6);

dsdt(1:6) = state(7:12);
dsdt(7:9) = (g*[-state(5);state(4);0])+([0;0;((Zc+m*g)/m)]);
dsdt(10:12) = [(Lc/Ix);(Mc/Iy);(Nc/Iz)];

dsdt = dsdt';


end

