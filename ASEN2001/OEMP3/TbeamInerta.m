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

