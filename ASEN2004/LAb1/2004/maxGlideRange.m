function [velocity] = v1(CL_Vec,LoD_Vec,Weight,rho,area)%L/D,CL, Wieght, alt, rho, Wing Area
[~,i] = max(LoD_Vec);
CL_Glide= CL_Vec(i);
velocity = real(sqrt(Weight./(.5*rho*CL_Glide*area)));
end

