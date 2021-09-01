t= linspace(0,15,100);
Kp = 2;
Ki = 0;

num = [0 Kp,Ki];
den = [1 0.5,Kp,Ki];
sys = tf(num, den);

lines = ones(100,1);

[b,t] = step(sys, t);
plot(t,b);
hold on;
plot(t,0.9*lines);
plot(t,1.1*lines);
title('Kp = 1 Ki = 0.1')

u = (1-b)*Kp;
figure();
plot(t,u);
title('U for Kp = 2 Ki = 0.1')