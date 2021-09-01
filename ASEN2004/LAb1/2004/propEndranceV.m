function [V_best] = propEndranceV(CL_Vec,CD_min,Weight,rho,area,k)%CD_min, CL_vec, Wieght, alt, rho, Wing Area
%Finds the CL closes to 3CD0 = kCl^2
    %3CD0 = 3kC^2
    %3*CD0 - (kC^2) = 0;
    diffVec = abs((3*CD_min)-(k*(CL_Vec.^2)));
    [~,i]=min(diffVec);
    CL = CL_Vec(i);
    V_best = real(sqrt(Weight./(.5*rho*CL*area)));
end

