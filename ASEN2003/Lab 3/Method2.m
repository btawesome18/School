function [W] = Method2(M,M0,B,anglet,r,I,g,moment)


    h = sind(B)*r*anglet;
 
    Num = 2*(M+M0)*((g*h))+(2*moment*anglet);
    Dom = (((M+M0)*(r^2))+I);
    
    W = sqrt(Num/Dom);
    

end

