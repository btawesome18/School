%4 part FEM by Nick Aichholz, and Brian Trybus

clc
clear all
close all


%Inchs for all below
L = 12;
w = 1;
h=(1/8);

rho = 0.0002505; %lb-sec^2/in^4
E = 10175000; %psi

Mt = (1.131*rho);
St = (0.5655*rho);
It = (23.124*rho);

Izz = (w*h^3)/12;
A = w*h;
cM4 = (rho * A * L)/806400;
cK4 = (8 * E * Izz)/L^3;



M4 = cM4 * [77088 2916*L 23712 -1284*L 0 0 0 0 0 0;...
        2916 * L 172 * L^2 1284 * L -73*L^2 0 0 0 0 0 0;...
        23712 1284*L 154176 0 23712 -1284*L 0 0 0 0;...
        -1284*L -73*L^2 0 344*L^2 1284*L -73*L^2 0 0 0 0;...
        0 0 23712 1284*L 154176  0 23712 -1284*L 0 0;...
        0 0 -1284*L -73*L^2 0 344*L^2 1284*L -73*L^2 0 0;...
        0 0 0 0 23712 1284*L 154176 0 23712 -1284*L;...
        0 0 0 0 -1284*L -73*L^2 0 344*L^2 1284*L -73*L^2;...
        0 0 0 0 0 0 23712 1284*L 77088 -2916*L;...
        0 0 0 0 0 0 -1284*L -73*L^2 -2916*L 172*L^2];
        
    
M4part2 = [0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 0 0;...
        0 0 0 0 0 0 0 0 Mt St;...
        0 0 0 0 0 0 0 0 St It];
    
K4 = cK4 * [96 12*L -96 12*L 0 0 0 0 0 0;...
        12*L 2*L^2 -12*L L^2 0 0 0 0 0 0;...
        -96 -12*L 192 0 -96 12*L 0 0 0 0;...
        12*L L^2 0 4*L^2 -12*L L^2 0 0 0 0;...
        0 0 -96 -12*L 192 0 -96 12*L 0 0;...
        0 0 12*L L^2 0 4*L^2 -12*L L^2 0 0;...
        0 0 0 0 -96 -12*L 192 0 -96 12*L;...
        0 0 0 0 12*L L^2 0 4*L^2 -12*L L^2;...
        0 0 0 0 0 0 -96 -12*L 96 -12*L;...
        0 0 0 0 0 0 12*L L^2 -12*L 2*L^2];
    
    
% X4 = K4-(M4+M4part2);

[freqA,freqB] = eig(K4(3:10,3:10),(M4(3:10,3:10)+M4part2(3:10,3:10)));

freqN = sqrt(freqB)./(2*pi);
fprintf('Mode 1: %f, Mode 2: %f, Mode 3: %f',freqN(1,1),freqN(2,2),freqN(3,3));
% e = sqrt(eig(X4(3:10,3:10)));
% f = e/(2*pi);
%% Make plots
ev =  [0;0;freqA(:,1)];
ploteigenvector(L,ev,4,50,1)
title(['Mode 1: ',num2str(freqN(1,1)), ' (Hz)'])
xlabel('Length (in)')
ylabel('Exaggerated Y displacment');
ev =  [0;0;freqA(:,2)];
ploteigenvector(L,ev,4,50,1)
title(['Mode 2: ',num2str(freqN(2,2)), ' (Hz)'])
xlabel('Length (in)')
ylabel('Exaggerated Y displacment');
ev =  [0;0;freqA(:,3)];
ploteigenvector(L,ev,4,50,1)
title(['Mode 3: ',num2str(freqN(3,3)), ' (Hz)'])
xlabel('Length (in)')
ylabel('Exaggerated Y displacment');

function ploteigenvector(L,ev,ne,nsub,scale)
% declare local variables here if required by language
nv=ne*nsub+1; Le=L/ne; dx=Le/nsub; k=1;
x=zeros(nv);
v=zeros(nv); % declare and set to zero plot arrays
for e=1:ne  % loop over elements
    xi=Le*(e-1); vi=ev(2*e-1); qi=ev(2*e); vj=ev(2*e+1); qj=ev(2*e+2);
    for n=1:nsub % loop over subdivisions
        xk=xi+dx*n; 
        pos=(2*n-nsub)/nsub; % isoP coordinate
        vk=scale*(0.125*(4*(vi+vj)+2*(vi-vj)*(pos^2-3)*pos+Le*(pos^2-1)*...
            (qj-qi+(qi+qj)*pos))); % Hermitian interpolant
        k = k+1; 
        x(k)=xk; 
        v(k)=vk; % build plot functions
    end  % end n loop
end % end e loop
% plot v (vertical) vs x (horizontal) -- language dependent
figure
plot(x,v)
end
