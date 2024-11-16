% Find average velocity in a integration blade shape contour
function avg = blade_integral(x_center,y_center,theta,blade_size,avg_val)
% grid_size = 0.01; % Size of each grid in the integration circle
% 
% height = 1; %*2
% width = 0.1; %*2
% dis = blade_size;
% 
% centerx = x_center-dis*cosd(theta);
% centery = y_center-dis*sind(theta);
% 
% [x, y] = meshgrid(centerx - (height+0.1) :grid_size: centerx + (height+0.1), centery - (height+0.1) :grid_size: centery + (height+0.1));
% 
% points_x = x(:);
% points_y = y(:);
% 
% square = [-width -width width width
%     height -height  -height height];
% R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% square = R*square + [centerx; centery];
% 
% figure(1)
% fill(square(1,:),square(2,:),'r')
% hold on;
% foiltest = plot_foil(theta,1);
% fill(foiltest(:,1),foiltest(:,2),'r')
% xlim([-4 4])
% ylim([-4 4])
% 
% in = inpolygon(points_x,points_y,square(1,:),square(2,:));
% qualified_x = points_x(in);
% qualified_y = points_y(in);
% 
% axis equal
% hold on
% plot(qualified_x,qualified_y,'r+') % points inside
% plot(points_x(~in),points_y(~in),'bo') % points outside
% 
% hold off
% 
% count = numel(qualified_x);
% num = 0;
% sum = 0;
% 
% for i = 1:count
%     if avg_val(qualified_x(i),qualified_y(i)) ~= 0
%         sum = sum + avg_val(qualified_x(i),qualified_y(i));
%         num = num+1;
%     end
% end
% 
% avg = sum/num;

grid_size = 0.01; % Size of each grid in the integration circle

ref_points = [-0.5 -0.5
    -1 1];

R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
ref_points = R*ref_points + [x_center; y_center];

figure(1)
scatter(ref_points(1,:),ref_points(2,:))
hold on
foiltest = plot_foil(theta,1);
fill(foiltest(:,1),foiltest(:,2),'r')
hold off
xlim([-4 4])
ylim([-4 4])

avg = 0;
for i = 1:2
    avg = avg + avg_val(ref_points(1,i),ref_points(2,i));
end
avg = avg/2;

end