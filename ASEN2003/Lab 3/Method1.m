function [W] = Method1(M,M0,B,angle,r,I,g)
    
    Num = 2*(M+M0)*(sind(B)*angle)*r*g;
    Dom = (((M+M0)*(r^2))+I);
    
    W = sqrt(Num/Dom);
    
    
end

