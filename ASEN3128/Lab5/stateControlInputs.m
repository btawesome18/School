function [aircraft_state_trim, control_surfaces_trim] = stateControlInputs(trim_variables,trim_definition)
    aircraft_state_trim = [0; 0; -trim_definition(2); 0; trim_variables(1); 0; trim_definition(1) * cos(trim_variables(1)); 0; trim_definition(1) * sin(trim_variables(1)); 0; 0; 0];
   
    control_surfaces_trim = [trim_variables(2); 0; 0; trim_variables(3)];
end