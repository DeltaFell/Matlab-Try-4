% FluidVelocity   Establishes the fluid velocities for a given flowdata
% and geometric structure
%
%[u_fluid, v_fluid,fluid_velocity_mag] = FluidVelocity(flowdata,GC,isphase)
% produces the fluid velocities and magniutdes for a phase analysis,
% ONLY to be used if isphase == true.
%
%[u_fluid, v_fluid,fluid_velocity_mag,u_inter,v_inter] = FluidVelocity(flowdata,GC,isphase)
% same thing as the other one, but for when isphase isn't true.


function [u_fluid, v_fluid,fluid_velocity_mag,u_inter,v_inter] = FluidVelocity(flowdata,GC,isphase)
if isphase == true
    [u_fluid, v_fluid] = circleInt_whole_phase(GC.rcc,GC.cI_diameter,flowdata); % Componets of flow velocity
    fluid_velocity_mag = hypot(u_fluid,v_fluid);
else
    [Uavg, Vavg] = avg_velocityfield(flowdata);
    u_inter = griddedInterpolant(GC.X,GC.Y,Uavg);
    v_inter = griddedInterpolant(GC.X,GC.Y,Vavg);
    [u_fluid, v_fluid] = circleInt_whole(GC.rcc,GC.cI_diameter,GC.theta,u_inter,v_inter); % Componets of flow velocity
     fluid_velocity_mag = hypot(u_fluid,v_fluid);
end
end