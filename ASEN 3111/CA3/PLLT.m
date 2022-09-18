function [e,c_L,c_Di] = PLLT(b,a0_t,a0_r,c_t,c_r,aero_t,aero_r,geo_t,geo_r,N)
%Uses  Prandtl Lifting Line Theory for N expansions and solving a NxN
%matrix for A_n
%   Inputs:
    %   b: span (ft)
    %   a0_t: cross-sectional lift slope at the tip (per rad)
    %   a0_r: cross-sectional lift slope at the root (per rad)
    %   c_r: chord at root (ft) 
    %   c_t: chord at tip (ft) 
    %   aero_t: zero-lift angle of attack at tip (degrees)
    %   aero_r: zero-lift angle of attack at root (degrees)
    %   geo_t: geometric angle of attack at the tip (degrees)
    %   geo_r: geometric angle of attack at the root (degrees)
    %   N: number of odd terms for series expansion (int)
%   Outputs:
    %   e: spanwise efficancy factor
    %   c_L: coefficient of lift 
    %   c_Di: coefficient of induced drag

    
%Convert units to rad:
aero_t = aero_t*(pi/180);
aero_r = aero_r*(pi/180);
geo_t = geo_t*(pi/180);
geo_r = geo_r*(pi/180);

%Make Equations:
alpha_L_0 = @(x) (((aero_r-aero_t)*2/pi)*(cos(x)))+aero_t; %Starting at the wingtip
alphaG = @(x) (((geo_r-geo_t)*2/pi)*(cos(x)))+geo_t; %Starting at the wingtip
a_0 = @(x) (((a0_r-a0_t)*2/pi)*(cos(x)))+a0_t;
c = @(x) (((c_t-c_r)*2/pi)*(cos(x)))+c_t;
b_internals = @(x,n) (((4*b)/(a_0(x)*c(x)))*sin(n*x))+(n*(sin(n*x)/sin(x)));

%Pre allocate Mem
A = zeros(N);
bVec = zeros(N,1);

%Make the A matrix and b vector
for i = 1:N
    theta = (((i)*(pi/(2*(N)))));
    for j = 1:N
    A(i,j)= b_internals(theta,(j*2)-1);
    %A(i,j) = 4*b*sin(theta*(2*j-1))/(a_0(theta)*c(theta)) + (2*j-1)*sin(theta*(2*j-1))/sin(theta);
    end
    bVec(i) = alphaG(theta) - alpha_L_0(theta);
end

%Solves the system for x vector of A values
A(isnan(A))=0;
x = linsolve(A,bVec);

A1 = x(1);
%Find delta
delta = 0;
for j = 2:N
    delta = delta + ((2*j)-1)*((x(j)/A1)^2);
end
%Use A to find lift drag and e
s = b*(c_t+c_r)/2;
AR = (b.^2)/s;
c_L = A1 * pi * AR;
c_Di = ((c_L^2)/(pi*AR))*(1+delta);
e=1/(1+delta);

end