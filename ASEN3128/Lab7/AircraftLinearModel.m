function [Alon, Blon, Alat, Blat] = AircraftLinearModel(trim_definition, trim_variables, aircraft_parameters)
%
% state = [x^E, y^E, Z^E, u^E, v^E, w^E, roll, pitch, yaw, p, q, r]';
%
%


u0 = trim_definition(1);
h0 = trim_definition(2);

alpha0 = trim_variables(1);
de0 = trim_variables(2);
dt0 = trim_variables(3);

theta0 = alpha0;

ap = aircraft_parameters;
rho = stdatmo(h0);
m = aircraft_parameters.m;
S = aircraft_parameters.S;

%%%%%%%%%%%%%%%%%%%%%%
%%% Longitudinal
%%%%%%%%%%%%%%%%%%%%%%

%%%% Trim values
CW0 = ap.W/((1/2)*rho*u0^2*ap.S);
CL0 = CW0*cos(theta0);
CLmin = aircraft_parameters.CLmin;
CD0 = ap.CDmin + ap.K*(CL0-ap.CLmin)^2;
CT0 = CD0 + CW0*sin(theta0);
K = aircraft_parameters.K;

%%%% Nondimensional stabiulity derivatives in body coordinates
dTdu = dt0*ap.Cprop*ap.Sprop*(ap.kmotor-2*u0+dt0*(-2*ap.kmotor+2*u0));
CXu = dTdu/(.5*rho*u0*ap.S)-2*CT0;

CDu = 0;
CLu = 0;
Cmu = 0;

CZu = -CLu;

CZalpha = -CD0 - ap.CLalpha;
CXalpha = CL0*(1-2*ap.K*ap.CLalpha);

CZalphadot = -ap.CLalphadot;

CZq = -ap.CLq;


% Longitudinal dimensional stability derivatives (from Etkin and Reid)
Xu = rho*u0*ap.S*(CW0*sin(theta0) + .5*CXu);
Zu = rho*u0*ap.S*(-CW0*cos(theta0) + .5*CZu);
Mu = (1/2)*rho*u0*ap.c*ap.S*Cmu;


Xw = (1/2)*rho*u0*ap.S*CXalpha;
Zw = (1/2)*rho*u0*ap.S*CZalpha;
Mw = (1/2)*rho*u0*ap.c*ap.S*ap.Cmalpha;

Xq = 0;
Zq = (1/4)*rho*u0*ap.c*ap.S*CZq;
Mq = (1/4)*rho*u0*ap.c^2*ap.S*ap.Cmq;

Xwdot = 0;
Zwdot = (1/4)*rho*ap.c*ap.S*CZalphadot;
Mwdot = (1/4)*rho*ap.c^2*ap.S*ap.Cmalphadot;


% Matrices
Alon1 = [  Xu/ap.m,           Xw/ap.m,               0,                          -ap.g*cos(theta0);
        Zu/(ap.m-Zwdot),   Zw/(ap.m-Zwdot),       (Zq + ap.m*u0)/(ap.m-Zwdot),      -(ap.m*ap.g*sin(theta0))/(ap.m-Zwdot);
        (Mu + (Mwdot*Zu)/(ap.m-Zwdot))/ap.Iy,         (Mw + (Mwdot*Zw)/(ap.m-Zwdot))/ap.Iy, ...
                (Mq + (Mwdot*(Zq+ap.m*u0))/(ap.m-Zwdot))/ap.Iy,      ((Mwdot*(-ap.m*ap.g*sin(theta0)))/(ap.m-Zwdot))/ap.Iy;
        0,              0,                  1,                             0];

 CLde = aircraft_parameters.CLde;
    CDde = 2*K*(CL0 - CLmin)*CLde;
Sprop = aircraft_parameters.Sprop;
Cprop = aircraft_parameters.Cprop;
km = aircraft_parameters.kmotor;
Iy = aircraft_parameters.Iy;
 c = aircraft_parameters.c;
 b =  aircraft_parameters.b;
Cxde = - CDde*cos(alpha0) + CLde*sin(alpha0);
Czde =  - CDde*sin(alpha0) - CLde*cos(alpha0);
Cmde = aircraft_parameters.Cmde;
Xde = Cxde *0.5* rho*u0^2 * S;
Zde = Czde *0.5* rho*u0^2 * S;
Mde = Cmde *0.5* rho*u0^2 * c* S;
Zdt =  0;
Mdt =  0;
Cxdt = 2* Sprop * Cprop * (km - u0)*(u0+2*dt0*km-u0) / (S*u0^2) ;
Xdt = (1/2)*rho * (u0^2) * S * Cxdt;

    
Blon = [ Xde/m Xdt/m;
        Zde/(m- Zwdot)  Zdt/(m- Zwdot) ;
        (Mde/Iy)+(Mwdot*Zde)/(Iy*(m-Zwdot))  (Mdt/Iy)+(Mwdot*Zdt)/(Iy*(m-Zwdot)) ;
        0 0 ;
        0 0 ;
        0 0 ] ; % 4x2, need to change for 6x2


Alon = [Alon1 zeros(4,2);...
        1 0 0 0 0 0;...
        0 1 0 -u0 0 0];
        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lateral
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lateral-directional dimensional stability derivatives
Yv = (1/2)*rho*u0*ap.S*ap.CYbeta;
Yp = (1/4)*rho*u0*ap.b*ap.S*ap.CYp;
Yr = (1/4)*rho*u0*ap.b*ap.S*ap.CYr;

Lv = (1/2)*rho*u0*ap.b*ap.S*ap.Clbeta;
Lp = (1/4)*rho*u0*ap.b^2*ap.S*ap.Clp;
Lr = (1/4)*rho*u0*ap.b^2*ap.S*ap.Clr;

Nv = (1/2)*rho*u0*ap.b*ap.S*ap.Cnbeta;
Np = (1/4)*rho*u0*ap.b^2*ap.S*ap.Cnp;
Nr = (1/4)*rho*u0*ap.b^2*ap.S*ap.Cnr;

G = ap.Ix*ap.Iz-ap.Ixz^2;

G3=ap.Iz/G;
G4=ap.Ixz/G;
G8=ap.Ix/G;


Alat1 = [Yv/ap.m, Yp/ap.m, (Yr/ap.m - u0), ap.g*cos(theta0);
    G3*Lv + G4*Nv, G3*Lp + G4*Np, G3*Lr + G4*Nr, 0;
    G4*Lv + G8*Nv, G4*Lp + G8*Np, G4*Lr + G8*Nr, 0;
    0, 1, tan(theta0), 0];

Cydr = aircraft_parameters.CYdr ;
Clda = aircraft_parameters.Clda ;
Cldr = aircraft_parameters.Cldr ;
Cnda = aircraft_parameters.Cnda ;
Cndr = aircraft_parameters.Cndr ;
Ydr = Cydr *0.5*rho*(u0^2)*S;
Lda = Clda *0.5*rho*(u0^2)*S * b;
Ldr = Cldr *0.5*rho*(u0^2)*S * b;
Nda =  Cnda *0.5*rho*(u0^2)*S * b;
Ndr = Cndr *0.5*rho*(u0^2)*S * b;
Blat = [ 0 Ydr/m;
        G3*Lda+G4*Nda G3*Ldr+G4*Ndr ;
        G4*Lda+G8*Nda G4*Ldr+G8*Ndr ;
        0 0 ;
        0 0 ;
        0 0 ] ; % 4x2, need to change for 6x2;


Alat = [Alat1 zeros(4,2);...
        0 0 sec(theta0) 0 0 0;...
        1 0 0 0 u0*cos(theta0) 0];

