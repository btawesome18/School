location = 'C:\Users\Brian\Documents\Classes\School\Personal\Wing'
Foil = 'NACA1110';
% AoA = '0';
% numNodes = '160';
% SaveFile = 'Save.txt';
% SaveCP = 'SaveCP.txt';
% testString = 'Naca 2210 /n Re 200000 /n mach .044 /n,ITER 200 /n ASeq -2 10 .5';
%'Naca NacaNum /n, Re RendNum /n mach machNum /n,ITER maxIts, /n ASeq min
%max incriment
Naca = '2212';
Renold = '200000';
Mach = '0.05';
MaxIt = '200';
minAoA = '-2';
maxAoA = '10';
incAoA = '.5';

fid = fopen('xfoilInput.txt','w');
fprintf(fid,['PLOP \n']);
fprintf(fid,['G \n']);
fprintf(fid,['\n']);
fprintf(fid,['Naca ',Naca,'\n']);
fprintf(fid,['Oper \n']);
fprintf(fid,['Visc \n']);
fprintf(fid,[Renold,'\n']);
fprintf(fid,['Mach ',Mach,'\n']);
fprintf(fid,['ITER ',MaxIt,'\n']);
fprintf(fid,['Pacc \n']);
fprintf(fid,['NACA',Naca,'Pol','\n\n']);
fprintf(fid,['ASeq  ',minAoA, ' ', maxAoA ,' ', incAoA ,'\n']);
fclose(fid);





cmd = sprintf('cd %s && xfoil.exe < xfoilInput.txt > xfoil.out',location);
  [status,result] = system(cmd);