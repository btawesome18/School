function [V_best,CL,time] = glideEndurance(CL_Vec,CDvec,Weight,rho,area,e0,AR,hight) %CD_min, CL_vec, Wieght, alt, rho, Wing Area
%Finds the CL closes to 3*CD0 = kCl^2


    CD_min = min(CDvec);

    k = 1/(pi*e0*AR);

    CL = sqrt((3*CD_min)/k);

    CD = (CD_min+ k*(CL).^2);

    V_best = sqrt(((2*Weight)/(CL*area*rho)));
    
    LD = CL/CD;
    
    glideangle = atan(1/(LD));

    sinkRate = V_best*sin(glideangle);

    time = hight/sinkRate;

    
end