function [L,D] =sumCpWingForLiftDrag(c,Cp_upper,Cp_lower, rho_inf, V_inf, samples,thickness, alpha)
%Takes in c cord length, Cp_upper and Cp_lower as coefficent splines,
%rho_inf as air density, V_inf as air speed, saples as number of panels,
%thinkness as airfoil thickness, alpha angle of attack.
%Outputs Lift and Drag per unit length of wing. 

% setup equations
    thick = thickness;
    yt = @(x) ((thick*c)/0.2)*(0.2969*sqrt(x/c) - 0.126*(x/c) -(0.3516*(x/c).^2) +(0.2843*(x/c).^3) -0.1036*(x/c).^4); %symetic naca airfoil shape. x is percent cord, and thick is overall thinkness.
    %yt = @(x) ((thick/0.2)*(0.2969*sqrt(x)-(0.1260*x)-(0.3516*(x^2))+(0.2843*(x^3))-(0.1036*(x^4)) ) ); 
    
    
    
    %predeclare variables that may be used multiple times.
    sumN = 0;
    sumA = 0;
    dy = 0;
    dx = 1/samples;
    
    q_inf = 0.5*rho_inf*(V_inf^2);
    
    %Run the loop
    for i = 1:samples
        
        %Take CP and make just pressure
        P_up0 = (fnval(Cp_upper, (i)*dx)*q_inf);
        P_up1 = (fnval(Cp_upper, (i+1)*dx)*q_inf);
        P_lo0 = (fnval(Cp_lower, (i)*dx)*q_inf);
        P_lo1 = (fnval(Cp_lower, (i+1)*dx)*q_inf);

        dy = (yt((i)*dx)-yt((i-1)*dx)); %Find dy
    
        %Sum A and N for each panel
        sumN = sumN + (-(P_up1 +P_up0)  +  (P_lo1 +P_lo0)); 
    
        sumA = sumA +  ((P_up1 +P_up0) +  (P_lo1 + P_lo0))*dy;
    
    end
    
    %Co efficents moved out of the equation are added back in.
    N = (sumN*dx*c)/2;
    A = sumA/2;
    
    %Rotate from A and N to Lift and Drag
    L =N*cos(alpha) -A*sin(alpha);
    D = N*sin(alpha) + A*cos(alpha);

end
