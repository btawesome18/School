%OEMP1 problem 5

%Author
%Brian Trybus

load('OEMP1_data.mat');

%Part 1:

%Convert everything to metric units
Area = (.4*0.3048)*(1*0.3048)/2; %m^2
Cd = 1.2;

%convert mach to m/s
v = flight_envelope.mach .* flight_envelope.speed_of_sound; %m/s

Q = .5* (flight_envelope.air_density .* (v.^2)); %pascals

Force = Area * Cd * Q; %N

altitudeM = (flight_envelope.altitude); %m

plot(altitudeM, Force);
hold()
xlabel('Altitude (m)');
ylabel('Force (N)');
title('RAT point load vs Altitude at max speed');

%Part 2:

%The max force on the whole turbine is 4014 Newtons this occures when the
%aircraft is flying 383 m/s at sea level.
%No addtinal assumtions where made other than the ones listed at rhe
%begining of problem 5
%1) Max spped engine falure
%2) Rat his not started to spin so it can be considered as static
%3) Wind pressure is constrant
%4) The wind is perpendicular to the blade
%5) The blades can be consided flat triangles
%6) The aircraft is in level straight flight