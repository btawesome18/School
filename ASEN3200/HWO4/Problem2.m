load("world_coastline_low.txt")
x = world_coastline_low(:,1);
y = world_coastline_low(:,2);
figure(1);
plot(x,y)
hold on;



PdaySideReal = 86164.1;

mu = 3.986*(10^5);%Mu in km and other SI units

%op = [20000 0.25 40*(pi/180) 300*(pi/180) 0 80*(pi/180)]; %Given Orbit


J2 = 1.087*(10^-3);

Re = 6378;

TimeLegth = 1.5*PdaySideReal;

TimeStep = 25;

op = [nthroot((mu*((PdaySideReal/(2*pi))^2)),3),0.5,63.4*(pi/180),65*(pi/180),0*(pi/180),0]; 


for i = 1:5
    op(3) = (63.4*(pi/180))*((5-i)/4);
    [angle1,angle2,hight] = GroundTrack(op,mu,J2,Re,PdaySideReal,TimeLegth,TimeStep);
    indexMax= islocalmax(hight);
    indexMin= islocalmin(hight);
    scatter(angle1,angle2);
    labelpoints(angle1(indexMax),angle2(indexMax),'Apoapsis');
    scatter(angle1(indexMax),angle2(indexMax),'x');
    labelpoints(angle1(indexMin),angle2(indexMin),'Periapsis');
    scatter(angle1(indexMin),angle2(indexMin),'x');
end
%legendInc = ['Coast','Inclination = 63.4','Inclination = 47.6','Inclination = 31.7','Inclination = 15.9','Inclination = 0'];
title('Ground Track With Variations in Inclination');
xlabel('Longitude');
ylabel('Latitude');
%legend(legendInc);

figure(2);
plot(x,y)
hold on;
op(3)=45*(pi/180);

for i = 1:5
    op(1) = nthroot((mu*(((PdaySideReal/i)/(2*pi))^2)),3);
    [angle1,angle2,hight] = GroundTrack(op,mu,J2,Re,PdaySideReal,TimeLegth,TimeStep);
    [indexMax]=islocalmax(hight);
    [indexMin]=islocalmin(hight);
    scatter(angle1,angle2);
    labelpoints(angle1(indexMax),angle2(indexMax),'Apoapsis')
    scatter(angle1(indexMax),angle2(indexMax),'x');
    labelpoints(angle1(indexMin),angle2(indexMin),'Periapsis')
    scatter(angle1(indexMin),angle2(indexMin),'x');
end
    
title('Ground Track With Variations in Period');
xlabel('Longitude');
ylabel('Latitude');

figure(3);
plot(x,y)
hold on;
op(1)=nthroot((mu*((PdaySideReal/(2*pi))^2)),3);

for i = 1:5
    op(2) = (i-0.5)/5;
    [angle1,angle2,hight] = GroundTrack(op,mu,J2,Re,PdaySideReal,TimeLegth,TimeStep);
    [indexMax]=islocalmax(hight);
    [indexMin]=islocalmin(hight);
    scatter(angle1,angle2);
    labelpoints(angle1(indexMax),angle2(indexMax),'Apoapsis')
    scatter(angle1(indexMax),angle2(indexMax),'x');
    labelpoints(angle1(indexMin),angle2(indexMin),'Periapsis')
    scatter(angle1(indexMin),angle2(indexMin),'x');
end
    
title('Ground Track With Variations in Eccentricity');
xlabel('Longitude');
ylabel('Latitude');


function E = kepler_E(e, M)
% From the TextBook
%{
This function uses Newton’s method to solve Kepler’s
equation E - e*sin(E) = M for the eccentric anomaly,
given the eccentricity and the mean anomaly.
E - eccentric anomaly (radians)
e - eccentricity, passed from the calling program
M - mean anomaly (radians), passed from the calling program
pi - 3.1415926...
User m-functions required: none
%}
% ––––––––––––––––––––––––––––––––––––––––––––––
%...Set an error tolerance:
    error = 1.e-9;
    %...Select a starting value for E:
    if M < pi
        E = M + e/2;
    else
        E = M - e/2;
    end
    %...Iterate on Equation 3.17 until E is determined to within
    %...the error tolerance:
    ratio = 1;
    while abs(ratio) > error
        ratio = (E - e*sin(E) - M)/(1 - e*cos(E));

        E = E - ratio;
    end

end


function [angle1,angle2,hight] = GroundTrack(op,mu,J2,Re,PdaySideReal,TimeLegth,TimeStep)



    a = op(1);
    
    e0 = op(2);
    
    Omega0 = op(4);
    
    inc = op(3);
    
    w0 = op(5);

    n = sqrt(mu/(a^3));

    p = a*(1-(e0^2));

    t = 0:TimeStep:TimeLegth;
    
    angle1 = zeros(1,length(t));
    angle2 = zeros(1,length(t));
    hight = zeros(1,length(t));
    
    rotRate = (2*pi)/PdaySideReal;
    
    OmegaDot = -1.5*J2*sqrt(mu/(a^3))*(Re/p)*cos(inc);
    
    wDot = 0.75*n*J2*((Re/(p))^2)*(2-(2.5*(sin(inc)^2)));
    for i = 1:length(t)

        w = w0 + (wDot*t(i));

        Omega = Omega0+(OmegaDot*t(i));

        Cp_n = (M3(w)*M1(inc)*M3(Omega));

        M = n*t(i);

        E = kepler_E(e0,M);

        f = 2*atan((sqrt((1+e0)/(1-e0)))*tan(E/2));

        R = a*(1-(e0*cos(E)));

        rp = R*[cos(f);sin(f);0];

        r_inframe=Cp_n*rp;

        R_rot = M3(rotRate*t(i))*r_inframe;

        angle1(i) = atan2(R_rot(2),R_rot(1))*(180/pi); %y/x to get angle about z axis
        v1 = M3(angle1(i)*(pi/180))*R_rot;
        angle2(i)= atan(v1(3)/v1(1))*(180/pi);

        hight(i) = norm(rp);

    end

end