% Find the averaged velocity field
function [Uavg Vavg] = avg_velocityfield(flowdata)
theta_num = length(flowdata);
Us = 0;
Vs = 0;
for i = 1:theta_num
    Us = Us + flowdata(i).u;
    Vs = Vs + flowdata(i).v;
end
Uavg = Us./theta_num;
Vavg = Vs./theta_num;
end