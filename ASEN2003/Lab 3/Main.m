load("balanced_1")
load("balanced_2")

close all;

angle1 = balanced_1(:,2);
angle2 = balanced_2(:,2);

omega1 = balanced_1(:,2);

M = 11.7;
M0 = 0.7;
I = M*(0.203^2);
R = 0.235;
B = 5.5;
g = 9.81;
h0 = 0;
k = 0.203;
w1The1 = Method1(M,M0,B,(angle1),R,I,g);
w2The1 = Method1(M,M0,B,(angle2),R,I,g);

w1The2 = Method2(M,M0,B,angle1,R,I,g,-0.75); %-0.75 found
w2The2 = Method2(M,M0,B,angle2,R,I,g,-0.75);

hold on
title('Balanced Drum');
plot(angle1,w1The1);
plot(angle1,balanced_1(:,3),'*');
plot(angle1,w1The2);
xlabel('Angle (rad)');
ylabel('Omega (rad/s)');
legend('Model 1', 'Real', 'Model 2');
hold off

%% 3-4

load("unbalanced_1")
load("unbalanced_2")

angleU1 = unbalanced_1(:,2);
angleU2 = unbalanced_2(:,2);

r = 0.178;
m = 3.4;
r0 = 0.019;

w1The3 = Method3(M,M0,B,angleU1,R,I,g,0.75,r,m,k);
w2The3 = Method3(M,M0,B,angleU2,R,I,g,0.75,r,m,k);

figure(2);
hold on;
title('Unbalanced Drum Method 3');
plot(angleU1,w1The3);
plot(angleU1,unbalanced_1(:,3),'*');
xlabel('Angle (rad)');
ylabel('Omega (rad/s)');
legend('Model 3','Real');
hold off

w1The4 = Method4(M,M0,B,angleU1,R,I,g,0.75,r,m,k,r0);
w2The4 = Method4(M,M0,B,angleU2,R,I,g,0.75,r,m,k,r0);

figure(3);
hold on;
title('Unbalanced Drum Method 4');
plot(angleU1,w1The4);
plot(angleU1,unbalanced_1(:,3),'*');
xlabel('Angle (rad)');
ylabel('Omega (rad/s)');
legend('Model 4','Real');

%% Error 

diffM1D1 = balanced_1(:,3)- w1The1;
diffM1D2 = balanced_2(:,3)- w2The1;

diffM1D1 = diffM1D1(1:107);
diffM1D2 = diffM1D2(1:107);

diffM2D1 = balanced_1(:,3)- w1The2;
diffM2D2 = balanced_2(:,3)- w2The2;

diffM2D1 = diffM2D1(1:107);
diffM2D2 = diffM2D2(1:107);

diffM3D1 = unbalanced_1(:,3) - w1The3;
diffM3D2 = unbalanced_2(:,3) - w2The3;

diffM3D1 = diffM3D1(1:35);
diffM3D2 = diffM3D2(1:35);

diffM4D1 = unbalanced_1(:,3) - w1The4;
diffM4D2 = unbalanced_2(:,3) - w2The4;

diffM4D1 = diffM4D1(1:35);
diffM4D2 = diffM4D2(1:35);

diffs = {diffM1D1,diffM1D2;diffM2D1,diffM2D2;diffM3D1,diffM3D2;diffM4D1,diffM4D2};

stdM1d1 = std(diffM1D1);
stdM1d2 = std(diffM1D2);
stdM2d1 = std(diffM2D1);
stdM2d2 = std(diffM2D2);
stdM3d1 = std(diffM3D1);
stdM3d2 = std(diffM3D2);
stdM4d1 = std(diffM4D1);
stdM4d2 = std(diffM4D2);

errorarry = [stdM1d1,stdM1d2;stdM2d1,stdM2d2;stdM3d1,stdM3d2;stdM4d1,stdM4d2];

exceed = zeros(4,2);

meanResids = zeros(4,2);

for i = 1:4
    
    q1= 3*errorarry(i,1);
    q2= 3*errorarry(i,2);
    
    L1 = (q1< diffs{i,1});
    L2 = (q2< diffs{i,2});
    
    exceed(i,1) = sum(L1);
    exceed(i,2) = sum(L2);
    
    meanResids(i,1) = errorarry(i,1)/(sqrt(length(diffs{i,1})));
    meanResids(i,2) = errorarry(i,2)/(sqrt(length(diffs{i,2})));
    
end


