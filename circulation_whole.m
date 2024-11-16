function circulation =  circulation_whole(flowdata,foil_coords)
X = flowdata(1).X;
Y = flowdata(1).Y;
for i = 1:length(flowdata)
        theta(i) = flowdata(i).theta;
end

for i = 1:length(theta)
    u_inter = griddedInterpolant(flowdata(1).X,flowdata(1).Y,flowdata(i).u);
    v_inter = griddedInterpolant(flowdata(1).X,flowdata(1).Y,flowdata(i).v);
    circulation(i) = circulation_line(u_inter,v_inter,foil_coords(i).coord);
end

