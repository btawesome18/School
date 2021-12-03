%Brian Trybus 11/2/2021 HM8 Problem 8.1
%
%Demonstrate FEM of a 3 member truss in 6 parts.
%
L = 30;
Le = [1,sqrt(4/3),(sqrt(3)/3)/cosd(30)]*L;
P = 200;
E = 3000;
A = [2, 4, 3];

%Step 1

K1 = rotateElement2d(0)*((E*A(1))/Le(1)) %1 to 4
K2 = rotateElement2d(pi/6)*((E*A(2))/Le(2)) %2 to 4
K3 = rotateElement2d((4*pi/6))*((E*A(3))/Le(3)) %3 to 4

%Step 2
%Find k total

K1e = zeros(8,8);%1 to 4
K1e(1:2,1:2) = K1(1:2,1:2);
K1e(1:2,7:8) = K1(1:2,3:4);
K1e(7:8,1:2) = K1(3:4,1:2);
K1e(7:8,7:8) = K1(3:4,3:4);

K2e = zeros(8,8);%2 to 4
K2e(3:4,3:4) = K2(1:2,1:2);
K2e(3:4,7:8) = K2(1:2,3:4);
K2e(7:8,3:4) = K2(3:4,1:2);
K2e(7:8,7:8) = K2(3:4,3:4);

K3e = zeros(8,8);%3 to 4
K3e(5:6,5:6) = K3(1:2,1:2);
K3e(5:6,7:8) = K3(1:2,3:4);
K3e(7:8,5:6) = K3(3:4,1:2);
K3e(7:8,7:8) = K3(3:4,3:4);

K = K1e+K2e+K3e

%Step 3 Apply Bondry Conditions u = [0,0,0,0,0,0,x,y]'
%F = [?,?,?,?,?,?,0,-P]' 

Kr = K(7:8,7:8)

%Step 4 Find Displacement

Fr = [0;-P];

Ur = inv(Kr)*Fr

%Step 5 Find Reactions

U = [0;0;0;0;0;0;Ur(1);Ur(2)];
F = K*U

%Step 6 Find Internal Forces

F1 = -F(1)

F2 = -sqrt((F(3)^2)+(F(4)^2))

F3 = -sqrt((F(5)^2)+(F(6)^2))

function matrix = rotateElement2d(t)

    matrix = [cos(t)^2,sin(t)*cos(t),-cos(t)^2,-sin(t)*cos(t);sin(t)*cos(t), sin(t)^2,-sin(t)*cos(t),-sin(t)^2;-cos(t)^2,-sin(t)*cos(t),cos(t)^2,sin(t)*cos(t);-sin(t)*cos(t), -sin(t)^2,sin(t)*cos(t),sin(t)^2];

end