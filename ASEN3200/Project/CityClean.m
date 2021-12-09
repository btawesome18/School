%Clean data of citys to be used in cpp

Re = 6378;

%Load citys in
citys = readtable("worldcities.csv");

%Allow for loading less citys if ':' is replaced with a number
citysOfWorthC = (citys(:,3:4));
citysOfWorth = zeros(height(citysOfWorthC),4);

%Convert city possitions to rad then to 3d cords.
for i = 1:height(citysOfWorthC)
    citysOfWorthX = citysOfWorthC{i,1}*(pi/180); %Reading in the csv needed lots of handeling and to be casted to double.
    citysOfWorthY = citysOfWorthC{i,2}*(pi/180);
    [Cx,Cy,Cz]=sph2cart(citysOfWorthY,citysOfWorthX,Re);
    citysOfWorth(i,:) = [Cx,Cy,Cz,(citys{i,10})];
end

citysOfWorth(isnan(citysOfWorth))=0;

writematrix(citysOfWorth,'AllCities.csv') ;