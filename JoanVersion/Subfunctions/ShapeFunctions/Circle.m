% Returns the logical array for points inside a shape
% in - logical array
% A - polygon 
% 
% theta - current angle
% R - turbine radius
% r - radius of circle
% X,Y - X and Y arrays

%Joan Matutes 8/16/24
function [in,A] = Circle(theta,R,r,X,Y)
%X2 = (X+4)*12.5; %this may need adjusting, it 
thet = [0:pi/32:2*pi,0]'; %using pi/32 as the interval for no reason
thetab = 365 - theta; % flipping for theta
xi = R*cosd(thetab);
yi = R*sind(thetab);
xi = (xi+4)*12.5;
yi = (yi+4)*12.5;
xv = r*cos(thet)+xi;
yv = r*sin(thet)+yi;
in = inpolygon(X,Y,xv,yv);
A = [xv,yv];
end