%Code by Brian Trybus for ploting varied FEM data 3112 lab 2 10/31/2021

node2Coords = readtable('Node - Coords list.txt');
CP=      3.750;
%% Import all data, data was hand formated to allow readmatrix
NodeSolutionsIdeal = readmatrix('Nodal solution per node.txt');
NodeSolutionsFriction = readmatrix('Nodal solution per node (Friction at supported joints).txt');
NodeSolutionsImperfectNode = readmatrix('Nodal solution per node (Imperfect node).txt');
NodeSolutionsExMod1 = readmatrix('Nodal solution per node (Modified E_x).txt');
NodeSolutionsExMod2 = readmatrix('Nodal solution per node (Modified E_x in element 103).txt');
NodeSolutionsTor = readmatrix('Nodal solution per node (Torsion allowed).txt');

%% Plot one section of the truss with all variations
figure(1);
hold on
coff = 4.75*(10^5);

NodeSolutionsIdeal(:,2:5) = coff *NodeSolutionsIdeal(:,2:5);
NodeSolutionsFriction(:,2:5) = coff *NodeSolutionsFriction(:,2:5);
NodeSolutionsImperfectNode(:,2:5) = coff *NodeSolutionsImperfectNode(:,2:5);
NodeSolutionsExMod1(:,2:5) = coff *NodeSolutionsExMod1(:,2:5);
NodeSolutionsExMod2(:,2:5) = coff *NodeSolutionsExMod2(:,2:5);
NodeSolutionsTor(:,2:5) = coff*NodeSolutionsTor(:,2:5);


plot(NodeSolutionsIdeal(1:17,3));

plot(NodeSolutionsFriction(1:17,3));

plot(NodeSolutionsImperfectNode(1:17,3));

plot(NodeSolutionsExMod1(1:17,3));

plot(NodeSolutionsExMod2(1:17,3));

plot(NodeSolutionsTor(1:17,3));

legend('Ideal','Friction','Imperfect Nodes','Modified Ex','In-line load cell free play','Torsion') 
title('Displacement in Y vs Nodes with Varied FEM Peramiters');
xlabel('Node Number (Along Bottom Right of Truss)');
ylabel('Displacment(m)');

%Plot diffreance from ideal
figure(2)
hold on
plot((10^9)*(NodeSolutionsFriction(1:17,3)-NodeSolutionsIdeal(1:17,3)));

plot((10^9)*(NodeSolutionsImperfectNode(1:17,3)-NodeSolutionsIdeal(1:17,3)));

plot((10^9)*(NodeSolutionsExMod1(1:17,3)-NodeSolutionsIdeal(1:17,3)));

plot((10^9)*(NodeSolutionsExMod2(1:17,3)-NodeSolutionsIdeal(1:17,3)));

plot((10^9)*(NodeSolutionsTor(1:17,3)-NodeSolutionsIdeal(1:17,3)));

legend('Friction','Imperfect Nodes','Modified Ex 1','Modified Ex 2','Torsion') 
title('Diffrence from Idealized Displacemnt in Y vs Nodes with Varied FEM Peramiters');
xlabel('Node Number (Along Bottom Right of Truss)');
ylabel('Displacment(nm)');

%% Calculate Deviation from Ideal model

%Multiplyer of how much more the displacemnt is then the Ideal model in z

MultFricZ = NodeSolutionsFriction(2:16,3)./NodeSolutionsIdeal(2:16,3);

MultImperfectZ = NodeSolutionsImperfectNode(2:16,3)./NodeSolutionsIdeal(2:16,3);

MultE1Z = NodeSolutionsExMod1(2:16,3)./NodeSolutionsIdeal(2:16,3);

MultE2Z = NodeSolutionsExMod2(2:16,3)./NodeSolutionsIdeal(2:16,3);

MultTorZ = NodeSolutionsTor(2:16,3)./NodeSolutionsIdeal(2:16,3);

%Now calculate Standard Devation

STDFricZ = std(MultFricZ);

STDImperfectZ = std(MultImperfectZ);

STDE1Z = std(MultE1Z);

STDE2Z = std(MultE2Z);

STDTorZ = std(MultTorZ);

% Now do the same for total displacemnt

MultFric = NodeSolutionsFriction(2:16,5)./NodeSolutionsIdeal(2:16,5);

MultImperfect = NodeSolutionsImperfectNode(2:16,5)./NodeSolutionsIdeal(2:16,5);

MultE1 = NodeSolutionsExMod1(2:16,5)./NodeSolutionsIdeal(2:16,5);

MultE2 = NodeSolutionsExMod2(2:16,5)./NodeSolutionsIdeal(2:16,5);

MultTor = NodeSolutionsTor(2:16,5)./NodeSolutionsIdeal(2:16,5);
%Now calculate Standard Devation

STDFric = std(MultFric);

STDImperfect = std(MultImperfect);

STDE1 = std(MultE1);

STDE2 = std(MultE2);

STDTor = std(MultTor);
