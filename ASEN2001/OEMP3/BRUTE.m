%inputs



%outputs



%objective maximiz i/y

%Knowns
Names = ["Aluminum", "Steel", "Nickel", "Stainless", "Titanium"];
E = [9.9*10^3,29*10^3,30*10^3,28.5*10^3,16.9*10^3];
%tensileU = [42,90,80,140,130];
tensileY = [35,70,35,115,120];
shearS = [27,54,51,81,80];
density = [.098,.283,.304,.284,.16];
stress = [27,54,51,81,80];
matcost = [8.03,8.07,53.78,29.63,115.36];
%Given Min thick is 1/4in 
W = 2001/12;
L = 27.25*12;
IterMax = 30;
%% Eqations
%sigma = -m*y/I, y is distance from centroid

%rodArea(r);
%rodI(r);
%rodCentroid(r);
%momnetMax(w,l,denisty,area);

%% Rod stock
Area = 0;
Inerta = 0;
Centroid = 0;
Density = 0;
Momenet = 0;
sigYeild = 0;
sigDesign = 0;
sigMax = 0;
maxArea = 1000;
rOpt = 0;
% for t = 1:5
%     Density = density(t);
%     sigYeild = (tensileY(t)/1.5)*1000;
%     for r = linspace(0.25,6,IterMax) %inches from 1/4 to 6
%         Area = rodArea(r);
%         Inerta = rodI(r);
%         Centroid = rodCentroid(r);
%         Momenet = momnetMax(W,L,Density,Area);
%         sigDesign = (Momenet*Centroid)/Inerta;
%         if (sigYeild >= sigDesign)&&(Area <= maxArea)
%             rOpt = r;
%             maxArea = Area;
%         end
%     end
%     sigMax = 0;
%     maxArea = 1000;
%     rMetRod(t)= rOpt;
%     rOpt=0;
% end

%% T beam
w = 0;
wT = 0;
h = 0;
hT =0;

for t = 1:5
    Density = density(t);
    sigYeild = (tensileY(t)/1.5)*1000;
    Names(t)
    for width = linspace(0.25,12,IterMax) %inches from 1/4 to 12
        for widthThic = linspace(.25,12,IterMax)
            for hight = linspace(0,(12-widthThic),IterMax)
                for hightThic = linspace(0.25,12,IterMax)
                    Area = TbeamArea(width,widthThic,hight,hightThic);
                    Inerta = TbeamInerta(width,widthThic,hight,hightThic);
                    Centroid = TbeamCentroid(width,widthThic,hight,hightThic);
                    Momenet = momnetMax(W,L,Density,Area);
                    sigDesign = (Momenet*Centroid)/Inerta;

                    
                    if (sigYeild >= sigDesign)&&(((shearS(t)/1.5)*1000)>=TransStress)&&(Area <= maxArea)
                        w = width;
                        wT = widthThic;
                        h = hight;
                        hT = hightThic;
                        maxArea = Area;
                    end
                end
            end
         end
    end
    sigDesign = 0;
    maxArea = 1000;
    TMetRod(t)= {[w,wT,h,hT]};
    w = 0;
    wT = 0;
    h = 0;
    hT =0;
end
    %% Cost
    for t = 1:5
       c = TMetRod{t};
       width = c(1);
       widthThic = c(2);
       hight= c(3);
       hightThic = c(4);
       Area = TbeamArea(width,widthThic,hight,hightThic);
       Inerta = TbeamInerta(width,widthThic,hight,hightThic);
       Centroid = TbeamCentroid(width,widthThic,hight,hightThic);
       Momenet = momnetMax(W,L,density(t),Area);
       sigDesign = (Momenet*Centroid)/Inerta;
       Vmax = (W*L*0.5)-(Area*Density*L);
       q = (Centroid-widthThic)*(width*widthThic);
       Thick = (width*(width<=hightThic))+(hightThic*((width>hightThic)));
       TransStress = (Vmax*q)/(Inerta*Thick);
       saftey(t) = (tensileY(t)*1000)/sigDesign;
       cost(t) = (Area * L * density(t)*matcost(t))
       safteyShear(t) = (shearS(t)*1000)/TransStress;
       
    end
      c = TMetRod{4};
       Area = TbeamArea(c(1),c(2),c(3),c(4));

    
    
function [outputArg1] = TbeamArea(width, widthT, hight, hightT)
    outputArg1 = (width*widthT)+(hight*hightT);
end

function [outputArg1] = TbeamCentroid(w,wT,h,hT)
    outputArg1 = ((((w*wT)*(h+(wT/2)))+((h*hT)*(h/2)))/((w*wT)+(h*hT)));
end

function [outputArg1] = TbeamInerta(w,wT,h,hT)
%w = flange width
%wT = flange thickness
%h = hight of main member
%hT = thickness of main member
    I1 = ((w*(wT^3))/12);
    I2 = ((hT*(h^3))/12);
    y = TbeamCentroid(w,wT,h,hT);
    y1 = y-(h+(wT/2));
    y2 = y-((h/2));
    outputArg1 = (I1+((w*wT)*(y1^2)))+(I2+((h*hT)*(y2^2)));
end