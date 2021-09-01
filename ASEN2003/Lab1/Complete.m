%%Inputs Track Function
% Track Fuction outputs [x,y,z], inputs displasment
clear 
close all
clc

g_e =9.81;

%%Make the Track
size = 220;
c = 0;
for i= 0:0.1:size
    c = c + 1;
    TempPos = Track(i);
    VecPos(c,1:9)= TempPos; %#ok<SAGROW>
end

%% Unpack the Track Data
sum = 0;

for i =  1:2200
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


%% Fucntions
function Vec = Track(disp)
%Track 
%   Peacewise func for the possition of the cart/point given displacment
%   Uses elseif for what feture of the track it is on.
%   Recusivily find last point of last phase
%   Disp is just an arbitrary incrimenting variable.

%% Initializing Variables
g = 9.81;
Gf =1;
Gl =0;
Gb =0;
x = 0;
y = 0;
slope =0;
z= 125; %#ok<NASGU>
v_int=0; %#ok<NASGU>
r= 50;
Phase1 = 75;
Phase2 = ((Phase1+((3*pi/4)+(2*pi))));
Phase3 = Phase2+5;
Phase4 = Phase3+2;
Phase5 = Phase4+2;
Phase6 = Phase5+(pi/2);
Phase7 = Phase6+(pi/4);
Phase8 = Phase7+(pi/4);
Phase9 = Phase8+410;
phases = 1;

%% Start if else
if disp <= Phase1
    %% Fall
    %only z changes
    z= 125-disp;
    %no normal force in freefall
    Gf =0;
    v = sqrt(2*g*(125-(z)));
elseif (disp <= Phase2)
    %% Loop
    
    x= 0;
    y = -r* cos(disp-Phase1) +r;
    z = -r* sin(disp-Phase1) +(125-Phase1);
    v = sqrt(2*g*(125-(z)));
    
    %Normal Force
    Gf = ((v^2)/(g*r))+sin(disp);
    phases = 2;
elseif disp <= Phase3
    
    %% Balistic
    %Find starting point and angle
    temp = Track(Phase2);
    
    x1 = temp(1);
    y1 = temp(2);
    z1 = temp(3);
    v_int = sqrt(2*g*(125-z1));
    t = disp - Phase2;
    v_y = v_int*(sqrt(2)/2);
    v_z = v_int*(sqrt(2)/2);
    x= 0;
    y1 = (-r* cos(((3*pi/4)+(2*pi))) +r);
    z1 = (-r* sin(((3*pi/4)+(2*pi))) +r);
    %find new cords based on disp
    y= v_y*t + y1;
    z= v_z*t - ((1/2)*g*(t^2))+ z1;

    %Calculate parts to pass on to next phase
    v = sqrt(2*g*(125-(z)));
    
    dydx = (v_z/v_y)-(g/(v_y^2))*(y-y1);%
    slope = dydx; 
    theta = (pi/2)-atan(dydx);
    
    d2ydx2 = -g/(v_y^2);
    
    rho = ((1+(dydx^2))^(3/2))/abs(d2ydx2);
    
    Gf = -((v^2)/(g*rho))+sin(theta);
    
    v = sqrt(2*g*(125-(z)));
     
    phases = 3;
elseif (disp <= Phase4)
    %% Circular valley:
    
    %Find starting point and angle
    temp = Track(Phase3);
    y1 = temp(2);
    z1 = temp(3);
    dydx = temp(7);
    theta_i = (pi/2)-atan(dydx);
    angle = disp-Phase3-theta_i;
    
    %Check for end point to avoid hard coding angle
    if ((angle) >= (pi/4))||((angle) >= (-pi/4))
        angle = (-pi/4);
    end
    %Find x,y,z
    y = r* cos(angle) +y1-(r*cos(theta_i));
    z = r* sin(angle) +z1+(r* sin(theta_i));
    x=0;
    
    t1 = Phase4-theta_i;
    slope =  (r*sin(t1))/(-r*cos(t1));
    %Now calculate gforce
    v = sqrt(2*g*(125-(z)));
    Gf = ((v^2)/(g*r))+sin(disp);
    
    phases = 4;
elseif (disp <= Phase5)
    %% Vally to line transision
    %Find starting point
    temp = Track(Phase4);    
    y1 = temp(2);
    z1= temp(3);
    x = 0;
    
    %Confine the possible angles
    angle = disp-Phase4+(pi/4);
    if ((angle) >= (pi/2))
        angle = (pi/2);
    end
    %update the coords
    y = -r*cos(angle)+y1+(r*(sqrt(2)/2));
    z = r*sin(angle)+z1-(r*(sqrt(2)/2));

    %Gforce
    v = sqrt(2*g*(125-(z)));
    Gf = ((v^2)/(g*r))+sin(disp);
    phases = 5;
elseif (disp <= Phase6)
    %% Banked Turn
    %Find starting point
    temp = Track(Phase5);
    
    x1 = temp(1);
    y1 = temp(2);
    z = temp(3);   
    
    %update the coords
    y = (r*sin(disp-Phase5))+ y1;
    x = (r*cos(disp-Phase5))-r+x1;
    %Gforce
    Gf = 1;
    v = sqrt(2*g*(125-(z)));
    Gl = ((v^2)/(g*r));
    
    phases = 6;
elseif disp <= Phase7
    %% Bank to Break turn
    %Find starting point
    temp = Track(Phase6);
    
    x1 = temp(1);
    y = temp(2);
    z1 = temp(3);
    
    r1 = z1/2;
    %update the coords
    x = (-r1* 2 * sin(disp - Phase6)) + x1;
    z = (r1* cos(disp - Phase6)) +z1-r1;
    
    %Gforce
    v = sqrt(2*g*(125-(z)));
    Gf = ((v^2)/(g*r1))+sin(disp-Phase6);
    
    phases = 7;
else
    %%Breaking
    temp = Track(Phase7);
    
    x1 = temp(1);
    y = temp(2);
    z1 = temp(3);
    v = sqrt(2*g*(125-(z1)));
    angle = pi/6;
    
    t = disp-Phase7;
    
    if((z1-(tan(angle)*t))<=0)
        
        t = z1/tan(angle);
        
    end
    x = -(t)+x1;
    z = -tan(angle)*(t)+z1; 
    
    distance = z1/sin(angle);
    distance1 = (z1-z)/sin(angle);
    
    %0=(v^2)+2*a*distance
    
    a=-(v^2)/(2*distance);
    
    v = sqrt(2*g*(125-(z1)))-sqrt(2*(-a)*(distance1));
    
    Gb = (a/g);
    Gf = cos(angle);
    phases = 8;
end






Vec = [x,y,z,Gf,Gl,Gb,slope,phases,v];
end

function dis = distance(pos1,pos2)
%Find distance between 2 points in 3d space
    x1=pos1(1);
    y1=pos1(2);
    z1=pos1(3);
    x2=pos2(1);
    y2=pos2(2);
    z2=pos2(3);
    dis = sqrt(((x1-x2)^2)+((y1-y2)^2)+((z1-z2)^2));
end