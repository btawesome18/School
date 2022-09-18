
for i = 1:8
    T = int2bit(i,3);
    A = T(1);
    F = T(2);
    O = T(3);
    Out(i,1:4) = [A,F,O,alarmBool(A,F,O)];
end

A = Out(:,1);
F = Out(:,2);
O = Out(:,3);
S = Out(:,4);
D = table(A,F,O,S)

function S = alarmBool(A,F,O)

S = (~A&F) | A&(O|F);

end