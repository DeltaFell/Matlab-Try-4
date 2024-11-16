function foil_coords = plot_foil(theta,size)
% parameters
alpha_p = -6; r = 2.118; rp = 2.118 - 0.18/2;

% turbine center in data
x0 = 0; y0 = 0;

%theta = 30
%size = 1
% Plot the foil

% read foil coordinates and extract first two columns
foil_coords = load('naca0018.dat');
foil_coords = foil_coords(:,1:2).*size;

% increase data point
%foil_coords = increase_data(foil_coords);

% pivot is at quarter chord
foil_coords(:,1) = foil_coords(:,1) - 0.25*size;

% Create rotation matrix for preset pitch
R = [cosd(alpha_p) -sind(alpha_p); sind(alpha_p) cosd(alpha_p)];
% Rotate the foil
foil_coords = (R*foil_coords')';

% Translate to radius of rotation
foil_coords(:,2) = foil_coords(:,2) + rp;

% Rotate by azimuthal theta
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
foil_coords = (R*foil_coords')';

% color the foil
%fill(foil_coords(:,1),foil_coords(:,2),'r')
%hold on;

%pbaspect([1 1 1])
%xlim([-5 5])
%ylim([-5 5])
end