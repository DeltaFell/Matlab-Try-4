clear all; close all; clc;
circleInt_diameter = 1.6; % Diameter of the circle used to take the integral over the velocity field
chord = 0.0406; % Chord length in m
r_turbine = 0.172/2; % Radius of the turbine in m
r_circle_center = r_turbine/chord * 2 * 0.482 ; % Distance from the turbine center to the the circle for integration centered at R/D = 0.482
circleInt_grid_size = 0.01; % Size of each grid in the integration circle. Defined in circle_integral.m
Uinf = 0.91; % Free flow velocity in m/s
alphaP = 6; % Preset angle in degree
circulation_size = 1.2; % Size of blade shape contour
span = 0.234; % span of the turbine is 0.234 m
diameterlist = [1.6 1.7 1.8 1.9 2];  % List of integration circle diameters
% R = [cosd(alphaP) sind(alphaP); -sind(alphaP) cosd(alphaP)];
% lambda = 1.1; % Tip speed ratio
% Omega = lambda*Uinf/(r_turbine); % Rotational speed in rad/s
% colors = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
% set(0,'defaultaxescolororder',colors);

set(groot,'defaultLineLineWidth',1.5); %linewidth is in points
set(0,'DefaultaxesLineWidth', 1) ;
set(0,'DefaultaxesFontSize', 18);
set(0,'DefaultaxesFontWeight', 'normal');
set(0,'DefaultTextFontSize', 11);
set(0,'DefaultaxesFontName', 'Helvetica');
set(0,'DefaultlegendFontName', 'Helvetica');
set(0,'defaultAxesTickLabelInterpreter','latex');
set(0,'defaultLegendInterpreter','latex');
set(0,'defaultAxesXGrid','on');
set(0,'defaultAxesYGrid','on');

%% Velocity Vector
%cd 'I:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
% ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
tiledlayout("flow");
l = 1;
for i = [2 9 11]
    for t = [22]
        figure
        for j = 1:length(variable_name(i).name)
           name = (variable_name(i).name(j));
           load(name.name)
        end
        x_center = r_circle_center * -sind(theta(t));
        y_center = r_circle_center * cosd(theta(t));
        for k = 1 : 5
           h(l) = quiver(x_center, y_center, diff_dia_ufluid(k,t), diff_dia_vfluid(k,t), 'color', C{l});
           h(l).Color(4) = 0.02 * k;
           hold on
        end
        
        quiver(X, Y, U_phase(t).u, V_phase(t).v)
        hold on
        foil_coords = plot_foil(theta(t), 1);
        fill(foil_coords(:,1),foil_coords(:,2),'k')
        hold on
        xlim([-4,4])
        ylim([-4,4])
    end
end

    
%% TSR 1.1 AOA
% set(0,'defaulttextinterpreter','latex')
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
%ha = tight_subplot(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
tiledlayout("flow")

l = 1;
for i = 1:2
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3
                legendinfo{l} = ['$TA\ Circle$']; 
        else
                legendinfo{l} = ['$PA\ Circle$'];
        end
        hold on
    end
    l = l+1;
end

for i = 5:6
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Blade$']; 
        else
                legendinfo{l} = ['$PA\ Blade$'];
        end
        hold on
    end
    l = l+1;
end
%Vorticity deletion save for future reference
% load('E:\Williams Lab\Turbines\AOA Estimation Research\VD data\diff_dia_aoa_11P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ VD$'];
%         hold on
%     end
% l = l+1;
% load('E:\Williams Lab\Turbines\AOA Estimation Research\SD data\diff_dia_aoa_11P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ SD$'];
%         hold on
%     end
% l = l+1;

for i = 13
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        legendinfo{l} = ['$PA\ Reference\ Points$'];
        hold on
    end
    l = l+1;
end

for i = 15
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        legendinfo{l} = ['$PA\ Rectangle$'];
        hold on
    end
    l = l+1;
end

h(l) = plot(theta,nominal_aoa,'--k','LineWidth',2);
legendinfo{l} = ['$Nominal\ AOA$'];
legend(h, legendinfo, 'location', 'best', 'FontSize', 10)
xlim([0 360])
ylim([-180 180])
set(gca,'xtick',[0:60:360])
set(gca, 'ytick', [-180:60:180])
grid on
xlabel('$\theta$','Interpreter','latex')
ylabel('$\alpha$','Interpreter','latex')
% set(gcf,'position',[270,225,800,500])
today = date;
stringy = 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\';
path = strcat(stringy,today);
cd(path) %this allows us to actually save to new folders instead of writing
% w/in extant ones, primarily just so I don't fuck it up
print(figure(1) ,'AOA 1.1.png', '-dpng', '-r600' )
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'
%% TSR 1.9 AOA
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels'); 
tiledlayout("flow");
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]}; 
l = 1;
for i = 3:4
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Circle$']; 
        else
                legendinfo{l} = ['$PA\ Circle$'];
        end
        hold on
    end
    l = l+1;
