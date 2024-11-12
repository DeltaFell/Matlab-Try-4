%Joan Matutes
%7/30/24
%Adaptation of BladeVelocity into a subfunction
function bv = BladeVelocity(GeoConst,theta)
Omega = GeoConst.Omega;
r_turbine = GeoConst.rt;
bv = [Omega*r_turbine .* -cosd(theta); Omega*r_turbine .* -sind(theta)];
end