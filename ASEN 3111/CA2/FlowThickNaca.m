function [pressure,psi,phi,wing,x,y] = FlowThickNaca(alpha,Thickness,V_inf,p_inf,rho_inf,c,N)
%By Brian Trybus
%2/24/2022
%Returns The pressure, phi, and psi, and wing shape
%Inputs:
%   alpha: anlge of attack in degrees
%   Thickness: naca 00xx callout in range of 0 to 0.99
%   V_inf: freestream velocity in m/s
%   p_inf: free stream pressure in pascals
%   rho_inf: freestream denisty in kilo per meter cubed
%   c: chord lenght in meters
%   N: number of panels
%Outputs
%   pressure: nx by ny matrix of pressure at points in pascals
%   psi: Streamfunction solutions nx by ny matrix
%   phi: Velocity Potential nx by ny matrix
%   wing: 2 by N+1 array of x y cords of naca wing

%% Convert Units

alpha = (pi*alpha)/180; %degree to rad

%% Setting up naca equation

yt = @(x) ((Thickness *c)/0.2)*(  (0.2969*(sqrt(x/c))) - (0.126*(x/c)) - (0.3516*((x/c).^2)) + (0.2843*((x/c).^3)) - (0.1036*((x/c).^4)) );%x.^2 + y.^2 - 3;

%% Set up Grid/ define enviroment

%defult to wing taking 1/3 of screen and square frame
xmin = -1*c;
xmax = 2*c;
nx = 200;
ymin = -1.5*c;
ymax = 1.5*c;
ny = nx;
[x,y]=meshgrid(linspace(xmin,xmax,nx),linspace(ymin,ymax,ny)); % Makes grid vectors to be used.

%Start with uniform flow and then rotate it.

phiUniform = V_inf*(y*cos(alpha)-x*sin(alpha));
psiUniform = V_inf*(x*cos(alpha)+y*sin(alpha));

VxUniform = ones(nx,ny)*V_inf*cos(alpha);
VyUniform = ones(nx,ny)*V_inf*sin(alpha);
%% Make the thin Wing equations
%   Use a for loop to go through each point on cord and make a vortex and
%   sum to phiWing and psiWing

%Make Cord as vector
%Cord = linspace(0,c,N+1) + (c/(2*N));
phiWing = zeros(nx,ny);
psiWing = zeros(nx,ny);

VxWing = zeros(nx,ny);
VyWing = zeros(nx,ny);

for R = linspace(0,c-(c/N),N) + (c/(2*N)) %Returns midpoints of each panel
    %Find vortex strength for current pos
    Y = yt(R);
    Gamma = 2*alpha*V_inf*sqrt((1-(R/c))/(R/c))*(c/N);
    phiWing = phiWing + ((Gamma/(2*pi))*atan2((y-Y),(x-R))) + ((Gamma/(2*pi))*atan2((y+Y),(x-R)));
    psiWing = psiWing + ((Gamma/(2*pi))*log( sqrt( ((y-Y).^2) + ((x-R).^2) ) ) ) + ((Gamma/(2*pi))*log( sqrt( ((y+Y).^2)+ ((x-R).^2) ) ) );

    VxWing = VxWing  - sin(atan2((y-Y),(x-R))).*((Gamma/(2*pi))./sqrt( ((y-Y).^2)+ ((x-R).^2) ) ) - sin(atan2((y+Y),(x-R))).*((Gamma/(2*pi))./sqrt( ((y+Y).^2)+ ((x-R).^2) ) );
    VyWing = VyWing  - cos(atan2((y-Y),(x-R))).*((Gamma/(2*pi))./sqrt( ((y-Y).^2)+ ((x-R).^2) ) ) - cos(atan2((y+Y),(x-R))).*((Gamma/(2*pi))./sqrt( ((y+Y).^2)+ ((x-R).^2) ) );

end

wing = [linspace(0,c,N+1);yt(linspace(0,c,N+1))];

%Apply Superpos to get complex flow

phi = phiWing+phiUniform;%Potental flow
psi = psiWing+psiUniform; %StreamFunc

Vx = VxWing+VxUniform;
Vy = VyWing+VyUniform;

%Use bernoulli's to get pressure
pressure = p_inf + (0.5*rho_inf*(((Vx.^2)+(Vy.^2))));


end