%Joan Matutes 7/25/24
%AA600
%Trying to identify how the data in Calculation Data has been obtained

load('Calculation Data\X_11P.mat')
load('CFD_confined_TSR_1_1.mat')
T = flow_data.X;
sum(T - X)
%from what this outputs, it looks like the 11P data corresponds to
%CFD_confined_TSR_1_1.mat
%%
load('Calculation Data\U_11P.mat')
T = flow_data.u;
U = U_phase.u;
sum(T - U)