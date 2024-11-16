function data_ext = increase_data(data)
% increase data point
x = data(:,1);
y = data(:,2);
x_ext = zeros(2*length(x),1);
y_ext = zeros(2*length(y),1);
for i = 1:length(x)
    x_ext(2*i) = x(i);
    y_ext(2*i) = y(i);
end

for i = 1:length(x)-1
    x_diff(i) = (x(i+1)+x(i))/2;
    y_diff(i) = (y(i+1)+y(i))/2;
end

x_ext = x_ext(2:end);
y_ext = y_ext(2:end);
for i = 1:length(x_ext)/2
    x_ext(2*i) = x_diff(i);
    y_ext(2*i) = y_diff(i);
end

data_ext(:,1) = x_ext;
data_ext(:,2) = y_ext;
end