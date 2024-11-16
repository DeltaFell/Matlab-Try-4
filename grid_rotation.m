% clear
% load('C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data\U_field_11P.mat')
% load('C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data\X_11P.mat')
% load('C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data\Y_11P.mat')
% inter = griddedInterpolant(X,Y,U_field(1).u);
% theta = 10;
% result = grid_rotation(theta,inter,50)

function grid_val = grid_rotation(theta,inter,Xrange,Yrange,num)
XYratio = (Xrange(2)-Xrange(1))/(Yrange(2)-Yrange(1));
Xinit = linspace(Xrange(1),Xrange(2),num*XYratio);
Yinit = linspace(Yrange(1),Yrange(2),num);
[Xq,Yq] = meshgrid(Xinit,Yinit);

XY = [Xq(:) Yq(:)];     % Create Matrix Of Vectors
%theta=300; %TO ROTATE CLOCKWISE BY X DEGREES
R=[cosd(theta) -sind(theta); sind(theta) cosd(theta)]; %CREATE THE MATRIX
rotXY=XY*R'; %MULTIPLY VECTORS BY THE ROT MATRIX

chord = 0.0406; % Chord length in m
r_turbine = 0.172/2; % Radius of the turbine in m
r_circle_center = r_turbine/chord * 2 * 0.482 ;
x_center = r_circle_center * -sind(theta);
y_center = r_circle_center * cosd(theta);
rotXY(:,1) = rotXY(:,1) + x_center;
rotXY(:,2) = rotXY(:,2) + y_center;

Xqr = reshape(rotXY(:,1), size(Xq,1), []);
Yqr = reshape(rotXY(:,2), size(Yq,1), []);

% foilcoord = plot_foil(theta,1)
% fill(foilcoord(:,1),foilcoord(:,2),'r')
% hold on
% scatter(rotXY(:,1),rotXY(:,2))
% xlim([-4 4])
% ylim([-4 4])

grid_val = inter(Xqr,Yqr);
end