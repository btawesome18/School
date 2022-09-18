function [dydt, F, phase] = odefunc(t, y, C)
%% Load in Constants and Variables
    gravity = C(1);
    Vbottle = C(2);
    P0 = C(3);
    P_amb = C(4);
    rhoW = C(5);
    rhoA = C(6);
    Ab = C(7);
    At = C(8);
    Cd = C(9);
    CD = C(10);
    V0air = C(11);
    R = C(12);
    theta = C(13);
    ls = C(14);
    g = C(15);
    M0air = C(16);
    windX = C(17);
    windY = C(18);
    bata = C(19); %Launch Angle in xy plane
    
    rx = y(1); % X position
    ry = y(2);
    rz = y(3); % Z position
    vx = y(4); % Velocity in the x-dir
    vy= y(5);
    vz = y(6); % Velocity in the z-dir
    Mr = y(7); % Rocket Mass
    Ma = y(8); % Air Mass
    Vair = y(9); % Air Volume
    
    %% Get heading components 
    v = sqrt(vx^2 + vz^2 + vy^2);
    
    % If rocket still on launch stand, heading components go unchanged
    if(rz <= ls*sind(theta)) 
        hx = cosd(theta)*cosd(bata);
        hy = cosd(theta)*sind(bata);
        hz = sind(theta);
    else 
        hx = (vx/v);
        hy = (vy/v);
        hz = (vz/v);
    end

    %% First Phase (Before Water is Exhausted) 
    if (Vair < Vbottle)
        % Pressure at anytime t for Phase 1
        P = P0*(V0air/Vair)^g;
        
        % Exhaust Velocity
        Ve = sqrt((2/rhoW) * (P - P_amb));
        
        % Mass flow rate of water out of throat
        dMw_dt = Cd * rhoW * At * Ve;
        
        % Thrust for Phase 1
        F = dMw_dt * Ve;                    
        
        % Change in Air Volume, Rocket Mass, Air Mass over time
        % For this phase the change in air mass is 0
        dVa_dt = Cd * At * Ve;
        dMr_dt = -dMw_dt;
        dMa_dt = 0;
        phase = 1; % Just to check the for start of next phase
    end
    
    %% Second Phase (After Water is Exhausted)
    Pend = P0 * (V0air/Vbottle)^g; % Pressure in bottle at the end of Phase 1
    P = (Pend) * (Ma/M0air)^g; % Pressure at any time t for Phases 2 & 3
    
    if (Vair >= Vbottle && P > P_amb)
        % Density of air in bottle at anytime t
        rho = (Ma)/Vbottle;
        
        % Temperature of air in bottle at anytime t
        T = P/(rho*R);
        
        % Critical pressure
        P_crit = P*(2/(g+1))^(g/(g-1));
        
        if (P_crit > P_amb) % If flow is choked (Me = 1)
            % Find exit temperature, pressure, density, velocity
            Te = (2/(g+1))*T;
            Pe = P_crit;
            rhoE = Pe/(R*Te);
            Ve = sqrt(g*R*Te);
            
        elseif (P_crit < P_amb) % If flow is not choked
            % Find exit Mach Number, temperature, pressure, density, velocity
            Me = sqrt((((P/P_amb)^((g-1)/g))-1)*(2/(g-1)));
            Te = T/(1 + ((g-1)/2) * Me^2);
            Pe = P_amb;
            rhoE = P_amb/(R*Te);
            Ve = Me * sqrt(g*R*Te);
        end
        
        % Thrust for Phase 2
        dMa_dt = Cd * rhoE * At * Ve;
        F = (dMa_dt * Ve) + (P_amb - Pe)*At;
        
        % Change in Rocket Mass, Air Mass, Air Volume over time
        % For this phase the change in Air Volume is 0
        dMr_dt = -dMa_dt;
        dMa_dt = dMr_dt;
        dVa_dt = 0; 
        phase = 2; % Just to check the for start of next phase
    end
    
    %% Third Phase (Ballistic Phase)
    % For this phase Thrust, Change in Rocket Mass, Air Mass, Air Volume
    % over time are all equal to 0
    
    if (Vair >= Vbottle && P <= P_amb)
        F = 0;
        dMr_dt = 0;
        dMa_dt = 0;
        dVa_dt = 0;
        phase = 3; % Just to check the for start of next phase
    end
    
    %% Calculate Velocity and Acceleration Vectors
    %Find airspeed
    Vax = vx+windX;
    Vay = vy+windY;
    VA = sqrt(Vax^2 + Vay^2 + vz^2);

    D = (1/2) * (rhoA) * (VA^2) * CD * Ab; % Drag
    
    % Calculate Drag and Thrust Components using Heading
    Dx = D*(Vax/VA);
    Dy = D*(Vay/VA);
    Dz = D*(vz/VA);
    Fx = F*hx;
    Fy = F*hy;
    Fz = F*hz;
    
    % Calculate Velocity and Acceleration components
    drx_dt = vx;
    dry_dt = vy;
    drz_dt = vz;
    dvx_dt = (Fx-Dx)/Mr;
    dvy_dt = (Fy-Dy)/Mr;
    dvz_dt = ((Fz-Dz) - (Mr*gravity))/Mr;
    
    
    dydt = [drx_dt;dry_dt; drz_dt; dvx_dt;dvy_dt; dvz_dt; dMr_dt; dMa_dt; dVa_dt];
    
end