clear all; close all; clc;
%cd 'G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research'
%data_folder = 'G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
Pathsetter

prompt = "Which type would you like? enter 1 for 1.1 Averaged, 2 for 1.1 Phase, 3 for 1.9 Averaged, 4 for 1.9 Phase, 5 for Intra";
response = input(prompt);

%% 1.1 Averaged
if(response == 1)
    lambda = 1.1; % Tip speed ratio
    Data = load('CFD_confined_TSR_1_1.mat'); % Loading data
    isphase = false;
    Lambda = 11;
    data_type = 'A';
end

%% 1.1 Phase
if(response==2)
    lambda = 1.1; % Tip speed ratio
    Data = load('CFD_confined_TSR_1_1.mat'); % Loading data
    isphase = true;
    Lambda = 11;
    data_type = 'P';
end

%% 1.9 Averaged
if(response == 3)
    lambda = 1.9; % Tip speed ratio
    Data = load('CFD_confined_LES_TSR_1_9.mat');% Loading data
    isphase = false;
    Lambda = 19;
    data_type = 'A';
end

%% 1.9 Phase
if(response == 4)
    lambda = 1.9; % Tip speed ratio
    Data = load('CFD_confined_LES_TSR_1_9.mat');% Loading data
    isphase = true;
    Lambda = 19;
    data_type = 'P';
end

%% Intra
if(response == 5)
    lambda = 1.9; % Tip speed ratio
    Data = load('LES_confined_Intra.mat');% Loading data
    isphase = true;
    Lambda = 19;
    data_type = 'I';
end

%% Data processing
% Initial process
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

save(fullfile(data_folder,['U_field_' num2str(Lambda) data_type]),'U_field')
save(fullfile(data_folder,['V_field_' num2str(Lambda) data_type]),'V_field')
save(fullfile(data_folder,['Vorticity_' num2str(Lambda) data_type]),'Vorticity')
save(fullfile(data_folder,['lambda_' num2str(Lambda) data_type]),'lambda')
save(fullfile(data_folder,['theta_' num2str(Lambda) data_type]),'theta')
save(fullfile(data_folder,['X_' num2str(Lambda) data_type]),'X')
save(fullfile(data_folder,['Y_' num2str(Lambda) data_type]),'Y')
%%
% Geometric constants 
circleInt_diameter = 1.6; % Diameter of the circle used to take the integral over the velocity field
chord = 0.0406; % Chord length in m
r_turbine = 0.172/2; % Radius of the turbine in m
r_circle_center = r_turbine/chord * 2 * 0.482 ; % Distance from the turbine center to the the circle for integration centered at R/D = 0.482
circleInt_grid_size = 0.01; % Size of each grid in the integration circle. Defined in circle_integral.m
Uinf = 0.91; % Free flow velocity in m/s
Omega = lambda*Uinf/(r_turbine); % Rotational speed in rad/s
alphaP = 6; % Preset angle in degree
blade_size = 1.2; % Size of blade shape contour
diameterlist = [1.6 1.7 1.8 1.9 2];  % List of integration circle diameters

% load(['C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\SW data\SD_U_field_' num2str(Lambda) 'P.mat'])
% load(['C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\SW data\SD_V_field_' num2str(Lambda) 'P.mat'])
% for i = 1:length(theta)
%     flowdata(i).u = SD_U_field(i).u;
%     flowdata(i).v = SD_V_field(i).v;
%     flowdata(i).X = X;
%     flowdata(i).Y = Y;
% end
% Find Velocity Field
if isphase == true
    for i = 1:length(theta)
       U_phase(i).u = flowdata(i).u;
       V_phase(i).v = flowdata(i).v;
    end
    
    [u_fluid, v_fluid] = circleInt_whole_phase(r_circle_center,circleInt_diameter,flowdata); % Componets of flow velocity
    fluid_velocity = [u_fluid;v_fluid];
    fluid_velocity_mag = hypot(u_fluid,v_fluid);
    save(fullfile(data_folder,['fluid_velocity_DD' num2str(Lambda) data_type]),'fluid_velocity')
    save(fullfile(data_folder,['fluid_velocity_mag_DD' num2str(Lambda) data_type]),'fluid_velocity_mag')
     save(fullfile(data_folder,['U_' num2str(Lambda) data_type]),'U_phase')
     save(fullfile(data_folder,['V_' num2str(Lambda) data_type]),'V_phase')
