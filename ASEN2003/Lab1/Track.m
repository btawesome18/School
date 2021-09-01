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

