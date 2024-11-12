% Returns the logical array for points in a prescribed rectangle
% requires crect.m
% in - logical array
% A - polygon 
%
% theta - current angle
% w - rectangle width
% h - current height
% R - turbine radius
% X,Y - X and Y arrays
% m - tangential offset from the quarter chord

%Joan Matutes 8/16/24
function [in,A] = Rectangle(theta,w,h,R,X,Y,m)
thetab = 365 - theta; % flipping for theta
xi = R*cosd(thetab); % finding the quarter chord
yi = R*sind(thetab);
xi = (xi+4)*12.5; % scaling up to 100x100
yi = (yi+4)*12.5;
o = [xi,yi];
o = o + m*[cosd(thetab+90),sind(thetab+90)]; % offsetting tangentially
[xv,yv] = crect(o,w,h);
psh = polyshape(xv,yv);
psh = rotate(psh,thetab,o); % rotating
xv = [psh.Vertices(:,1);psh.Vertices(1,1)];
yv = [psh.Vertices(:,2);psh.Vertices(1,2)];
in = inpolygon(X,Y,xv,yv);
A = [xv,yv];
end
