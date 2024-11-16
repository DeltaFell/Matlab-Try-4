%Joan Matutes
%7/30/24
%Start of my own version of calculation.m
%required files: BladeVelocity.m, circle_integral.m, tec2mat.m, AOA.m,
%circleInt_whole_phase, circleInt_whole.m
addpath(genpath('Subfunctions')) %this allows me to tuck all the 
%subfunctions away and it's less messy

%insert loading stuff here later.
lambda = 1.1; % Tip speed ratio
Data = load('Data\CFD_confined_TSR_1_1.mat'); % Loading data
isphase = false;
Lambda = 11;
data_type = 'A'; 
old = true;

% addpath('Data')
% [zone1,VARlist1] = tec2mat('time_267.dat','debug');
% sz = size(VARlist1,2);
% fields = struct('names',{'X','Y','U','V'});
% % fields = struct('names',{'X','Y','U','V','Vort','Theta'});
% newData = struct();
% for i = 1:sz
%     newData.(fields(i).names) = zone1.data(i).data;
% end
% newData.Umag = hypot(newData.U,newData.V);
%placeholder for now
%%
if(old)
    flowdata = Data.flow_data;
X = flowdata(1).X;
Y = flowdata(1).Y;
%load('C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data\X_11P.mat')
%load('C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data\Y_11P.mat')
sz = size(flowdata,2);
theta = zeros(1,sz);
% U_field = struct;
% V_field = struct;
% Vorticity = struct;
for i = 1:length(flowdata)
    theta(i) = flowdata(i).theta;
    flowdata(i).u(isnan(flowdata(i).u)) = 0;
    flowdata(i).v(isnan(flowdata(i).v)) = 0;
    U_field(i).u = flowdata(i).u;
    V_field(i).v = flowdata(i).v;
    Vorticity(i).vort = flowdata(i).vort;
end
end
%%

%Definition of geometric constants
%I put all this in a struct to make things easier later, in terms of
%passing things into functions
GC = struct;
GC.cI_diameter = 1.6; %Diameter of the circle used to take the 
%integral over the velocity field
GC.chord = 0.0406; %chord length in m
GC.rt = 0.172/2; % Radius of the turbine in m
GC.rcc = GC.rt/GC.chord * 2 * 0.482;
%Distance from the turbine center to the the circle for integration 
%centered at R/D = 0.482
GC.cInt_grid_size = 0.01; % Size of each grid in the integration 
%circle. Defined in circle_integral.m
GC.Uinf = 0.91; % Free flow velocity in m/s
GC.Omega = lambda*GC.Uinf/(GC.rt); 
%Rotational speed in rad/s
GC.alphaP = 6; % Preset angle in degree
GC.blade_size = 1.2; % Size of blade shape contour
GC.diameterlist = [1.6 1.7 1.8 1.9 2];
%List of integration circle diameters
GC.lambda = lambda; %Tip speed ratio
GC.theta = theta;
if(old)
    GC.X = X;
    GC.Y = Y;
end

%%


if isphase == true
    [u_fluid,v_fluid,fluid_velocity_mag] = FluidVelocity(flowdata,GC,isphase);
else
    [u_fluid,v_fluid,fluid_velocity_mag,u_inter,v_inter] = FluidVelocity(flowdata,GC,isphase);
end

%Depending on if it's phase or not, we need different variables, so two
%different calls

blade_velocity = BladeVelocity(GC,theta);
relative_velocity = [u_fluid; v_fluid] - blade_velocity;
[aoa, nominal_aoa] = AOA(blade_velocity,relative_velocity,theta,GC);
%%
CircVals = struct; % create a structure to hold everything interesting
CircVals.params = GC;   
Vals = struct;
Vals.rel = zeros(1,length(theta));
Vals.aoa = zeros(1,length(theta));
Vals.uf = zeros(1,length(theta));
Vals.vf = zeros(1,length(theta));

for i = 1:length(GC.diameterlist)
    if isphase == true
        [u_fluid, v_fluid] = circleInt_whole_phase(GC.rcc,GC.diameterlist(i),flowdata);
    else
        [u_fluid, v_fluid] = circleInt_whole(GC.rcc,GC.diameterlist(i),theta,u_inter,v_inter);
    end
    Vals.uf = u_fluid;
    Vals.vf = v_fluid;
    u_fluid = u_fluid - blade_velocity(1,:);
    v_fluid = v_fluid - blade_velocity(2,:);
    Vals.rel = hypot(u_fluid,v_fluid);
    Vals.aoa = AOA(blade_velocity,[u_fluid; v_fluid],theta,GC);
    CircVals(i).Vals = Vals;
end

%CircVals.(GC.diameterlist(1));