
function PlotThinAirfoil(c,alpha,V_inf,p_inf,rho_inf,N)
%By Brian Trybus
%2/24/2022
%Plots streamlines, equipotentials, and pressure contours
%
%   c: chord lenght in meters
%   alpha: angle of attack in degrees
%   V_inf: freestream speed in m/s
%   p_inf: free stream pressure in pascals
%   rho_inf: freestream denisty in kilo per meter cubed
%   N: number of discrete vortices
%
%Aproximates the airfoil as a line of vorticies in a uniform flow


%Vortex sheet of a thin airfoil is defined as
%   y = 2*alpha*V_inf * sqrt( (1-(x/c))/x/c )

%For applying the angle of attack we will rotate our uniform flow to keep
%the airfoil static

%% Convert Units

alpha = (pi*alpha)/180;

%% Set up Grid/ define enviroment

%defult to wing taking 1/3 of screen and square frame
xmin = -1*c;
xmax = 2*c;
nx = 100;
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
    Gamma = 2*alpha*V_inf*sqrt((1-(R/c))/(R/c))*(c/N);
    phiWing = phiWing + ((Gamma/(2*pi))*atan2(y,(x-R)));
    psiWing = psiWing + ((Gamma/(2*pi))*log( sqrt( (y.^2)+ ((x-R).^2) ) ) );

    VxWing = VxWing  - sin(atan2(y,(x-R))).*((Gamma/(2*pi))./sqrt( (y.^2)+ ((x-R).^2) ) );
    VyWing = VyWing  - cos(atan2(y,(x-R))).*((Gamma/(2*pi))./sqrt( (y.^2)+ ((x-R).^2) ) );

end

%Apply Superpos to get complex flow

phi = phiWing+phiUniform;%Potental flow
psi = psiWing+psiUniform; %StreamFunc

Vx = VxWing+VxUniform;
Vy = VyWing+VyUniform;

%Use bernoulli's to get pressure
pressure = p_inf + (0.5*rho_inf*(((Vx.^2)+(Vy.^2))));

%% Plotting

%Make Figure
figure();
subplot(3,1,1);
sgtitle("Problem 1: Thin Plate");
hold on;

%Determine color levels for contours
levmin = min(min(psi)); %(1,nx) % defines the color levels -> trial and error to find a good representation
levmax = max(max(psi)); %psi(ny,nx/2);
levels = linspace(levmin,levmax,75)';
contour(x,y,psi,levels,'LineWidth',1.5);
%Format plot
plot([0,c],[0,0],"Color",  "Black","LineWidth",2);
xlabel("X (meter)");
ylabel("Y (meter)");
title("Equapotental Lines");

subplot(3,1,2)
hold on;
%Determine color levels for contours
levmin = phi(1,nx); %min(min(phi)); %(1,nx) % defines the color levels -> trial and error to find a good representation
levmax = max(max(phi)); %psi(ny,nx/2);
levels = linspace(levmin,levmax,30)';
contour(x,y,phi,levels,'LineWidth',1.5);
%Format plot
plot([0,c],[0,0],"Color",  "Black","LineWidth",2);
xlabel("X (meter)");
ylabel("Y (meter)");
title("Streamlines");

subplot(3,1,3)
hold on;

%Determine color levels for contours
contourf(linspace(xmin,xmax,nx),linspace(ymin,ymax,ny),pressure,50,'LineColor','none'); %,'LineColor','none'

%Format plot
plot([0,c],[0,0],"Color",  "Black","LineWidth",2);
xlabel("X (meter)");
ylabel("Y (meter)");
title("Pressure Contour");

end
