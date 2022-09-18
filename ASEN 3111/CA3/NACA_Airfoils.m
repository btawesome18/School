function [x,y,aLo,dCLda] = NACA_Airfoils(m,p,t,c,N)
%By Brian Trybus
%04/02/2022
%Takes in NACA airfoil and outputs coordaites, exsimated lift slope, and
%zero lift ange

%   Inputs:
%m: first digit of NACA XXXX code
%p: second digit of NACA XXXX code
%t: last to digits of NACA XXXX code
%c: chord length in meters (m)
%N: number of panels

%   Outputs:
%x: xpos of vertex at index (m)
%y: ypos of vertex at index (m)
%aLo: Zero lift angle of attack in rad from thin airfoil theory
%dCLda: lift slope from thin airfoil theory

%NACA fucntions deffined here:

yt = @(x,t,c) ((t *c)/0.2)*(  (0.2969*(sqrt(x/c))) - (0.126*(x/c)) - (0.3516*((x/c).^2)) + (0.2843*((x/c).^3)) - (0.1036*((x/c).^4)) );
yc1 = @(x,m,c,p) ((m*(x/(p^2)))*((2*p)-(x/c)));
yc2 = @(x,m,c,p) ((m*((c-x)/((1-p)^2)))*(1+(x/c)-(2*p)));
dyc1 = @(x,m,c,p) (m/(p^2))*((2*p)-(2*x/c));
dyc2 = @(x,m,c,p) (m/((1-p)^2))*((2*p)-(2*x/c));
zeta = @(dydx) atan(dydx);

%Pre Allocat Memory here

    xU = zeros(1,N);
    xL = zeros(1,N);
    yU = zeros(1,N);
    yL = zeros(1,N);

%Loop for coords here.
for i = 1:N

    xCur = (i-1)*(c/N);

    if (xCur<=(p*c)) %Check if is past the bend
        ycCur = yc1(xCur,m,c,p);
        Z = zeta(dyc1(xCur,m,c,p));
    else
        ycCur = yc2(xCur,m,c,p);
        Z = zeta(dyc2(xCur,m,c,p));
    end

    xU(i) = xCur - (yt(xCur,t,c)*sin(Z));
    yU(i) = ycCur + (yt(xCur,t,c)*cos(Z));

    xL(i) = xCur + (yt(xCur,t,c)*sin(Z));
    yL(i) = ycCur - (yt(xCur,t,c)*cos(Z));

end

%Gets rid of NAND in center
xU(1)=0;
yU(1)=0;
xL(1)=0;
yL(1)=0;
%Append the upper and lower surfaces
xU = flip(xU);
yU = flip(yU);
x = [xL,xU(1:end)];
y = [yL,yU(1:end)];

%Find the thin airfoil specs
dCLda = 2*pi; %Thin airfoild slope is always same

%xIn=(c/2)*(1-cos(theta));
dYcdx= @(xIn,m,c,p)((xIn<=(p*c)).*dyc1(xIn,m,c,p) +(xIn>(p*c)).*dyc2(xIn,m,c,p));
intIn = @(theta) dYcdx((c/2)*(1-cos(theta)),m,c,p).*(cos(theta)-1);

aLo = (180/pi)*(-1/pi)*trapz(linspace(0,pi,100),intIn(linspace(0,pi,100)));

aLo(isnan(aLo))=0;

end