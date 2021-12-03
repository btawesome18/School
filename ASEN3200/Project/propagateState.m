function x = propagateState(oe0,t,t_0,MU,J2,Re)
%DESCRIPTION: Computes the propagated position and velocity in km, km/s
%accounting for approximate J2 perturbations
%
%INPUTS:
% oe0       Orbit elements [a,e,i,Om,om,f] at time t0 (km,s,rad)
% t         Current time (s)
% t0        Time at the initial epoch (s)
% MU        Central body's gravitational constant (km^3/s^2)
% J2        Central body's J2 parameter (dimensionless)
% Re        Radius of central body (km)
%
%OUTPUTS:
% x         Position and velocity vectors of the form [r; rdot] (6x1) at
%             time t


%make sure that function has outputs
x = NaN(6,1);

%1) Compute the mean orbit elements oe(t) at time t due to J2 perturbations
    
%2) Solve the time-of-flight problem to compute the true anomaly at tiem t

%3) Compute r(t), rdot(t) in the perifocal frame

%4) Compute r(t), rdot(t) in the ECI frame, save into x


    t = t-t_0;

    a = oe0(1);
    
    e0 = oe0(2);
    
    Omega0 = oe0(4);
    
    inc = oe0(3);
    
    w0 = oe0(5);

    f0 = oe0(6);
    
    E0 = atan2((sqrt(1-(e0^2))*sin(f0)),(1+(e0*cos(f0))));
    
    M0 = E0 - (e0*sin(E0));
    
    tp = -M0*(sqrt((a^3)/MU)); % we need time from pareapis, t-tp
    
    ta = t-tp;
    
    n = sqrt(MU/(a^3));

    p = a*(1-(e0^2));
    
    PdaySideReal = 86164.1;
    
    rotRate = -(2*pi)/PdaySideReal;
    
    OmegaDot = -1.5*J2*sqrt(MU/(a^3))*(Re/p)*cos(inc);
    
    wDot = 0.75*n*J2*((Re/(p))^2)*(2-(2.5*(sin(inc)^2)));

    w = w0 + (wDot*t);
    
    Omega = Omega0+(OmegaDot*t);
    
    M = (n*ta);

    E = kepler_E(e0,M);
    
    f = 2*atan((sqrt((1+e0)/(1-e0)))*tan(E/2));
    
    R = a*(1-(e0*cos(E)));

    rp = R*[cos(f);sin(f);0];
    
    Cp_n = (M3(w)*M1(inc)*M3(Omega));
    
    r_inframe = Cp_n*rp;
    
    R_rot = M3(rotRate*ta)*r_inframe;
    
    rp_dot = (sqrt(MU/p))*[-sin(f);(e0+cos(f));0];
    
    rdot_inframe = Cp_n*rp_dot;
    
    Rdot_rot = M3(rotRate*ta)*rdot_inframe;
    
    x = [R_rot;Rdot_rot];
    
end

%% Other Functions used

function E = kepler_E(e, M)
% From the TextBook
%{
This function uses Newton’s method to solve Kepler’s
equation E - e*sin(E) = M for the eccentric anomaly,
given the eccentricity and the mean anomaly.
E - eccentric anomaly (radians)
e - eccentricity, passed from the calling program
M - mean anomaly (radians), passed from the calling program
pi - 3.1415926...
User m-functions required: none
%}
% ––––––––––––––––––––––––––––––––––––––––––––––
%...Set an error tolerance:
    error = 1.e-9;
    %...Select a starting value for E:
    if M < pi
        E = M + e/2;
    else
        E = M - e/2;
    end
    %...Iterate on Equation 3.17 until E is determined to within
    %...the error tolerance:
    ratio = 1;
    while abs(ratio) > error
        ratio = (E - e*sin(E) - M)/(1 - e*cos(E));

        E = E - ratio;
    end

end


%% DCM transforms
function out = M1(a)

     out = [1,0,0;0,cos(a),sin(a);0,-sin(a),cos(a)];

end

function out = M3(c)
%DCM 
     out = [cos(c),sin(c),0;-sin(c),cos(c),0;0,0,1];
     
end
