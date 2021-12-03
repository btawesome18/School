function dsdt = EOMQuad(t,state,constants)
    %Takes in the state of the aircraft and constants about the craft to
    %simulate motion.
    dsdt = zeros(12,1);
    dsdt(1:3,1)= BodytoInertial(state(4),state(5),state(6))*state(7:9);
    
    tempmatrix = [1,(sin(state(4))*tan(state(5))),(cos(state(4))*tan(state(5)));0,(cos(state(4))),(-sin(state(4)));0,(sin(state(4))*sec(state(5))),(cos(state(4))*sec(state(5)))];
    
    dsdt(4:6,1)= tempmatrix*state(10:12);
    
    vec1 = [((state(12)*state(8))-(state(11)*state(9)));((state(10)*state(9))-(state(12)*state(7)));((state(11)*state(7))-(state(10)*state(8)))];
    vec2 = constants(13)*[(-sin(state(5)));(cos(state(5))*sin(state(4)));(cos(state(5))*cos(state(4)))];
    f_aero = -constants(7)*(norm(([state(7);state(8);state(9)])))*([state(7);state(8);state(9)]);
    vec3 = (1/constants(1))*f_aero;
    vec4 = (1/constants(1))*([0;0;-(constants(11)+constants(10)+constants(9)+constants(12))]);
    
    dsdt(7:9,1) = vec1+vec2+vec3+vec4;
    
    %constants = [m;r;k_m;4 I_x;I_y;I_z;nu;mu;f1;f2;f3;f4;g];
    v1 = [(((constants(5)-constants(6))/constants(4))*(state(11)*state(12)));(((constants(6)-constants(4))/constants(5))*(state(10)*state(12)));(((constants(4)-constants(5))/constants(6))*(state(10)*state(11)))];
    m_aero = -constants(8)*(norm(state(10:12)))*(state(10:12));
    v2 = m_aero./constants(4:6);
    m_cntl = [(constants(2)/sqrt(2))*(-constants(9)-constants(10)+constants(11)+constants(12));(constants(2)/sqrt(2))*(constants(9)-constants(10)-constants(11)+constants(12));(constants(3))*(constants(9)-constants(10)+constants(11)-constants(12))];
    v3 = m_cntl./constants(4:6);
    dsdt(10:12,1) = v1+v2+v3;
    
    
end
