clear all; close all; clc;
circleInt_diameter = 1.6; % Diameter of the circle used to take the integral over the velocity field
chord = 0.0406; % Chord length in m
r_turbine = 0.172/2; % Radius of the turbine in m
r_circle_center = r_turbine/chord * 2 * 0.482 ; % Distance from the turbine center to the the circle for integration centered at R/D = 0.482
circleInt_grid_size = 0.01; % Size of each grid in the integration circle. Defined in circle_integral.m
Uinf = 0.91; % Free flow velocity in m/s
alphaP = 6; % Preset angle in degree
circulation_size = 1.2; % Size of blade shape contour
span = 0.234; % span of the turbine is 0.234 m
diameterlist = [1.6 1.7 1.8 1.9 2];  % List of integration circle diameters
% R = [cosd(alphaP) sind(alphaP); -sind(alphaP) cosd(alphaP)];
% lambda = 1.1; % Tip speed ratio
% Omega = lambda*Uinf/(r_turbine); % Rotational speed in rad/s
% colors = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
% set(0,'defaultaxescolororder',colors);

set(groot,'defaultLineLineWidth',1.5); %linewidth is in points
set(0,'DefaultaxesLineWidth', 1) ;
set(0,'DefaultaxesFontSize', 18);
set(0,'DefaultaxesFontWeight', 'normal');
set(0,'DefaultTextFontSize', 11);
set(0,'DefaultaxesFontName', 'Helvetica');
set(0,'DefaultlegendFontName', 'Helvetica');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');
set(0,'defaultAxesXGrid','on');
set(0,'defaultAxesYGrid','on');

%% Velocity Vector
cd 'C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data'
run('NameProcessing')
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
% ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
l = 1;
%%
for i = [2 9 11]
    for t = [1]
        figure
        for j = 1:length(variable_name(i).name)
           name = (variable_name(i).name(j));
           load(name.name)
        end
    end
end
%%
        x_center = r_circle_center * -sind(theta(t));
        y_center = r_circle_center * cosd(theta(t));
        for k = 1 : 5
           h(l) = quiver(x_center, y_center, diff_dia_ufluid(k,t), diff_dia_vfluid(k,t), 'color', C{l});
           h(l).Color(4) = 0.02 * k;
           hold on
        end
        
        quiver(X, Y, U_phase(t).u, V_phase(t).v)
        hold on
        foil_coords = plot_foil(theta(t), 1);
        fill(foil_coords(:,1),foil_coords(:,2),'k')
        hold on
        xlim([-4,4])
        ylim([-4,4])
