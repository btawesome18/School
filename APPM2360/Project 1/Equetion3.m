function outputArg1 = Equetion3(state)
%Takes in a state vector and calculates the rate of change at that state

%% unpack state vector
    A = state{2};
    const = state{3};
    r = const(1);
    p = const(2);
%% Cacluate rate
    Aprime = (r*A)-(12*p);
    
    outputArg1 = Aprime;
end

