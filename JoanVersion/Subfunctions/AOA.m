% AOA  Caclulates angles of attack
%  [aoa,nominal_aoa] = AOA(blade_velocity,relative_velocity,theta,GeoConst)
%  calculates the angle of attack from blade and relative fluid velocities
%  and the nominal angle of attack from geometric methods
%
% GeoConst is a struct defined in JoanCalculation.m, look there for details
% and specifics of the layout
%
%Joan Matutes
%8/1/24
%Revised version of AOA.m that uses the GeoConst struct for data

function [aoa, nominal_aoa] = AOA(blade_velocity,relative_velocity,theta,GeoConst)

lambda = GeoConst.lambda;
alphaP = GeoConst.alphaP;
bladeV_angle = cart2pol(blade_velocity(1,:),blade_velocity(2,:));
relativeV_angle = cart2pol(-relative_velocity(1,:),-relative_velocity(2,:));

% for i = 1:length(theta);
%     if bladeV_angle(i) < 0
%         bladeV_angle(i) = 2*pi + bladeV_angle(i);
%     end
%     if relativeV_angle(i) < 0
%         relativeV_angle(i) = 2*pi + relativeV_angle(i);
%     end
% end

aoa = relativeV_angle - bladeV_angle;
%aoa = pi - bladeV_angle + relativeV_angle;

aoa = aoa/pi*180+alphaP;
%aoa  = rem(aoa,180);
 for i = 1:length(theta)
     if aoa(i) < -180
         aoa(i) = aoa(i) + 360;
     end
     if aoa(i) > 180
        aoa(i) = aoa(i) - 360;
     end
end


nominal_aoa = -atand(sind(theta)./(lambda+cosd(theta)))+alphaP;