%ASEN 3113 - Design Lab Code
%By Cannon Palmer

emis = 0.85;
absorb = 0.2;

%As = 0.289; %Area Found (m^2)
As = 0.31;

dwin = 147.3 * 10^9;
dequ = 149.7 * 10^9;
dsum = 152.1 * 10^9;

Ir_ecl = 11;
Ir_win = 88;
Ir_sum = 63;
Ir_equ = 75.5;

Gsun = 64 * 10.^6;
Rsun = 695.7 * 10^6;
G_func = @(d) (Rsun.^2 / d.^2) * Gsun;

boltz = 5.67 * 10^(-8);
tilt = 23.5; %tilt of the Earth

area_func = @(T,G,Ir,emis,abs,theta) -20 ./ (G*abs*sin(theta)*cosd(tilt) +...
    Ir - emis * boltz * T.^4);

T_func = @(As,G,Ir,emis,abs,theta,tilt) ((20 + G*As*abs*sind(theta)*cosd(tilt)+emis*Ir*As) ./ ...
    (emis * boltz * As)) .^(1/4) - 273;
T_func_surv = @(As,G,Ir,emis,abs,theta,tilt) ((G*As*abs*sind(theta)*cosd(tilt)+emis*Ir*As) ./ ...
    (emis * boltz * As)) .^(1/4) - 273;

G_sum = G_func(dsum);
G_win = G_func(dwin);
G_equ = G_func(dequ);

x = 180;
theta_vec = linspace(0,360,2*x + 1);
T_op_vec = linspace(20+273,30+273,100);
T_surv_vec = linspace(-40+273,100+273,100);


% Winter Stuff
win_op = [T_func(As,G_win,Ir_win,emis,absorb,theta_vec(1:x+1),tilt), ...
    T_func(As,G_win,Ir_win,emis,absorb,zeros(1,x),tilt)];
win_surv = [T_func_surv(As,G_win,Ir_win,emis,absorb,theta_vec(1:x+1),tilt), ...
    T_func_surv(As,G_win,Ir_win,emis,absorb,zeros(1,x),tilt)];
figure(1)
subplot(2,1,1)
plot(theta_vec/15,win_op)
title('Winter Operational Day')

subplot(2,1,2)
plot(theta_vec/15,win_surv)
title('Winter Survival Day')

% Equinox Stuff
%In elciplse for 17.4 degrees, a = 2asin(c/(2*Re))
eq_op = [T_func(As,G_equ,Ir_equ,emis,absorb,theta_vec(1:x-8),0),T_func(As,G_equ,Ir_ecl,emis,absorb,zeros(1,17),0), ...
    T_func(As,G_equ,Ir_equ,emis,absorb,zeros(1,x-8),0),];%Hard coded angles for x = 180
eq_surv = [T_func_surv(As,G_equ,Ir_equ,emis,absorb,theta_vec(1:x-8),0),T_func_surv(As,G_equ,Ir_ecl,emis,absorb,zeros(1,17),0), ...
    T_func_surv(As,G_equ,Ir_equ,emis,absorb,zeros(1,x-8),0)]; %Hard coded angles for x = 180
figure(2)
subplot(2,1,1)
plot(theta_vec/15,eq_op)
title('Equinox Operational Day')

subplot(2,1,2)
plot(theta_vec/15,eq_surv)
title('Equinox Survival Day')



% Summer Stuff
eq_op = [T_func(As,G_sum,Ir_sum,emis,absorb,theta_vec(1:x+1),tilt), ...
    T_func(As,G_sum,Ir_sum,emis,absorb,zeros(1,x),tilt)];
eq_surv = [T_func_surv(As,G_sum,Ir_sum,emis,absorb,theta_vec(1:x+1),tilt), ...
    T_func_surv(As,G_sum,Ir_sum,emis,absorb,zeros(1,x),tilt)];
figure(3)
subplot(2,1,1)
plot(theta_vec/15,eq_op)
title('Summer Operational Day')

subplot(2,1,2)
plot(theta_vec/15,eq_surv)
title('Summer Survival Day')


% %Summer Operational
% figure(1)
% subplot(2,2,1)
% plot(T_op_vec,area_func(T_op_vec,G_sum,Ir_sum,emis,absorb,pi/2))
% title('Operational, Radiator Faces Sun')
% subplot(2,2,2)
% plot(T_op_vec,area_func(T_op_vec,G_sum,Ir_sum,emis,absorb,0))
% title('Operational, Radiator Faces Away')
% subplot(2,2,3)
% plot(T_surv_vec,area_func(T_surv_vec,G_sum,Ir_sum,emis,absorb,pi/2))
% title('Survival, Radiator Faces Sun')
% subplot(2,2,4)
% plot(T_surv_vec,area_func(T_surv_vec,G_sum,Ir_sum,emis,absorb,0))
% title('Survival, Radiator Faces Away')
% 
% %Winter Area Operational
% A_vec = linspace(0.01,1,1000);
% 
% figure(2)
% subplot(2,2,1)
% plot(A_vec,T_func(A_vec,G_win,Ir_win,emis,absorb,90))
% title('Winter, Radiator Faces Sun')
% yline(-40)
% yline(30)
% subplot(2,2,2)
% plot(A_vec,T_func(A_vec,G_win,Ir_win,emis,absorb,0))
% title('Winter, Radiator Faces Away')
% yline(-40)
% yline(30)
% subplot(2,2,3)
% %plot(A_vec,T_func(A_vec,G_win,Ir_win,emis,absorb,pi/2))
% plot(A_vec,T_func_surv(A_vec,G_win,Ir_ecl,emis,absorb,39.54))
% title('Eclipse, Radiator Faces Sun')
% yline(-40)
% yline(30)
% subplot(2,2,4)
% %plot(A_vec,T_func(A_vec,G_win,Ir_win,emis,absorb,0))
% plot(A_vec,T_func_surv(A_vec,G_win,Ir_ecl,emis,absorb,0))
% title('Eclipse, Radiator Faces Away')
% yline(-40)
% yline(30)
