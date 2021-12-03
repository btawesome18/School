function PlotAircraftSim(time, aircraft_state_array,control_input_array, col)

set(0,'defaultAxesFontSize',18) 
set(groot,'defaultfigureposition',[100 150 900 850])


% Plots State Vecotor
figure(1);

pup = 2;
pdwn =-1;

subplot(3,1,1);
title('\fontsize{16}Position vs Time');
hold on;
plot(time,aircraft_state_array(:,1),col);

xlabel('time [s]');
ylabel('x [m]');
ylim([pdwn pup])

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,2),col);

xlabel('time [s]');
ylabel('y [m]');
ylim([pdwn pup])

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,3),col);

xlabel('time [s]');
ylabel('z [m]');
ylim([pdwn pup])

figure(2);


degup = 30;
degdown = -30;

subplot(3,1,1);
title('\fontsize{16}Euler Angles vs Time');
hold on;
plot(time,aircraft_state_array(:,4)*(180)/pi,col);

xlabel('time [s]');
ylabel('roll [deg]');
ylim([degdown degup])

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,5)*(180)/pi,col);

xlabel('time [s]');
ylabel('pitch [deg]');
ylim([degdown degup])

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,6)*(180)/pi,col);

xlabel('time [s]');
ylabel('yaw [deg]');
ylim([degdown degup])

figure(3);


vup = 2;
vdwn = -2;

subplot(3,1,1);
title('\fontsize{16}Velocity vs Time');
hold on;
plot(time,aircraft_state_array(:,7),col);

xlabel('time [s]');
ylabel('u [m/s]');
ylim([vdwn vup])

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,8),col);

xlabel('time [s]');
ylabel('v [m/s]');
ylim([vdwn vup])

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,9),col);

xlabel('time [s]');
ylabel('w [m/s]');
ylim([vdwn vup])

figure(4);


degup = 100;
degdown = -90;

subplot(3,1,1);
title('\fontsize{16}Angular Velocity vs Time');
hold on;
plot(time,aircraft_state_array(:,10)*180/pi,col);

xlabel('time [s]');
ylabel('p [deg/s]');
ylim([degdown degup])

subplot(3,1,2);
hold on;
plot(time,aircraft_state_array(:,11)*180/pi,col);

xlabel('time [s]');
ylabel('q [deg/s]');
ylim([degdown degup])

subplot(3,1,3);
hold on;
plot(time,aircraft_state_array(:,12)*180/pi,col);

xlabel('time [s]');
ylabel('r [deg/s]');
ylim([degdown degup])

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