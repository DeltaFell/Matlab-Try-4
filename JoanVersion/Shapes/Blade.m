% Returns the logical array for points in a prescribed foil
% requires naca0018.dat and plot_foil.m
% in - logical array
% A - polygon
%
% theta - current angle
% X,Y - X and Y arrays
function [in,A] = Blade(theta,size,X,Y)
A = plot_foil(theta,size);
in = inpolygon(X,Y,A(:,2),A(:,1));
end