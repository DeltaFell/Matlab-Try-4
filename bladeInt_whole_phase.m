function [u_fluid,v_fluid,x_center,y_center] = bladeInt_whole_phase(blade_size,flowdata,r_circle_center)
    X = flowdata(1).X;
    Y = flowdata(1).Y;
    for i = 1:length(flowdata);
        theta = flowdata(i).theta;
        x_center(i) = r_circle_center * -sind(theta);
        y_center(i) = r_circle_center * cosd(theta);
        u_inter = griddedInterpolant(X,Y,flowdata(i).u);
        v_inter = griddedInterpolant(X,Y,flowdata(i).v);
        u_fluid(i) = blade_integral(x_center(i),y_center(i),theta,blade_size,u_inter);
        v_fluid(i) = blade_integral(x_center(i),y_center(i),theta,blade_size,v_inter);
    end
end