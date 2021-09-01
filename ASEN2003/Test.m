%% 22
p1 = -((Kg^2)*(Km^2))/(Jhub*Rm);
p2 = ((Kg^2)*(Km^2)*L)/(Jhub*Rm);

q1 = Karm/(L*Jhub);
q2 = -(Karm*(Jhub+JL))/(JL*Jhub);

r1 = -(Kg*Km)/(Jhub*Rm);
r1 = -(Kg*Km*L)/(Jhub*Rm);

%% 26

lamda3 = (K3*r1)+(K4*r2) -p1;

lamda2 = (k1*r1) + (k2*r2) + K4*((p2*r1)-(r2*p1))-q2;

lamda1 = (p1*q2)-(q1*p2)+K3*((q1*r2)-(r1*q2))+K2*((p2*r1)-(r2*p1));

lamda0 = K1*((q1*r2)-(r1*q2));

OLOD = (K1((r1*(s^2))+((q1*r2)-(r1*q2))))/((S^4)+(lamda3*(s^3))+(lamda2*(s^2))+(lamda1*(s))+(lamda0));

DOD = (K1((r2*(s^2))+(s*((p2*r1)-(r2*p1)))))/((S^4)+(lamda3*(s^3))+(lamda2*(s^2))+(lamda1*(s))+(lamda0));