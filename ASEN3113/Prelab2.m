

L = 0.127; %meters
H = 7.86071; %C/in
H = H*39.37; %Convert to C/m
%a = 48.19; %mm^2/s
a = 4.819e-5; %m^2/s
T0 = 7.94902; %C

t1 = 1;
x = 0.07;

for n = 1:10

    lambda = pi*((2*n)-1)/(2*L);

    if (mod(n,2)==0)
    bn = (2*H)/(L* ((lambda)^2) );
    else
    bn = -(2*H)/(L* ((lambda)^2) );
    end

    temp = bn*sin(lambda*x)*(exp( -(lambda^2) * a * t1 ));

    if n ~=1
        sum(n) = sum(n-1) + temp;
    end

end

u1 = T0 + (H*x) + sum;

t1 = 1000;

clear sum

for n = 1:10

    lambda = pi*((2*n)-1)/(2*L);

    if (mod(n,2)==0)
    bn = (2*H)/(L* ((lambda)^2) );
    else
    bn = -(2*H)/(L* ((lambda)^2) );
    end

    temp = bn*sin(lambda*x)*(exp( -(lambda^2) * a * t1 ));

    if n ~=1
        sum(n) = sum(n-1) + temp;
    end

end

u2 = T0 + (H*x) + sum;

plot(u1);
hold on
plot(u2);
title('Temp at point x =0.7 vs n');
xlabel('n number of sumations');
ylabel('Tempature in C');
legend('T = 1s' ,' T = 1000s')

figure();

%% Problem 6
x= L;
for i = 1:1000

    lambda = pi/(2*L);

    if (mod(1,2)==0)
    bn = (2*H)/(L* ((lambda)^2) );
    else
    bn = -(2*H)/(L* ((lambda)^2) );
    end

    ua(i) = T0 + (H*x) + bn*sin(lambda*x)*(exp( -(lambda^2) * a * i ));

end

for i = 1:1000

    a1 = a*1.1;

    lambda = pi/(2*L);

    if (mod(1,2)==0)
    bn = (2*H)/(L* ((lambda)^2) );
    else
    bn = -(2*H)/(L* ((lambda)^2) );
    end

    ub(i) = T0 + (H*x) + bn*sin(lambda*x)*(exp( -(lambda^2) * a1 * i ));

end

for i = 1:1000

    a1 = a*0.9;

    lambda = pi/(2*L);

    if (mod(1,2)==0)
    bn = (2*H)/(L* ((lambda)^2) );
    else
    bn = -(2*H)/(L* ((lambda)^2) );
    end

    uc(i) = T0 + (H*x) + bn*sin(lambda*x)*(exp( -(lambda^2) * a1 * i ));

end

hold on;
title('Temperature versus Time Curve');
plot(ua);

plot(ub);

plot(uc);
xlabel('Time [s]');
ylabel('Tempature in C');
legend('Base Diffusivity','110% Diffusivity','90% Diffusivity');