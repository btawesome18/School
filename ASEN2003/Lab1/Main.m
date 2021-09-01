%%Inputs Track Function
% Track Fuction outputs [x,y,z], inputs displasment
clear 
close all
clc

g_e =9.81;

%%Make the Track
size = 220;
c = 0;
for i= 0:0.01:size
    c = c + 1;
    TempPos = Track(i);
    VecPos(c,1:9)= TempPos; %#ok<SAGROW>
end

%% Unpack the Track Data
sum = 0;

for i =  1:22000
    x = VecPos(i,1);
    y = VecPos(i,2);
    z = VecPos(i,3);
    pos1 = [x,y,z];
    
    x = VecPos(i+1,1);
    y = VecPos(i+1,2);
    z = VecPos(i+1,3);
    pos2 = [x,y,z];
    
    sum(i+1) = sum(i) + distance(pos1,pos2);
    
    
end

x=VecPos(:,1);
y=VecPos(:,2);
z=VecPos(:,3);
g=VecPos(:,4);
gl=VecPos(:,5);
gb=VecPos(:,6);
v=VecPos(:,9);
phase = VecPos(:,8);

%Idenify sections
phase1 = phase==1;
phase2 = phase==2;
phase3 = phase==3;
phase4 = phase==4;
phase5 = phase==5;
phase6 = phase==6;
phase7 = phase==7;
phase8 = phase==8;



%% Plots


hold on
plot(sum(phase1),g(phase1),'b-',sum(phase2),g(phase2),'g-',sum(phase3),g(phase3),'m-',sum(phase4),g(phase4),'y-',sum(phase5),g(phase5),'c-',sum(phase6),g(phase6),'r-',sum(phase7),g(phase7),'k-',sum(phase8),g(phase8),'r-o');
xlabel('Distance (m)');
ylabel('Vertical G force (g)');
title('Vertical Gs vs Distance');
legend('0G Drop','Loop','Parabolic Hill','Circular Vally', 'Vally Line Transition', 'Banked Turn','Break Transition ', 'Braking point');
hold off
figure();

hold on
plot(sum(phase1),gl(phase1),'b-',sum(phase2),gl(phase2),'g-',sum(phase3),gl(phase3),'m-',sum(phase4),gl(phase4),'y-',sum(phase5),gl(phase5),'c-',sum(phase6),gl(phase6),'r-',sum(phase7),gl(phase7),'k-',sum(phase8),gl(phase8),'r-o');
xlabel('Distance (m)');
ylabel('Lateral G force (g)');
title('Lateral Gs vs Distance');
legend('0G Drop','Loop','Parabolic Hill','Circular Vally', 'Vally Line Transition', 'Banked Turn','Break Transition ', 'Braking point');
hold off
figure();

hold on
plot(sum(phase1),gb(phase1),'b-',sum(phase2),gb(phase2),'g-',sum(phase3),gb(phase3),'m-',sum(phase4),gb(phase4),'y-',sum(phase5),gb(phase5),'c-',sum(phase6),gb(phase6),'r-',sum(phase7),gb(phase7),'k-',sum(phase8),gb(phase8),'r-o');
xlabel('Distance (m)');
ylabel('Tangent G force (g)');
title('Tangent Gs vs Distance');
legend('0G Drop','Loop','Parabolic Hill','Circular Vally', 'Vally Line Transition', 'Banked Turn','Break Transition ', 'Braking point');
hold off
figure();

hold on
plot(sum(phase1),v(phase1),'b-',sum(phase2),v(phase2),'g-',sum(phase3),v(phase3),'m-',sum(phase4),v(phase4),'y-',sum(phase5),v(phase5),'c-',sum(phase6),v(phase6),'r-',sum(phase7),v(phase7),'k-',sum(phase8),v(phase8),'r-o');
xlabel('Distance (m)');
ylabel('Velocity (m/s)');
title('Velocity vs Distance');
legend('0G Drop','Loop','Parabolic Hill','Circular Vally', 'Vally Line Transition', 'Banked Turn','Break Transition ', 'Braking point');
hold off
figure();

plot3(x(phase1),y(phase1),z(phase1),'b-',x(phase2),y(phase2),z(phase2),'g-',x(phase3),y(phase3),z(phase3),'m-',x(phase4),y(phase4),z(phase4),'y-',x(phase5),y(phase5),z(phase5),'c-',x(phase6),y(phase6),z(phase6),'r-',x(phase7),y(phase7),z(phase7),'k-',x(phase8),y(phase8),z(phase8),'r-o');
legend('0G Drop','Loop','Parabolic Hill','Circular Vally', 'Vally Line Transition', 'Banked Turn','Break Transition ', 'Braking point');
ylim([0,400]);
zlim([0,400]);
xlim([-400,0]);
xlabel('X-axis (m)');
ylabel('Y-axis (m)');
zlabel('Z-axis (m)');
title('Roller Coaster Path');

