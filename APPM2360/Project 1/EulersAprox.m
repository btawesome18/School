function output = EulersAprox(dydx,input,h,endx)
%Takes a function in, uses Eulars method to aproximate it with h as the
%step size, and input as inital condistion
    y = input{2};
    x = input{1};
    const = input{3}; %pass any constants in there own cell for the function to unpack
    output = [x,y];%start a matrix with x0 and y0
    for i = (x+h):h:endx
        input = {i,y,const}; %Construct input for dy/dx
        y = y+(h*dydx(input)); % core of Eulars
        
        iter = [i,y];
        output = [output;iter];%append latest value to end of matix
    end

end

