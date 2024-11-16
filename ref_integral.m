% Find average velocity in a integration blade shape contour
function avg = blade_integral(x_center,y_center,theta,blade_size,avg_val)
grid_size = 0.01; % Size of each grid in the integration circle

ref_points = [-0.5 0 0
    0 1 -1]

% height = 1; %*2
% width = 0.1; %*2
% dis = blade_size;

% centerx = x_center-dis*cosd(theta);
% centery = y_center-dis*sind(theta);

% [x, y] = meshgrid(centerx - (height+0.1) :grid_size: centerx + (height+0.1), centery - (height+0.1) :grid_size: centery + (height+0.1));

% points = [x(:) y(:)];
% points_x = points(:,1);
% points_y = points(:,2);

% square = [-width -width width width
%     height -height  -height height];
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
% square = R*square + [centerx; centery];
ref_points = R*ref_points + [x_center; y_center];

figure(1)
%pgon = polyshape([centerx - (height+0.1), centerx - (height+0.1), centerx + (height+0.1), centerx + (height+0.1)],[centery + (height+0.1), centery - (height+0.1), centery - (height+0.1), centery + (height+0.1)])
%plot(pgon)
scatter(ref_points(1,:),ref_points(2,:))
hold on
%fill(square(1,:),square(2,:),'r')
foiltest = plot_foil(theta,1);
fill(foiltest(:,1),foiltest(:,2),'r')
hold off
xlim([-4 4])
ylim([-4 4])

%[in] = inpolygon(points(:,1),points(:,2),square(:,1),square(:,2));

%r = 0.1*blade_size*sqrt(2);
%[x, y] = meshgrid(centerx - r :grid_size: centerx + r, centery - r :grid_size: centery + r);
%  r = blade_size/4*3;
%  [x, y] = meshgrid(x_center - r :grid_size: x_center + r, y_center - r :grid_size: y_center + r);
%  points = [x(:) y(:)];
%  points_x = points(:,1);
%  points_y = points(:,2);
%  coord = plot_foil(theta,blade_size);
%  [in] = inpolygon(points(:,1),points(:,2),coord(:,1),coord(:,2));
% 
% qualified_x = points_x(in);
% qualified_y = points_y(in);

% plot(coord(:,1),coord(:,2)) % polygon
% axis equal
% hold on
% plot(points_x(in),points_y(in),'r+') % points inside
% plot(points_x(~in),points_y(~in),'bo') % points outside
% hold off

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
avg = 0;
for i = 1:3
    avg = avg + avg_val(ref_points(1,i),ref_points(2,i));
end
avg = avg/3;

end