else
    [Uavg Vavg] = avg_velocityfield(flowdata);
    u_inter = griddedInterpolant(X,Y,Uavg);
    v_inter = griddedInterpolant(X,Y,Vavg);
    [u_fluid, v_fluid] = circleInt_whole(r_circle_center,circleInt_diameter,theta,u_inter,v_inter); % Componets of flow velocity
    
    save(fullfile(data_folder,['U_' num2str(Lambda) data_type]),'Uavg')
    save(fullfile(data_folder,['V_' num2str(Lambda) data_type]),'Vavg')
end

% Blade & relative velocity
fluid_velocity = [u_fluid; v_fluid];
blade_velocity = [Omega*r_turbine .* -cosd(theta); Omega*r_turbine .* -sind(theta)];
relative_velocity = [u_fluid; v_fluid] - blade_velocity;

save(fullfile(data_folder,['fluid_velocity_' num2str(Lambda) data_type]),'fluid_velocity')
save(fullfile(data_folder,['blade_velocity_' num2str(Lambda) data_type]),'blade_velocity')
save(fullfile(data_folder,['relative_velocity_' num2str(Lambda) data_type]),'relative_velocity')

% Find AOA
[aoa, nominal_aoa] = AOA(blade_velocity,relative_velocity,theta,lambda,alphaP);

save(fullfile(data_folder,['aoa_' num2str(Lambda) data_type]),'aoa')
save(fullfile(data_folder,['nominal_aoa_' num2str(Lambda) data_type]),'nominal_aoa')
%%
% Relative velocity of different integration circle
diff_dia_rel = zeros(length(diameterlist),length(theta));
diff_dia_aoa = zeros(length(diameterlist),length(theta));
diff_dia_ufluid = zeros(length(diameterlist),length(theta));
diff_dia_vfluid = zeros(length(diameterlist),length(theta));
for  i = 1:length(diameterlist)
    if isphase == true
        [u_fluid, v_fluid] = circleInt_whole_phase(r_circle_center,diameterlist(i),flowdata);
    else
        [u_fluid, v_fluid] = circleInt_whole(r_circle_center,diameterlist(i),theta,u_inter,v_inter);
    end
    diff_dia_ufluid(i,:) = u_fluid;
    diff_dia_vfluid(i,:) = v_fluid;
    u_fluid = u_fluid - blade_velocity(1,:);
    v_fluid = v_fluid - blade_velocity(2,:);
    diff_dia_rel(i,:) = sqrt(u_fluid.^2+v_fluid.^2);
    diff_dia_aoa(i,:) = AOA(blade_velocity,[u_fluid; v_fluid],theta,lambda,alphaP);
end
nominal_rel = sqrt(lambda^2+2*lambda*cosd(theta)+1);

save(fullfile(data_folder,['diff_dia_rel_' num2str(Lambda) data_type]),'diff_dia_rel')
save(fullfile(data_folder,['nominal_rel_' num2str(Lambda) data_type]),'nominal_rel')
save(fullfile(data_folder,['diff_dia_aoa_' num2str(Lambda) data_type]),'diff_dia_aoa')
save(fullfile(data_folder,['diff_dia_ufluid_' num2str(Lambda) data_type]),'diff_dia_ufluid')
save(fullfile(data_folder,['diff_dia_vfluid_' num2str(Lambda) data_type]),'diff_dia_vfluid')