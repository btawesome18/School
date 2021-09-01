function [V_best,CL] = v2(CL_Vec,CD_min,Weight,rho,area,k) %CD_min, CL_vec, Wieght, alt, rho, Wing Area
%Finds the CL closes to CD0 = 3kCl^2
    %CD0 = 3kC^2
    %CD0 - (3kC^2) = 0;
    diffVec = abs(CD_min-(3*k*(CL_Vec.^2)));
    [~,i]=min(diffVec);
    CL = CL_Vec(i);
    V_best = real(sqrt(Weight./(.5*rho*CL*area)));
end

