function controlMoments = feedForwardControl(state,target,k)
%Takes in current state and target state, and konstants
%   Finds control moments based off of lateral quidance control

L =0;
M =0;
N =0;

%Define Variable/unroll inputs
k1x=k(1);
k2x=k(2);
k3x=k(6);
k1y=k(4);
k2y=k(5);
k3y=k(7);
k1z = k(3);

%target %(angle,rate,velocity)

dPhi = state(4)-target(1);
dTheta = state(5)-target(2);
dp = state(10)-target(4);
dq = state(11)-target(5);
dur = target(7);
dvr = target(8);
du = state(7);
dv = state(8);

%delta L = -k1*dp-k2dphi+k3(dvr-dv)

%dvr is target v dv is current v
L = (-k1x*dp)-(k2x*dPhi)+(k3x*(dvr-dv));

M = (-k1y*dq)-(k2y*dTheta)+(k3y*(dur-du));

N = state(12)*(-k1z);


controlMoments = [L;M;N];
end