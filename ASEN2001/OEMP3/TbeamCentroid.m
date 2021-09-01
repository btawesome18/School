function [outputArg1] = TbeamCentroid(w,wT,h,hT)
    outputArg1 = ((((w*wT)*(h+(wT/2)))+((h*hT)*(h/2)))/((w*wT)+(h*hT)));
end

