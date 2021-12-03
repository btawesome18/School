function PlotAircraftSim(time, aircraft_state_array, control_input_array, col)


% Plots State Vecotor
figure(1);

tplot1 = tiledlayout(3,1);
title(tplot1,'\fontsize{16}Position vs Time');

nexttile();
plot(time,aircraft_state_array(:,1),col);
xlabel('time [s]');
ylabel('x [m]');

nexttile();
plot(time,aircraft_state_array(:,2),col);
xlabel('time [s]');
ylabel('y [m]');

nexttile();
plot(time,aircraft_state_array(:,3),col);
xlabel('time [s]');
ylabel('z [m]');

figure(2);

tplot2 = tiledlayout(3,1);
title(tplot2,'\fontsize{16}Euler Angles vs Time');

nexttile();
plot(time,aircraft_state_array(:,4)*(180)/pi,col);
xlabel('time [s]');
ylabel('roll [deg]');

nexttile();
plot(time,aircraft_state_array(:,5)*(180)/pi,col);
xlabel('time [s]');
ylabel('pitch [deg]');

nexttile();
plot(time,aircraft_state_array(:,6)*(180)/pi,col);
xlabel('time [s]');
ylabel('yaw [deg]');

figure(3);

tplot3 = tiledlayout(3,1);
title(tplot3,'\fontsize{16}Velocity vs Time');

nexttile();
plot(time,aircraft_state_array(:,7),col);
xlabel('time [s]');
ylabel('u [m/s]');

nexttile();
plot(time,aircraft_state_array(:,8),col);
xlabel('time [s]');
ylabel('v [m/s]');

nexttile();
plot(time,aircraft_state_array(:,9),col);
xlabel('time [s]');
ylabel('w [m/s]');

figure(4);

tplot4 = tiledlayout(3,1);
title(tplot4,'\fontsize{16}Angular Velocity vs Time');

nexttile();
plot(time,aircraft_state_array(:,10)*180/pi,col);
xlabel('time [s]');
ylabel('p [deg/s]');

nexttile();
plot(time,aircraft_state_array(:,11)*180/pi,col);
xlabel('time [s]');
ylabel('q [deg/s]');

nexttile();
plot(time,aircraft_state_array(:,12)*180/pi,col);
xlabel('time [s]');
ylabel('r [deg/s]');

% Plot Controls 

figure(5);

tplot5 = tiledlayout(4,1);
title(tplot5,'\fontsize{16}Control Inputs vs Time');

nexttile();
plot(time,control_input_array(:,1),col);
title('Motor 1');
xlabel('time [s]');
ylabel('Force [newtons]');

nexttile();
plot(time,control_input_array(:,2),col);
title('Motor 2');
xlabel('time [s]');
ylabel('Force [newtons]');

nexttile();
plot(time,control_input_array(:,3),col);
title('Motor 3');
xlabel('time [s]');
ylabel('Force [newtons]');

nexttile();
plot(time,control_input_array(:,4),col);
title('Motor 4');
xlabel('time [s]');
ylabel('Force [newtons]');

end
