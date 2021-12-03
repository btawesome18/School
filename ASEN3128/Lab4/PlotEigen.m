function PlotEigen(k1,k2,k3span,k3n,I_x,g,S)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

k3 = linspace(k3span(1),k3span(2),k3n);
EigenValues = zeros(k3n,3);
for i = 1:length(k3)
    A = [0,g,0;0,0,1;-(k3(i)/I_x),-(k2/I_x),-(k1/I_x)];
    EigenValues(i,:) = eig(A);
end

realEig = real(EigenValues);
imagEig = imag(EigenValues);



plot(realEig(1:13,3)/S,imagEig(1:13,3)/S,'rx');
hold on
plot(realEig(1:13,2)/S,imagEig(1:13,2)/S,'rx');
hold on
plot(realEig(1:13,1)/S,imagEig(1:13,1)/S,'rx');
hold on
xline(0);
yline(0);
xline(-.8/S)


end