end
for i = 7:8
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Blade$']; 
        else
                legendinfo{l} = ['$PA\ Blade$'];
        end
        hold on
    end
    l = l+1;
end
% load('E:\Williams Lab\Turbines\AOA Estimation Research\VD data\diff_dia_aoa_19P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ VD$'];
%         hold on
%     end
% l = l+1;
% load('E:\Williams Lab\Turbines\AOA Estimation Research\SD data\diff_dia_aoa_19P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ SD$'];
%         hold on
%     end
% l = l+1;

for i = 14
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        legendinfo{l} = ['$PA\ Reference\ Points$'];
        hold on
    end
    l = l+1;
end

for i = 16
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        legendinfo{l} = ['$PA\ Rectangle$'];
        hold on
    end
    l = l+1;
end

for i  = 17
        for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        legendinfo{l} = ['$IN\ Circle$'];
        hold on
    end
    l = l+1;
end

h(l) = plot(theta,nominal_aoa,'--k','LineWidth',2);
legendinfo{l} = ['$Nominal\ AOA$'];
% legend(h, legendinfo, 'location', 'best', 'FontSize', 8)
xlim([0 360])
% ylim([-90 90])
set(gca,'xtick',[0:60:360])
% set(gca, 'ytick', [-90:30:90])
grid on
xlabel('$\theta$','Interpreter','latex')
ylabel('$\alpha$','Interpreter','latex')
% set(gcf,'position',[270,225,800,500])
%cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\4-4-2022'
cd(path)
print(figure(1) ,'AOA 1.9.png', '-dpng', '-r600' )
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'

%% TSR 1.1 Relative Velocity
tic
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels'); 
tiledlayout("flow");
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
l = 1;
for i = 1:2
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = sqrt(relative_velocity(1,:).^2+relative_velocity(2,:).^2) / Uinf;
       
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:)/Uinf, 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Circle$']; 
        else
                legendinfo{l} = ['$PA\ Circle$'];
        end
        hold on
    end
    l = l+1;
end

for i = 5:6
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = sqrt(relative_velocity(1,:).^2+relative_velocity(2,:).^2) / Uinf;
       
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:)/Uinf, 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Blade\$']; 
        else
                legendinfo{l} = ['$PA\ Blade\$'];
        end
        hold on
    end
    l = l+1;
end

% load('E:\Williams Lab\Turbines\AOA Estimation Research\VD data\diff_dia_rel_DD11P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ VD$'];
%         hold on
%     end
% l = l+1;
% load('E:\Williams Lab\Turbines\AOA Estimation Research\SD data\diff_dia_rel_SW11P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ SD$'];
%         hold on
%     end
% l = l+1;

for i = 13
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
        legendinfo{l} = ['$PA\ Square$'];
        hold on
    end
    l = l+1;
end

for i = 15
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        legendinfo{l} = ['$PA\ Square$'];
        hold on
    end
    l = l+1;
end

