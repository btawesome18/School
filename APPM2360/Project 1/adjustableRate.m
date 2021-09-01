function outputArg1 = adjustableRate(state)
%Takes in a state vector and calculates the rate of change for adjustable at that state

    t = state{1};
    A = state{2};
    const = state{3};
    p = const(1);
    
    if t <= 5
        r = 0.03;
    else
        r = 0.03 + (0.015*sqrt(t-5));
    end
    
    Aprime = (r*A)-(12*p);
    
    outputArg1 = Aprime;
end

