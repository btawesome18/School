
function PlotThickAirfoil(c,alpha,V_inf,p_inf,rho_inf,N)
%By Brian Trybus
%2/24/2022
%Plots streamlines, equipotentials, and pressure contours
%
%   c: chord lenght in meters
%   alpha: angle of attack in degrees
%   V_inf: freestream speed in m/s
%   p_inf: free stream pressure in pascals
%   rho_inf: freestream denisty in kilo per meter cubed
%   N: number of discrete vortices on each side (i.e. top and bottom of wing)
%
%Aproximates the airfoil as a line of vorticies in a uniform flow

%For applying the angle of attack we will rotate our uniform flow to keep
%the airfoil cord is along the x axis

%Naca thickness of 12
Thickness = 0.12;

[pressure,psi,phi,wing,x,y] = FlowThickNaca(alpha,Thickness,V_inf,p_inf,rho_inf,c,N);

%% Plotting

figure();
subplot(3,1,1);
sgtitle("Problem 2: Visualizing Flow Around Thick Airfoils");
hold on;

%Determine color levels for contours

levmin = min(min(psi)); %(1,nx) % defines the color levels -> trial and error to find a good representation
levmax = max(max(psi)); %psi(ny,nx/2);
levels = linspace(levmin,levmax,75)';
contour(x,y,psi,levels,'LineWidth',1.5);

plot(wing(1,:),wing(2,:),"Color",  "Black","LineWidth",2);
plot(wing(1,:),-wing(2,:),"Color",  "Black","LineWidth",2);
xlabel("X (meter)");
ylabel("Y (meter)");
title("Equapotental Lines");

subplot(3,1,2);
hold on;

levmin = phi(1,end); %min(min(phi)); %(1,nx) % defines the color levels -> trial and error to find a good representation
levmax = max(max(phi)); %psi(ny,nx/2);
levels = linspace(levmin,levmax,30)';

contour(x,y,phi,levels,'LineWidth',1.5);
plot(wing(1,:),wing(2,:),"Color",  "Black","LineWidth",2);
plot(wing(1,:),-wing(2,:),"Color",  "Black","LineWidth",2);
xlabel("X (meter)");
ylabel("Y (meter)");
title("Streamlines");

subplot(3,1,3);
hold on;

levmin = min(min(pressure)); %(1,nx) % defines the color levels -> trial and error to find a good representation
levmax = .9*10^5;% max(max(pressure)); %psi(ny,nx/2);
levels = linspace(levmin,levmax,10)';


contourf(linspace(x(1,1),x(1,end),length(x)),linspace(y(1,1),y(end,1),length(y)),pressure,50,'LineColor','none');

%contour(x,y,pressure,levels,'LineWidth',1,"LineColor","Black");

%Plot the wing
plot(wing(1,:),wing(2,:),"Color",  "Black","LineWidth",2);
plot(wing(1,:),-wing(2,:),"Color",  "Black","LineWidth",2);

xlabel("X (meter)");
ylabel("Y (meter)");
title("Pressure Contour");


end