nominal_rel = sqrt(lambda^2+2*lambda*cosd(theta)+1);
h(l) = plot(theta, nominal_rel,'--k','linewidth',2);
legendinfo{l} = ['$Nominal\ Relative\ Velocity$'];
% legend(h,legendinfo, 'location', 'best','FontSize',8)
% title('Normalized Relative Velocity Magnitude')
xlim([0 360])
set(gca,'xtick', [0:60:360])
xlabel('$\theta$','Interpreter','latex')
ylabel('$\frac{U_{rel}}{U_{\infty}}$','Interpreter','latex')
grid on
% set(gcf,'position',[270,225,800,500])
%cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\4-4-2022'
cd(path)
print(figure(1) ,'Rel 1.1.png', '-dpng', '-r600' )
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'
toc
l
%% TSR 1.9 Relative Velocity
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels'); 
tiledlayout("flow");
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
l = 1;
for i = 3:4
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = sqrt(relative_velocity(1,:).^2+relative_velocity(2,:).^2) / Uinf;
       
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:)/Uinf, 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Circle$']; 
        else
                legendinfo{l} = ['$PA\ Different\ Circle\ Size\ \lambda = $', num2str(lambda)];
        end
        hold on
        
    end
    l = l+1;
end

for i = 7:8
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = sqrt(relative_velocity(1,:).^2+relative_velocity(2,:).^2) / Uinf;
       
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:)/Uinf, 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Blade$']; 
        else
                legendinfo{l} = ['$PA\ Blade$'];
        end
        hold on
    end
    l = l+1;
end

% load('E:\Williams Lab\Turbines\AOA Estimation Research\VD data\diff_dia_rel_DD19P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ VD$'];
%         hold on
%     end
% l = l+1;
% load('E:\Williams Lab\Turbines\AOA Estimation Research\SD data\diff_dia_rel_SW19P')
%     for k = 1 : height(diff_dia_rel)
%         h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
%         h(l).Color(4) = 0.2 * k;
%         legendinfo{l} = ['$PA\ Circle\ SD$'];
%         hold on
%     end
% l = l+1;

for i = 14
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
        legendinfo{l} = ['$PA\ Reference\ Points$'];
        hold on
    end
    l = l+1;
end

for i = 16
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        legendinfo{l} = ['$PA\ Rectangle$'];
        hold on
    end
    l = l+1;
end


for i = 17
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_rel(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        legendinfo{l} = ['$IN\ Circle$'];
        hold on
    end
    l = l+1;
end

nominal_rel = sqrt(lambda^2+2*lambda*cosd(theta)+1);
h(l) = plot(theta, nominal_rel,'--k','linewidth',2);
legendinfo{l} = ['$Nominal\ Relative\ Velocity\ \lambda = $', num2str(lambda)];
legend(h,legendinfo,'FontSize',8, 'location', 'best')
% title('Normalized Relative Velocity Magnitude')
xlim([0 360])
set(gca,'xtick', [0:60:360])
xlabel('$\theta$','Interpreter','latex')
ylabel('$\frac{U_{rel}}{U_{\infty}}$','Interpreter','latex')
grid on
% set(gcf,'position',[270,225,800,500])
%cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\4-4-2022'
cd(path)
print(figure(1) ,'Rel 1.9.png', '-dpng', '-r600' )
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'

%% U_rel vs Range 1.1
close all;
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')

C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0],[0 1 1],[0 1 0]}; 
l = 1;
clear 'range' 'STD' 
for i = 1:2
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = sqrt(relative_velocity(1,:).^2+relative_velocity(2,:).^2) / Uinf;
    for k = 1 : length(diff_dia_rel)
        range(k) = (max(diff_dia_rel(:,k))- min(diff_dia_rel(:,k))) / Uinf; 
        STD(k) = std(diff_dia_rel(:,k)/Uinf)./ mean(diff_dia_rel(:,k)/Uinf);
    end
    if i == 1 || i == 3
                h(l) = scatter(normalize_rel_mag, range);
%                 h(l) = scatter(normalize_rel_mag, STD);
                legendinfo{l} = ['TA ' '$\lambda = $', num2str(lambda)];
                l = l+1;
                hold on
    else
                h(l) = scatter(normalize_rel_mag, range);
%                 h(l) = scatter(normalize_rel_mag, STD);
                legendinfo{l} = ['PA ' '$\lambda = $', num2str(lambda)];
                l = l+1;
                hold on
    end

