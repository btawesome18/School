%Plot the Real Data

load('RSdata_13_50.mat')

state = rt_estim.signals.values;

motor = rt_motor.signals.values;

PlotAircraftSim(rt_estim.time,state,motor,'-b');

figure(6)
xlim([-1.5,1.5])
ylim([-1.5,1.5])
zlim([0,1.5])
grid on

% for i = 1:6
%    name = "F"+i+"Real.png";
%    saveas(figure(i),name); 
% end