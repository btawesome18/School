function PlotAircraftSim(time, aircraft_state_array,control_input_array, col)


% Plots State Vecotor
figure(1);

subplot(3,1,1);
title('\fontsize{16}Position vs Time');
hold on;
plot(time,aircraft_state_array(:,1),col);

xlabel('time [s]');
ylabel('x [m]');

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,2),col);

xlabel('time [s]');
ylabel('y [m]');

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,3),col);

xlabel('time [s]');
ylabel('z [m]');

figure(2);




subplot(3,1,1);
title('\fontsize{16}Euler Angles vs Time');
hold on;
plot(time,aircraft_state_array(:,4)*(180)/pi,col);

xlabel('time [s]');
ylabel('roll [deg]');

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,5)*(180)/pi,col);

xlabel('time [s]');
ylabel('pitch [deg]');

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,6)*(180)/pi,col);

xlabel('time [s]');
ylabel('yaw [deg]');

figure(3);




subplot(3,1,1);
title('\fontsize{16}Velocity vs Time');
hold on;
plot(time,aircraft_state_array(:,7),col);

xlabel('time [s]');
ylabel('u [m/s]');

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,8),col);

xlabel('time [s]');
ylabel('v [m/s]');

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,9),col);

xlabel('time [s]');
ylabel('w [m/s]');

figure(4);




subplot(3,1,1);
title('\fontsize{16}Angular Velocity vs Time');
hold on;
plot(time,aircraft_state_array(:,10)*180/pi,col);

xlabel('time [s]');
ylabel('p [deg/s]');

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,11)*180/pi,col);

xlabel('time [s]');
ylabel('q [deg/s]');

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,12)*180/pi,col);

xlabel('time [s]');
ylabel('r [deg/s]');

figure(5);




subplot(4,1,1);
title('\fontsize{16}Control Input vs Time');
hold on;
plot(time,control_input_array(:,1),col);

title('Motor 1');
xlabel('time [s]');
ylabel('Force [n]');

subplot(4,1,2);
hold on;
plot(time,control_input_array(:,2),col);

title('Motor 2');
xlabel('time [s]');
ylabel('Force [n]');

subplot(4,1,3);
hold on;
plot(time,control_input_array(:,3),col);

title('Motor 3');
xlabel('time [s]');
ylabel('Force [n]');

subplot(4,1,4);
hold on;
plot(time,control_input_array(:,4),col);

title('Motor 4');
xlabel('time [s]');
ylabel('Force [n]');

%Position
figure(6);
%plot3(2,1,-3)
plot3(aircraft_state_array(:,2),aircraft_state_array(:,1),-aircraft_state_array(:,3),col);
hold on;
title("Trajectory")
xlabel('East [m]');
ylabel('North [m]');
zlabel('Up [m]');

end