function [W] = Method1(M,M0,B,angle,r,I,g)
    
    Num = 2*(M+M0)*(sind(B)*angle)*r*g;
    Dom = (((M+M0)*(r^2))+I);
    
    W = sqrt(Num/Dom);
    
    
end


function [W] = Method2(M,M0,B,anglet,r,I,g,moment)


    h = sind(B)*r*anglet;
 
    Num = 2*(M+M0)*((g*h))+(2*moment*anglet);
    Dom = (((M+M0)*(r^2))+I);
    
    W = sqrt(Num/Dom);
    

end

function w = Method3(M,M0,B,anglet,R,I,g,moment,r,m,k)

B = B*(pi/180);

%h = sind(B)*r*anglet;
h = sind(B)*R*anglet;

%num = ((M+M0)*g*h)+(((r*cosd(5.5))-(r*cos(B+anglet))+h+R)*(g*m))+(2*moment*anglet);

%num = 2*(((M+M0)*g*h)+R+h+(m*g*((r*cosd(5.5))-(r*cos(B+anglet))))+(moment*anglet));

%num = 2*(((M+M0)*g*h)+(h*m*g)+(m*g*((r*cosd(5.5))-(r*cos(B+anglet))))+(moment*anglet));

num = 2*(((M+M0)*g*h)+(h*m*g)+(m*g*r*(cosd(5.5)-(cos(B+anglet))))+(moment*anglet));

%V = ((R^2)*(cosd(5.5)^2))+(2*R*r*cosd(5.5)*cos(B+anglet))+((r^2)*(cos(B+anglet).^2))+((r^2)*(sin(B+anglet).^2))-(2*R*r*sind(5.5)*sin(B+anglet)) + ((R^2)*(sind(5.5)^2));

V = ((R^2)*(cosd(5.5)^2)) + (2*R*r*cosd(5.5)*cos(anglet)) + ((r^2)*(cos(anglet).^2)) + ((r^2)*(sin(anglet).^2))-(2*R*r*sind(5.5)*sin(anglet)) + ((R^2)*(sind(5.5)^2));

dom = ((M+M0)*(R^2))+(I)+(V.^2);

frac = num./dom;

w = sqrt(frac);

num2 = 2*(g*R*anglet*sin(B)*(M0+M+m) + m*g*r*(cos(B)-cos(anglet+B))-moment*anglet);
den2 = M0*R^2 + M*R^2 + M*k^2 + m*((R+r*cos(anglet)).^2 + (r*sin(anglet)).^2);
frac2 = num2./den2;
w = sqrt(frac2);
end


function w = Method4(M,M0,B,anglet,R,I,g,moment,r,m,k,r0)


B = B*(pi/180);

%h = sind(B)*r*anglet;
h = sind(B)*R*anglet;

%num = ((M+M0)*g*h)+(((r*cosd(5.5))-(r*cos(B+anglet))+h+R)*(g*m))+(2*moment*anglet);

%num = 2*(((M+M0)*g*h)+R+h+(m*g*((r*cosd(5.5))-(r*cos(B+anglet))))+(moment*anglet));

%num = 2*(((M+M0)*g*h)+(h*m*g)+(m*g*((r*cosd(5.5))-(r*cos(B+anglet))))+(moment*anglet));

num = 2*(((M+M0)*g*h)+(h*m*g)+(m*g*r*(cosd(5.5)-(cos(B+anglet))))+(moment*anglet));

%V = ((R^2)*(cosd(5.5)^2))+(2*R*r*cosd(5.5)*cos(B+anglet))+((r^2)*(cos(B+anglet).^2))+((r^2)*(sin(B+anglet).^2))-(2*R*r*sind(5.5)*sin(B+anglet)) + ((R^2)*(sind(5.5)^2));

V = ((R^2)*(cosd(5.5)^2)) + (2*R*r*cosd(5.5)*cos(anglet)) + ((r^2)*(cos(anglet).^2)) + ((r^2)*(sin(anglet).^2))-(2*R*r*sind(5.5)*sin(anglet)) + ((R^2)*(sind(5.5)^2));

dom = ((M+M0)*(R^2))+(I)+(V.^2);

frac = num./dom;

w = sqrt(frac);

num2 = 2*(g*R*anglet*sin(B)*(M0+M+m) + m*g*r*(cos(B)-cos(anglet+B))-moment*anglet);
den2 = M0*R^2 + M*R^2 + M*k^2  + m*((R+r*cos(anglet)).^2 + (r*sin(anglet)).^2) + 0.5*m*r0^2;
frac2 = num2./den2;
w = sqrt(frac2);
end


