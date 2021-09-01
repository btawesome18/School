function [outputArg1] = momnetMax(W,L,density,area)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %x = -L*((area*density*2)- W)/W; %find x val where m is greats
    %outputArg1 = ((W/(6*L))*((L-x)^3))-((area*density/2)*((L-x)^2));% try brute force
    x =0:0.1:L;
    moment = (((L-x).^2)).*(((W.*(L-x))./(6*L))-(density*area/2));
    maxX = max(moment);
    outputArg1 = maxX;
end

