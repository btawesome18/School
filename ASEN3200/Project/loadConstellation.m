function [num_launches, num_spacecraft, satellite_list] = loadConstellation(filename)
%DESCRIPTOIN: Ingests constellation description .json file and parses it
%into a list of structs with full initial orbit elements (km, s, rad) and
%satellite name.
%
%INPUTS:
% filename      A string indicating the name of the .json file to be parsed
%
%OUTPUTS:
% nl            Number of total launches
% ns            Total number of spacecraft between all launches
% satlist       Array of structs with 'name' and 'oe0' properties


%Temporary - just so the function runs the first time you use it.
%You'll need to change all of these!
num_launches = 0;
num_spacecraft = 0;
satellite_list.name = '';
satellite_list.oe0 = NaN(6,1);

%1) extract the constellation structure from the json file

fid = fopen(filename); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
data = jsondecode(str); % Using the jsondecode function to parse JSON from string

%2) read all of the launches and payloads to understand how many launches
% and spacecraft are in the constellation; note, this will be useful in
% Part 2!
num_launches=length(data.launches);
for i = 1:num_launches
    orbit(1) = data.launches(i).orbit.a;
    orbit(2) = data.launches(i).orbit.e;
    orbit(3) = data.launches(i).orbit.i;
    orbit(4) = data.launches(i).orbit.Om;
    orbit(5) = data.launches(i).orbit.om;
   for j = 1:length(data.launches(i).payload)
    num_spacecraft = num_spacecraft + 1; %Add this craft to the counter
    satellite_list(num_spacecraft).name = data.launches(i).payload(j).name;
    satellite_list(num_spacecraft).oe0(1:5) = orbit;
    satellite_list(num_spacecraft).oe0(6) = data.launches(i).payload(j).f;
   end
end
%3) RECOMMENDED: Pre-allocate the satellite_list struct


%4) Populate each entry in the satellite struct list with its name and
%initial orbit elements [a,e,i,Om,om,f] at time t0


