 % Find average velocity in a integration circle
function avg = circle_integral(x,y,r,avg_val)
grid_size = 0.01; % Size of each grid in the integration circle

x_grid = x - r :grid_size: x + r;
num = length(x_grid);
y_grid = y - r :grid_size: y + r;

count = 0;
sum = 0;
for i = 1:num
    for j = 1:num
       if (x_grid(i) - x)^2 + (y_grid(j) - y)^2 < r^2 && avg_val(x_grid(i),y_grid(j)) ~= 0
           count = count + 1;
           sum = sum + avg_val(x_grid(i),y_grid(j));
       end
    end
end
avg = sum/count;
end