end
load('E:\Williams Lab\Turbines\AOA Estimation Research\VD data\diff_dia_rel_DD11P')
    for k = 1 : length(diff_dia_rel)
        range(k) = (max(diff_dia_rel(:,k))- min(diff_dia_rel(:,k))) / Uinf; 
        STD(k) = std(diff_dia_rel(:,k)/Uinf)./ mean(diff_dia_rel(:,k)/Uinf);
    end
    h(l) = scatter(normalize_rel_mag, range);
%     h(l) = scatter(normalize_rel_mag, STD);
    legendinfo{l} = ['VD Circle Size(1.6-2.0C) ' '$\lambda = $' num2str(lambda) ' phase'];
    hold on
l = l+1;
load('E:\Williams Lab\Turbines\AOA Estimation Research\SD data\diff_dia_rel_SW11P')
    for k = 1 : length(diff_dia_rel)
        range(k) = (max(diff_dia_rel(:,k))- min(diff_dia_rel(:,k))) / Uinf; 
        STD(k) = std(diff_dia_rel(:,k)/Uinf)./ mean(diff_dia_rel(:,k)/Uinf);
    end
    h(l) = scatter(normalize_rel_mag, range);
%     h(l) = scatter(normalize_rel_mag, STD);
    legendinfo{l} = ['SD Circle Size(1.6-2.0C) ' '$\lambda = $' num2str(lambda) ' phase',];
    hold on
l = l+1;
legend(legendinfo,'FontSize',8, 'location', 'best')
% xlim([0 360])
% set(gca,'xtick', [0:60:360])
grid on
xlabel('Normalized Relative Velocity')
ylabel('Range U_r_e_l/U_I_n_f')
% ylabel('STD')
set(gcf,'position',[540,450,800,500])
clear 'legendInfo';
%cd 'C:\Users\sqks8\MATLAB Drive\AOA Estimation Research'
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'

%% U_rel vs Range
tic
close all;
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [85 20], [105 20], 'pixels'); 
tiledlayout("flow");
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0],[0 1 1],[0 1 0]}; 
l = 1;
for i = [1 2 3 4 13 14 15 16]
    clear range STD normalize_rel_mag 
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = mean(diff_dia_rel) / Uinf;
    for k = 1 : length(diff_dia_rel)
        range(k) = (max(abs(diff_dia_rel(:,k)))- min(abs(diff_dia_rel(:,k))))/ mean(diff_dia_rel(:,k)) ; 
