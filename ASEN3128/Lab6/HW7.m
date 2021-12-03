
recuv_tempest;


trim_definition = [21;1800];
[trim_variables, fval] = CalculateTrimVariables(trim_definition, aircraft_parameters);
[trim_state, trim_input]= TrimStateAndInput(trim_variables, trim_definition);
[Alon, Blon, Alat, Blat] = AircraftLinearModel2(trim_definition, trim_variables, aircraft_parameters);

[num_elev2pitch, den_elev2pitch] = ss2tf(Alon(1:4,1:4), Blon(1:4,1), [0 0 0 1],0);


rlocus( num_elev2pitch, den_elev2pitch ) 

