function index = findCycleIndex(arry,numCycles)

    index = ones(numCycles+1,2);
    i = 1;
    
    for loop = 1:(numCycles+1)
    


        while ~arry(i)
            i = i + 1;
        end

        j= i;
        index(loop,1) = i;

        while arry(j)
            j = j + 1;
        end

        index(loop,2) = j;
        i = j+1;
        
    end

end