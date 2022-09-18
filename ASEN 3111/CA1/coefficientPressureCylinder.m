function Cp = coefficientPressureCylinder(theta,R,V,Gamma)
%The given function to find Cp of a Cylender at point theta.
%By Brian Trybus
%1/11/2022
    Cp = 1 - ( (4*(sin(theta)^2)) + ((2*Gamma*sin(theta))/(pi*R*V)) + ((( Gamma )/( 2*pi*R*V ))^2));
end