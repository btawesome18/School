function dNdt = Force(State,constants)
    %By Brian Trybus - ID: 109538512
    %Made 11-28-2020 Edited 12-6-2020
    
    %%Inputs
    %Takes in State Vector with all the variables that change
    %Takes in Constants Vector that has all predefined constants
    
    %%Outputs
    %dNdt or the change rate of all the state variables, and thrust
    
    
    %State = [x0,y0,Vx,Vy,Vol_water,mass_air,dm_rocket];
    Thrust = 0;
    dVdt = 0;
    dMadt = 0;
    dMRdt = 0;
    vol_air = State(5);
    mass_air = State(6);
    massRocket = State(7);
  
    
    %Constants = [g,Cd,rho_Amb,Vol_bottle,P_atmo,gamma,rho_water,D_throat,D_bottle,R,CD,T_air,l_s,M_Bottle,theta,Vol_airI,mass_airI];
    g = constants(1);
    cd = constants(2);
    p_ambiant = constants(3);
    vol_bottle = constants(4);
    P_atmo = constants(5);
    gamma = constants(6);
    p_water = constants(7);
    D_throat = constants(8);
    D_bottle = constants(9);
    R = constants(10);
    CD = constants(11);
    T_atmo = constants(12);
    rail = constants(13);
    Mass_Bottle_empty = constants(14);
    luanchAngle = constants(15);
    Vol_airI = constants(16);
    mass_airI = constants(17);
    At = pi*((D_throat/2)^2);
    Ab = pi*((D_bottle/2)^2);
    
    
    P_i = (mass_airI*R*T_atmo)/(Vol_airI);
    
    
    
    Vmag = sqrt(((State(3))^2)+((State(4))^2));
    
    luanchAngle = (pi/180)*luanchAngle;
    
    massWater = p_water*(vol_bottle - vol_air);
    

    %Set heading
    distFromOrg = sqrt(((State(2)-0.25)^2)+((State(1))^2));
    if(distFromOrg<= rail)
       header = [cos(luanchAngle),sin(luanchAngle)]; %Is on launch rails
    else
       header = [State(3)/Vmag,State(4)/Vmag];%Ungided flight
    end
    
    
    %% Check Phase and calculate thrust
    
    P_end = P_i*((Vol_airI/vol_bottle)^gamma);
    P_0 = P_end*((mass_air/mass_airI)^gamma);

    if ((vol_air)<vol_bottle)
            %Water
            %% Water boosted flight
            
           
            Ve = sqrt(((2*((P_i*((Vol_airI/vol_air)^gamma))-P_atmo)))/p_water);

            waterMassFlow = cd*p_water*At*Ve;

            Thrust = waterMassFlow*Ve;

            %Find dVdt, dMadt, and dmdt
            dVdt = cd*At*sqrt(((2*((P_i*((Vol_airI/vol_air)^gamma))-P_atmo)))/p_water);

            dMadt = 0;
            
            dMRdt = -waterMassFlow;
%(massWater <= 0)&&
    elseif(P_0>P_atmo)%How to tell pressure vs freefall?
            %Pressure
            %% Pressureised flgiht
                P_end = P_i*((Vol_airI/vol_bottle)^gamma);
                P_0 = P_end*((mass_air/mass_airI)^gamma);
                P_crit = P_0*((2/(gamma+1))^(gamma/(gamma-1)));
                
                
                rho = mass_air/vol_bottle;
                T = P_0/(rho * R);
                
                if(P_crit > P_atmo)
                    %% Choked Flow
                    T_e = T*(2/(gamma+1));
                    Ve = sqrt(gamma*R*T_e);
                    Pe = P_crit;
                    pe = (Pe/(R*T_e));
                else
                    %% Unresticted Flow
                    %Mach_e = sqrt( (2/(Y-1)) * ((P/P_amb) ^((Y-1)/Y) - 1) );
                    %M_e = sqrt( (2/(gamma-1)) * ((P_0/P_atmo) ^((gamma-1)/gamma) - 1) );%Rederive to check
                    %M_e = sqrt(((((P_0/P_atmo)^(1/(gamma/(gamma-1))))-1)*(2/(gamma-1))));  
                    M_e = sqrt( (2/(gamma-1)) * ((P_0/P_atmo) ^((gamma-1)/gamma) - 1) );
                    %M_e = sqrt(((T/T_e)-1)/((gamma-1)/2));
                    T_e = T/(1+(((gamma-1)/2)*(M_e^2)));
                    Ve = M_e*sqrt(gamma*R*T_e);
                    Pe = P_atmo;
                    pe = (P_atmo/(R*T_e));
                end
                %Find thrust from Ve

                mF_air = -cd*pe*At*Ve;

                Thrust = -(mF_air*Ve) + ((P_atmo-Pe)*At);

                %Update dNdt

                dVdt = 0;

                dMadt = mF_air;

                dMRdt = mF_air;
            %end
    else
        
         dVdt = 0;

         dMadt = 0;
         
         dMRdt = 0;

    end
    %% Apply thrust, drag, and grav
    
    
    Force = (Thrust).*header;
    Drag = (-(1/2)*p_ambiant*(Vmag^2)*CD*Ab).*header;
    %DragMag = sqrt((Drag(1)^2)+(Drag(2)^2));
    Gravity = (massRocket*g).*[0,-1];
    ForceSum = Force + Drag + Gravity;
    Accel = ForceSum./massRocket;
    
    dNdt = [State(3);State(4);Accel(1);Accel(2);dVdt;dMadt;dMRdt;Thrust];
end

