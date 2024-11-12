% Find two components of fluid velocity within the integration circle for
% all theta
function [u_fluid,v_fluid, x_center, y_center] = circleInt_whole(r_circle_center,diameter,theta,u_inter,v_inter)
    r_circle = diameter/2;
    for i = 1:length(theta)
        x_center(i) = r_circle_center * -sind(theta(i));
        y_center(i) = r_circle_center * cosd(theta(i));
        u_fluid(i) = circle_integral(x_center(i),y_center(i),r_circle,u_inter);
        v_fluid(i) = circle_integral(x_center(i),y_center(i),r_circle,v_inter);
    end
end