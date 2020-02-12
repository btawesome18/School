location = 'C:\Users\Brian\Documents\Classes\School\Personal\Wing'
Foil = 'NACA1110';
% AoA = '0';
% numNodes = '160';
% SaveFile = 'Save.txt';
% SaveCP = 'SaveCP.txt';
% testString = 'Naca 2210 /n Re 200000 /n mach .044 /n,ITER 200 /n ASeq -2 10 .5';
%'Naca NacaNum /n, Re RendNum /n mach machNum /n,ITER maxIts, /n ASeq min
%max incriment

Naca = '0000';
outname = "NACA" +Naca+ "Pol";
Numtemp = '00';
Renold = '200000';
Mach = '0.05';
MaxIt = '200';
minAoA = '-2';
maxAoA = '10';
incAoA = '.5';

for(C = 0:9)
    for(P = 0:9)
        for(T = 1:40)
            
            if (T >= 10)
                Naca(1) = int2str(C)
                Naca(2) = int2str(P)
                Numtemp = int2str(T)
                Naca(3) = Numtemp(1)
                Naca(4) = Numtemp(2)
                
            else
                Naca(1) = int2str(C)
                Naca(2) = int2str(P)
                Naca(3) = "0"
                Naca(4) = int2str(T)
                
            end
            if isfile('xfoilInput.txt')
                delete 'xfoilInput.txt';
            end
            outname = "NACA" +Naca+ "Pol";
            if isfile(outname)
                delete (outname);
            end
            
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
        end
    end
end