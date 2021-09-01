function dis = distance(pos1,pos2)
%Find distance between 2 points in 3d space
    x1=pos1(1);
    y1=pos1(2);
    z1=pos1(3);
    x2=pos2(1);
    y2=pos2(2);
    z2=pos2(3);
    dis = sqrt(((x1-x2)^2)+((y1-y2)^2)+((z1-z2)^2));
end

