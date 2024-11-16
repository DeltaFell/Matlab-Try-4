% Find two components of fluid velocity within the integration circle for
% all theta
function [u_fluid,v_fluid, x_center, y_center] = bladeInt_whole(blade_size,u_inter,v_inter,theta,r_circle_center)

    for i = 1:length(theta)
        x_center(i) = r_circle_center * -sind(theta(i));
        y_center(i) = r_circle_center * cosd(theta(i));
        u_fluid(i) = blade_integral(x_center(i),y_center(i),theta(i),blade_size,u_inter);
        v_fluid(i) = blade_integral(x_center(i),y_center(i),theta(i),blade_size,v_inter);
    end
end