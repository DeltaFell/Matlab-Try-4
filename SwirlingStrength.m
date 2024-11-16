%% Swirling Strength
%Detect the vorticies by using swirling strength criterion which is
%outlined in Adrian pg 465. (THIS IS A TEXTBOOK SAME METHOD IS OUTLINED IN THE PAPER I SHARED BY ADRIAN AS WELL)
clear all; close all
%data_folder = 'C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data';
data_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data';
%cd 'C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data'
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
f = dir('*11P.mat')
data_type = 'PO'
threshSwirl = 2;
 
for i = 1:length(f)
    load(fullfile(data_folder,f(i).name))
end

%%
ds = 1;

if lambda == 1.9
    ds = 8;
    X = X(1:ds:length(X), 1:ds:length(X));
    Y = Y(1:ds:length(Y), 1:ds:length(Y));
    Lambda = 19;
end

if lambda == 1.1
    Lambda = 11;
end

dx=X(2)-X(1); %m
dy=Y(1,2)-Y(1,1); %m
Nx = length(X);
Ny = length(Y);

% preallocate
swirl_binary = struct;
swirl = struct;
U_select = struct;
V_select = struct;

for phase = 1:length(theta)
phase/length(theta)*100
Swirl_Avg = zeros(length(X),length(Y));
Swirl_binary = zeros(length(X),length(Y));

ubar = U_field(phase).u;
vbar = V_field(phase).v;

ubar = ubar(1:ds:length(ubar), 1:ds:length(ubar));
vbar = vbar(1:ds:length(vbar), 1:ds:length(vbar));

U_select(phase).u = ubar;
V_select(phase).v = vbar;

Vort_Avg = Vorticity(phase).vort;

    for i=2:Nx-1
        for j=2:Ny-1
            u_x=(ubar(i+1,j)-ubar(i-1,j))/(2*dx);
            v_x=(vbar(i+1,j)-vbar(i-1,j))/(2*dx);
            u_y=(ubar(i,j+1)-ubar(i,j-1))/(2*dy);
            v_y=(vbar(i,j+1)-vbar(i,j-1))/(2*dy);
            D2_d=[u_x u_y; v_x v_y];
            if isnan(D2_d(1)) || isnan(D2_d(2)) || isnan(D2_d(3)) || isnan(D2_d(4))
                e(i,j,:)=[0 0];
            else
                e(i,j,:)=eigs(D2_d);
            end
        end
    end

lam_ci=abs(imag(e(:,:,1)));

% use criterion that the imaginary part needs to be greater than a threashold which
% means that there is some 'swirling strength'
% The vortex center exists where the 'swirling strength' is at a
% maximum

for i=2:Nx-1
    for j=2:Ny-1
        if lam_ci(i,j) > threshSwirl
           Swirl_binary(i,j) = 1;
            if Vort_Avg(i,j) > 0
                Swirl_Avg(i,j)=lam_ci(i,j);
            elseif Vort_Avg(i,j) < 0
                   Swirl_Avg(i,j)=-lam_ci(i,j);
            end
        else
            Swirl_Avg(i,j)=0;
        end
    end
end

swirl(phase).swirl = Swirl_Avg;
swirl_binary(phase).plot = Swirl_binary;
swirl(phase).theta = theta(phase);
end

save(fullfile(data_folder,['swirl_' num2str(Lambda) data_type]),'swirl')
save(fullfile(data_folder,['swirl_binary_' num2str(Lambda) data_type]),'swirl_binary')

%% Find location for maximum swirling strength
%clear all; close all
%data_folder = 'C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data';
data_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data';
%cd 'C:\Users\Jiaon\MATLAB Drive\AOA Estimation Research\Calculation Data'
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
f = dir('swirl*11PO.mat')
data_type = 'PO'
 
for i = 1:length(f)
    load(fullfile(data_folder,f(i).name))
end
%load(fullfile(data_folder,'X_11P.mat'))
%load(fullfile(data_folder,'Y_11P.mat'))

%%
chord = 0.0406; % Chord length in m
r_turbine = 0.172/2; % Radius of the turbine in m
r_circle_center = r_turbine/chord * 2 * 0.482 ; % Distance from the turbine center to the the circle for integration centered at R/D = 0.482
search_circle_size = 20;
%theta = [swirl.theta];

location_max = zeros(2,length(theta));
grid_num = length(X);


U_select_ls = struct;
V_select_ls = struct;
swirl_select = struct;
for i = 1:length(theta)
    x_center = round(r_circle_center * -sind(theta(i))/8*grid_num) + grid_num/2;
    y_center = round(-(r_circle_center * cosd(theta(i)))/8*grid_num) + grid_num/2;
    local_max = 0;
    
    U_select_ls(i).u = U_select(i).u(x_center-20:x_center+20 , y_center-20:y_center+20);
    V_select_ls(i).v = V_select(i).v(x_center-20:x_center+20 , y_center-20:y_center+20);
    swirl_select(i).swirl = abs(swirl(i).swirl(x_center-20:x_center+20 , y_center-20:y_center+20));
    [row, col] = find(ismember(swirl_select(i).swirl, max(swirl_select(i).swirl(:))));
    location_max(:,i) = [row(1); col(1)] ;
end

%% Vortex deletion
f2 = dir('*11PO.mat')
Lambda = 11;
if lambda == 1.9
    ds = 8;
    Xd = X(1:ds:length(X), 1:ds:length(X));
    Yd = Y(1:ds:length(Y), 1:ds:length(Y));
    Lambda = 19;
else
    Xd = X;
    Yd = Y;
end

for i = 1:length(f2)
    load(fullfile(data_folder,f2(i).name))
end

for i = 1:length(theta)
    if lambda == 1.9
        ds = 8;
        U_field(i).u =  U_field(i).u(1:ds:length(X), 1:ds:length(X));
        V_field(i).v =  V_field(i).v(1:ds:length(X), 1:ds:length(X));
    end
    deletion_binary(i).binary  = ones(length(Xd),length(Yd)) - swirl_binary(i).plot;
    SD_U_field(i).u = deletion_binary(i).binary.*U_field(i).u;
    SD_V_field(i).v = deletion_binary(i).binary.*V_field(i).v;
end

save(fullfile(data_folder,['SD_U_field_' num2str(Lambda) data_type]),'SD_U_field')
save(fullfile(data_folder,['SD_V_field_' num2str(Lambda) data_type]),'SD_V_field')