%         STD(k) = std(diff_dia_rel(:,k)./ mean(diff_dia_rel(:,k)));
        STD(k) = std(diff_dia_rel(:,k)./ mean(diff_dia_rel(:,k)));
    end
    
        if i == 1 || i == 2 || i == 5 || i == 6 || i == 9 || i == 11 || i == 13 || i == 15
        lambda = 1.1;
    else
        lambda = 1.9;
        end
    
    if i == 1 || i == 3
                h(l) = scatter(normalize_rel_mag, range, [], C{l}, 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(normalize_rel_mag, STD, [], C{l}, 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$TA\ Circle\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on
    elseif i == 2 || i == 4
                h(l) = scatter(normalize_rel_mag, range, [], C{l}, 'MarkerEdgeAlpha', 1); 
%                 h(l) = scatter(normalize_rel_mag, STD, [], C{l}, 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$PA\ Circle\ Size\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on
    elseif i == 5 || i == 7 
%                 h(l) = scatter(normalize_rel_mag, range, [], C{l}, '^', 'MarkerEdgeAlpha', 1); 
%                 h(l) = scatter(normalize_rel_mag, STD, [], C{l}, '^', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$TA\ Blade\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on
    elseif i == 6 || i == 8
%                 h(l) = scatter(normalize_rel_mag, range, [], C{l}, '^', 'MarkerEdgeAlpha', 1); 
%                 h(l) = scatter(normalize_rel_mag, STD, [], C{l}, '^', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$PA\ Blade\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on  
    elseif i == 9 || i == 10
%                 h(l) = scatter(normalize_rel_mag, range, [], C{l}, 'x', 'MarkerEdgeAlpha', 1); 
%                 h(l) = scatter(normalize_rel_mag, STD, [], C{l}, 'x', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$VD\ Circle\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on 
    elseif i == 15 || i == 16
                h(l) = scatter(normalize_rel_mag, range, [], C{l}, 'x', 'MarkerEdgeAlpha', 1); 
%                 h(l) = scatter(normalize_rel_mag, STD, [], C{l}, 'x', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$Rectangle\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on 
    else 
%                 h(l) = scatter(normalize_rel_mag, range, [], C{l}, 'p', 'MarkerEdgeAlpha', 1); 
%                 h(l) = scatter(normalize_rel_mag, STD, [], C{l}, 'p', 'MarkerEdgeAlpha', 1);
%                 legendinfo{l} = ['$SD\ Circle\ \lambda\ =\ $', num2str(lambda)];
%                 l = l+1;
%                 hold on 
    end

end

% 1.1
x = 1; y = 1;
clear STDT NRMT NRM VDR rangeT
for i = [2 9 11 13 15]
    clear range STD TSR
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = mean(diff_dia_rel) / Uinf;
    NRM(y,:) = normalize_rel_mag;
    y = y + 1;
    for z = 1 : height(diff_dia_rel)
        VDR(x,:) = diff_dia_rel(z,:);
        x = x + 1;
    end
end
for k = 1 : length(VDR)
    rangeT(k) = (max(abs(VDR(:,k)))- min(abs(VDR(:,k))))/ mean(VDR(:,k)) ; 
    STDT(k) = std(VDR(:,k)./ mean(VDR(:,k)));
    NRMT(k) = mean(NRM(:,k));
end

% h(l) = scatter(NRMT, STDT, '*k', 'MarkerEdgeAlpha', 1);
h(l) = scatter(NRMT, rangeT, '*k', 'MarkerEdgeAlpha', 1);
legendinfo{l} = ['$Total\ Variation\ \lambda\ =\ $', num2str(lambda)];
l = l+1;
hold on 
% 1.9
x = 1; y = 1;
clear STDT NRM NRMT VDR rangeT
for i = [4 10 12 14 16]
    clear range STD TSR 
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = mean(diff_dia_rel) / Uinf;
    NRM(y,:) = normalize_rel_mag;
    y = y + 1;
    for z = 1 : height(diff_dia_rel)
        VDR(x,:) = diff_dia_rel(z,:);
        x = x + 1;
    end
end
for k = 1 : length(VDR)
    rangeT(k) = (max(abs(VDR(:,k)))- min(abs(VDR(:,k))))/ mean(VDR(:,k)) ; 
    STDT(k) = std(VDR(:,k)./ mean(VDR(:,k)));
    NRMT(k) = mean(NRM(:,k));
end

% h(l) = scatter(NRMT, STDT, '+k', 'MarkerEdgeAlpha', 1);
h(l) = scatter(NRMT, rangeT, '+k', 'MarkerEdgeAlpha', 1);
legendinfo{l} = ['$Total\ Variation\ \lambda\ =\ $', num2str(lambda)];
l = l+1;
hold on 

legend(h,legendinfo,'FontSize',8, 'location', 'best', 'fontsize', 10)
% xlim([0 360])
% set(gca,'xtick', [0:60:360])
grid on
xlabel('U_R_e_l / U_\infty')
ylabel('Range (U_r_e_l/U_R_e_l_M)')
% ylabel('\sigma (U_R_e_l/U_R_e_l_M)')
% ylabel('\sigma / \mu')
% ylim([0 0.8])
ylim([0 2.5])
% set(gcf,'position',[540,450,800,500])
clear 'legendInfo';
%cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\4-4-2022'
cd(path)
% print(figure(1) ,'UrelCV.png', '-dpng', '-r600')
print(figure(1) ,'UrelRange.png', '-dpng', '-r600')
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'
toc
%% TSR vs STD 
close all;
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [80 20], [100 20], 'pixels');
tiledlayout("flow")
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0],[0 1 1],[0 1 0]};
l = 1;
for i = [1 2 3 4 13 14 15 16]
    clear range STD TSR STD1
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    Omega = lambda*Uinf/(r_turbine);
    u_fluid = diff_dia_ufluid;
    v_fluid = diff_dia_vfluid;
    U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
    TSR = r_turbine * Omega ./  U_local;
    TSR = mean(TSR);
    
    for k = 1 : length(diff_dia_rel)
        range(k) = (max(abs(diff_dia_rel(:,k)))- min(abs(diff_dia_rel(:,k))))/ mean(diff_dia_rel(:,k)) ; 
%         STD(k) = std(diff_dia_rel(:,k)./ mean(diff_dia_rel(:,k)));
        STD(k) = std(diff_dia_rel(:,k)./ mean(diff_dia_rel(:,k)));
    end
    
    if i == 1 || i == 2 || i == 5 || i == 6 || i == 9 || i == 11 || i == 13 || i == 15
        lambda = 1.1;
    else
        lambda = 1.9;
    end
    
    if i == 1 || i == 3
              h(l) = scatter(TSR, range, [], C{l}, 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(TSR, STD, [], C{l}, 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$TA\ Circle\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on
    elseif i == 2 || i == 4
              h(l) = scatter(TSR, range, [], C{l}, 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(TSR, STD, [], C{l}, 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$PA\ Circle\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on
    elseif i == 5 || i == 7 
%               h(l) = scatter(TSR, range, [], C{l}, '^', 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(TSR, STD, [], C{l}, '^', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$TA\ Blade\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on
    elseif i == 6 || i == 8
%               h(l) = scatter(TSR, range, [], C{l}, '^', 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(TSR, STD, [], C{l}, '^', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$PA\ Blade\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on  
    elseif i == 9 || i == 10
%                h(l) = scatter(TSR, range, [], C{l}, 'x', 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(TSR, STD, [], C{l}, 'x', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$VD\ Circle\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on 
    elseif i == 15 || i == 16
               h(l) = scatter(TSR, range, [], C{l}, 'x', 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(TSR, STD, [], C{l}, 'x', 'MarkerEdgeAlpha', 1);
                legendinfo{l} = ['$PA\ Rectangle\ \lambda\ =\ $', num2str(lambda)];
                l = l+1;
                hold on 
    else
%                h(l) = scatter(TSR, range, [], C{l}, 'p', 'MarkerEdgeAlpha', 1);
%                 h(l) = scatter(TSR, STD, [], C{l}, 'p', 'MarkerEdgeAlpha', 1);
%                 legendinfo{l} = ['$SD\ Circle\ \lambda\ =\ $', num2str(lambda)];
%                 l = l+1;
%                 hold on 
    end
end
% 1.1
x = 1; y = 1;
clear STDT TSRT TSRTT VDR rangeT
for i = [2 9 11 13 15]
    clear range STD TSR
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    Omega = lambda*Uinf/(r_turbine);
    u_fluid = diff_dia_ufluid;
    v_fluid = diff_dia_vfluid;
    U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
    TSR = r_turbine * Omega ./  U_local;
    TSR = mean(TSR);
    TSRT(y,:) = TSR;
    y = y + 1;
    for z = 1 : height(diff_dia_rel)
        VDR(x,:) = diff_dia_rel(z,:);
        x = x + 1;
    end
end
for k = 1 : length(VDR)
    rangeT(k) = (max(abs(VDR(:,k)))- min(abs(VDR(:,k))))/ mean(VDR(:,k)) ; 
    STDT(k) = std(VDR(:,k)./ mean(VDR(:,k)));
    TSRTT(k) = mean(TSRT(:,k));
end

% h(l) = scatter(TSRTT, STDT, '*k', 'MarkerEdgeAlpha', 1);
h(l) = scatter(TSRTT, rangeT, '*k', 'MarkerEdgeAlpha', 1);
legendinfo{l} = ['$Total\ Variation\ \lambda\ =\ $', num2str(lambda)];
l = l+1;
hold on 
% 1.9
x = 1; y = 1;
clear STDT TSRT TSRTT VDR rangeT
for i = [4 10 12 14 16]
    clear range STD TSR 
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    Omega = lambda*Uinf/(r_turbine);
    u_fluid = diff_dia_ufluid;
    v_fluid = diff_dia_vfluid;
    U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
    TSR = r_turbine * Omega ./  U_local;
    TSR = mean(TSR);
    TSRT(y,:) = TSR;
    y = y + 1;
    for z = 1 : height(diff_dia_rel)
        VDR(x,:) = diff_dia_rel(z,:);
        x = x + 1;
    end
end
for k = 1 : length(VDR)
    rangeT(k) = (max(abs(VDR(:,k)))- min(abs(VDR(:,k))))/ mean(VDR(:,k)) ; 
    STDT(k) = std(VDR(:,k)./ mean(VDR(:,k)));
    TSRTT(k) = mean(TSRT(:,k));
end

% h(l) = scatter(TSRTT, STDT, '+k', 'MarkerEdgeAlpha', 1);
h(l) = scatter(TSRTT, rangeT, '+k', 'MarkerEdgeAlpha', 1);
legendinfo{l} = ['$Total\ Variation\ \lambda\ =\ $', num2str(lambda)];
l = l+1;
hold on 


legend(h, legendinfo, 'FontSize', 10, 'location', 'best')
grid on
xlabel('TSR_l')
ylabel('Range (U_R_e_l/U_R_e_l_M)')
% ylabel('\sigma(U_R_e_l/U_R_e_l_M)')
% ylabel('\sigma / \mu')
% ylim([0 0.8])
ylim([0 2.5])
% set(gcf,'position',[540,450,800,500])
% title('STD of Normalized Relative Velocity with Circle Size v.s. Local Tip Speed Ratio')
% title('Range of Normalized Relative Velocity with Circle Size v.s. Local Tip Speed Ratio')
clear 'legendInfo';
%cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\4-4-2022'
cd(path)
% print(figure(1) ,'TSRCV.png', '-dpng', '-r600')
print(figure(1) ,'TSRRange.png', '-dpng', '-r600')
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'

%% Local TSR 1.1
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
tiledlayout("flow")
l = 1;
for i = [1 2 5 6 13 15] %i = [1 2 5 6 9 11 13 15], i = [3 4 7 8 10 12 14 16] 
    clear theta TSR
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    if i == 1 || i == 3
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$TA\ Circle$'];
                hold on
            end
            l = l+1;
    elseif i == 2 || i == 4
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$PA\ Circle$'];
                hold on
            end
            l = l+1;
    elseif i == 5 || i == 7
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$TA\ Blade$'];
                hold on
            end
            l = l+1;
    elseif i == 6 || i == 8
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$PA\ Blade$'];
                hold on
            end
            l = l+1;
    elseif i == 9 || i == 10
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR) 
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$PA\ Circle\ VD$'];
                hold on 
            end
            l = l+1;
    elseif i == 11 || i == 12 
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$PA\ Circle\ SD$'];
                hold on 
            end
            l = l+1;
    elseif i == 13 || i == 14
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                legendinfo{l} = ['$PA\ Reference\ Points$'];
                hold on 
            end
            l = l+1;
    
    elseif i == 17
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$IN\ Circle$'];
                hold on 
            end
            l = l+1;
    else 
        Omega = lambda*Uinf/(r_turbine);
        u_fluid = diff_dia_ufluid;
        v_fluid = diff_dia_vfluid;
        U_local = sqrt(u_fluid.^2 + v_fluid.^2); 
        TSR = r_turbine * Omega ./  U_local;
            for k = 1 : height(TSR)
                h(l) = plot(theta, TSR(k,:), 'color', C{l});
                h(l).Color(4) = 0.2 * k;
                legendinfo{l} = ['$PA\ Rectangle$'];
                hold on 
            end
            l = l+1;
    end

end

h(l) = yline(lambda, '--k', 'LineWidth', 3);
legendinfo{l} = ['$\lambda\ =\ $', num2str(lambda)];
legend(legendinfo, 'location', 'best', 'FontSize', 10)
xlim([0 360])
ylim([0.5 3])
% ylim([0 10])
set(gca,'xtick',[0:60:360])
grid on
% title('AOA v.s. Blade position')
xlabel('$\theta$','Interpreter','latex')
ylabel('$TSR_{l}$','Interpreter','latex')
% set(gcf,'position',[270,225,800,500])
%cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\4-4-2022'
cd(path)
print(figure(1) ,'TSR 1.1.png', '-dpng', '-r600')
% print(figure(1) ,'TSR 1.9.png', '-dpng', '-r600')
cd 'E:\Williams Lab\Turbines\AOA Estimation Research'

