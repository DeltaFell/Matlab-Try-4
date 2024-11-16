clear all; close all; clc;
cd 'C:\Users\sqks8\MATLAB Drive\AOA Estimation Research'
data_folder = 'C:\Users\sqks8\MATLAB Drive\AOA Estimation Research\DD Data'

%% 1.1 Phase
lambda = 1.1; % Tip speed ratio
%Data = load('CFD_confined_TSR_1_1.mat'); % Loading data
isphase = true;
Lambda = 11;
data_type = 'P';

%% 1.9 Phase
lambda = 1.9; % Tip speed ratio
%Data = load('CFD_confined_LES_TSR_1_9.mat');% Loading data
isphase = true;
Lambda = 19;
data_type = 'P';

%% Loading
%flowdata = Data.flow_data;
X = flowdata(1).X;
Y = flowdata(1).Y;
for i = 1:length(flowdata)
    theta(i) = flowdata(i).theta;
    flowdata(i).u(isnan(flowdata(i).u)) = 0;
    flowdata(i).v(isnan(flowdata(i).v)) = 0;
    U_field(i).u = flowdata(i).u;
    V_field(i).v = flowdata(i).v;
    Vorticity(i).vort = flowdata(i).vort;
end

% % Data processing
% Initial process
% if lambda == 1.9
%     ds = 8;
%     X = X(1:ds:length(X), 1:ds:length(X));
%     Y = Y(1:ds:length(Y), 1:ds:length(Y));
% end



% Geometric constants 
circleInt_diameter = 1.6; % Diameter of the circle used to take the integral over the velocity field
chord = 0.0406; % Chord length in m
r_turbine = 0.172/2; % Radius of the turbine in m
r_circle_center = r_turbine/chord * 2 * 0.482 ; % Distance from the turbine center to the the circle for integration centered at R/D = 0.482
circleInt_grid_size = 0.01; % Size of each grid in the integration circle. Defined in circle_integral.m
Uinf = 0.91; % Free flow velocity in m/s
Omega = lambda*Uinf/(r_turbine); % Rotational speed in rad/s
alphaP = 6; % Preset angle in degree
circulation_size = 1.2; % Size of blade shape contour
diameterlist = [1.6 1.7 1.8 1.9 2];  % List of integration circle diameters
 
% % Find Velocity Field 
% if lambda == 1.9
%     load 'C:\Users\sqks8\MATLAB Drive\AOA Estimation Research\Calculation Data\SD_U_field_19PO.mat';
%     load 'C:\Users\sqks8\MATLAB Drive\AOA Estimation Research\Calculation Data\SD_V_field_19PO.mat';    
% else
%     load 'C:\Users\sqks8\MATLAB Drive\AOA Estimation Research\Calculation Data\SD_U_field_11PO.mat';
%     load 'C:\Users\sqks8\MATLAB Drive\AOA Estimation Research\Calculation Data\SD_V_field_11PO.mat';    
% end
% for i = 1:length(theta)
%     flowdata(i).X = X;
%     flowdata(i).Y = Y;
%     flowdata(i).u = SD_U_field.u;
%     flowdata(i).v = SD_V_field.v;    
% end
 
%[u_fluid, v_fluid] = circleInt_whole_phase(r_circle_center,circleInt_diameter,flowdata); % Componets of flow velocity

% Relative velocity of different integration circle
diff_dia_rel = zeros(length(diameterlist),length(theta));
diff_dia_aoa = zeros(length(diameterlist),length(theta));
blade_velocity = [Omega*r_turbine .* -cosd(theta); Omega*r_turbine .* -sind(theta)];
    
for  i = 1:length(diameterlist)
        [u_fluid, v_fluid] = circleInt_whole_phase(r_circle_center,diameterlist(i),flowdata);
    u_fluid = u_fluid - blade_velocity(1,:);
    v_fluid = v_fluid - blade_velocity(2,:);
    diff_dia_rel(i,:) = sqrt(u_fluid.^2+v_fluid.^2);
    diff_dia_aoa(i,:) = AOA(blade_velocity,[u_fluid; v_fluid],theta,lambda,alphaP);
end
nominal_rel = sqrt(lambda^2+2*lambda*cosd(theta)+1);

save(fullfile(data_folder,['diff_dia_rel_' num2str(Lambda) data_type]),'diff_dia_rel')
save(fullfile(data_folder,['diff_dia_aoa_' num2str(Lambda) data_type]),'diff_dia_aoa')


for i = 1:5
    plot(theta,diff_dia_rel(i,:))
    hold on
end