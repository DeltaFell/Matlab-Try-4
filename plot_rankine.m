% clear all; close all; 
% R = 0.15;
% gamma = 1.3375;
% center_x = -0.1467;
% center_y = -1.7533;
% [Fx Fy] = plot_rankine(center_x,center_y,R,gamma);
% 
% [X,Y] = ndgrid(-4:0.1:4,-4:0.1:4);
% ux = Fx(X,Y);
% uy = Fy(X,Y);
% quiver(X,Y,ux,uy)


function [Fx Fy] = plot_rankine(center_x,center_y,R,gamma)
x = -3:0.005:3;
y = -3:0.005:3;
[X,Y] = ndgrid(x,y);
for i = 1:length(x)
    for j = 1:length(x)
        r = X(i,j)^2 + Y(i,j) ^2;
        theta = cart2pol(X(i,j),Y(i,j));
        if r <= R
            u_theta = gamma/(2*pi)*(r)/R^2;
        else
            u_theta = 0;%gamma/(2*pi)/r^2;
        end
        u_x(i,j) = -sin(theta)*u_theta;
        u_y(i,j) = cos(theta)*u_theta;
    end
end
% figure;
% quiver(X,Y,u_x,u_y)
% title('velocity field direction')

Fx = griddedInterpolant(X+center_x,Y+center_y,u_x);
Fy = griddedInterpolant(X+center_x,Y+center_y,u_y);
end