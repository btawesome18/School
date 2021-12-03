function matrix = BodytoInertial(phi,theta,psi)



    m1 = [1,0,0;0,cos(phi),sin(phi);0,-sin(phi),cos(phi)];
    m2 = [cos(theta),0,-sin(theta);0,1,0;sin(theta),0,cos(theta)];
    m3 = [cos(psi),sin(psi),0;-sin(psi),cos(psi),0;0,0,1];
    
    matrix = (m1*m2*m3)';
end