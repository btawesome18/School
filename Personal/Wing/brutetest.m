string = "Naca 2212 \n Oper Visc \n  200000 \n Mach 0.05 \n ITER 200 \n Pacc \n NACA2212Pol \n \n ASeq  -2 10 .5 \n";
location = "C:\Users\Brian\Documents\Classes\School\Personal\Wing";

cmd = sprintf('cd %s && xfoil.exe < %s > xfoil.out',location, string);
  [status,result] = system(cmd);
  