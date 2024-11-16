function [u_fluid,v_fluid,x_center,y_center] = circleInt_whole_phase(r_circle_center,diameter,flowdata)
    r_circle = diameter/2;
    X = flowdata(1).X;
    Y = flowdata(1).Y;
    for i = 1:length(flowdata);
        theta(i) = flowdata(i).theta;
        x_center(i) = r_circle_center * -sind(theta(i));
        y_center(i) = r_circle_center * cosd(theta(i));
        u_inter = griddedInterpolant(X,Y,flowdata(i).u);
        v_inter = griddedInterpolant(X,Y,flowdata(i).v);
        u_fluid(i) = circle_integral(x_center(i),y_center(i),r_circle,u_inter);
        v_fluid(i) = circle_integral(x_center(i),y_center(i),r_circle,v_inter);
    end
end