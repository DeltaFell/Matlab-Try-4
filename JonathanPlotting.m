clear all; close all;
% cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
% result_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\5-3-2022';
result_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\5-3-2022(2)';
% data_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\DD data'
data_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\SD data';
run('NameProcessing')

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


TSR = [11 0 19];

vec = [100;50;0];
raw = [0 0.4470 0.7410; 1 1 1;0.8500 0.3250 0.0980];
N = 16;
map = interp1(vec,raw,linspace(100,0,N),'pchip');
map = abs(map);

for num = [1]
    for j = 1:length(variable_name(num).name)
        name = (variable_name(num).name(j));
        load(name.name)
    end
    %cd 'E:\Williams Lab\Turbines\AOA Estimation Research'
    cd 'E:\Williams Lab\Turbines\AOA Estimation Research'
end
%%
theta_list  = [1 round(length(theta)/6) round(length(theta)/3)];
chord = 0.0406;

for i = 1:length(theta_list)
    index = theta_list(i);
    Ufieldd = U_field(index).u;
    Vfieldd = V_field(index).v;
    %Ufieldd = SD_U_field(index).u;
    %Vfieldd = SD_V_field(index).v;
    Uavgd = Uavg;
    Vavgd = Vavg;
    
    
    %     vort_max = 40;
    %     for a = 1:length(X)
    %         for b = 1:length(X)
    %             if Vorticity(index).vort(a,b)>vort_max
    %                 Vorticity(index).vort(a,b) = vort_max;
    %             else if Vorticity(index).vort(a,b)<-vort_max
    %                     Vorticity(index).vort(a,b) = -vort_max;
    %                 end
    %             end
    %         end
    %     end
    figure(1)
    %ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels')
    tiledlayout("flow");
    %vel_mag = hypot(Ufieldd,Vfieldd);
    pcolor(X,Y,Vorticity(index).vort)
    
    box on
    set(gca,'layer','top')
    hold on
    %pcolor(ax1,X,Y,vel_mag)
    shading interp
    
    %load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\X_11P.mat')
    %load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\Y_11P.mat')
    
    Xd = X;
    Yd = Y;
    while length(Xd) >  25
        Xd = Xd(1:2:end,1:2:end);
        Yd = Yd(1:2:end,1:2:end);
        Ufieldd = Ufieldd(1:2:end,1:2:end);
        Vfieldd = Vfieldd(1:2:end,1:2:end);
        Uavgd = Uavgd(1:2:end,1:2:end);
        Vavgd = Vavgd(1:2:end,1:2:end);
    end
    scalefactor = 0.2;
    q = quiver(Xd,Yd,Ufieldd.*scalefactor,Vfieldd.*scalefactor,'linewidth',1,'color','black','Autoscale','off');
    %quiverC2D(Xd,Yd,Ufieldd,Vfieldd,'gray',1,1000,'linewidth',1)
    foil_coords = plot_foil(theta(index),1);
    fill(foil_coords(:,1),foil_coords(:,2),[0.6 0.6 0.6],'LineStyle','none')
    foil_coords = plot_foil(theta(index)+180,1);
    fill(foil_coords(:,1),foil_coords(:,2),[0.6 0.6 0.6],'LineStyle','none')
    axis equal
    xlim([-4 4])
    ylim([-4 4])
    xlabel('$x/c$', 'Interpreter','latex')
    ylabel('$y/c$', 'Interpreter','latex')
    
    colormap(map);
    
    if num == 1
        caxis([-20 20])
    else
        caxis([-20 20])
    end
    
    % print(figure(1), fullfile(result_folder,['Phase Velocity Field ' num2str(TSR(num)) ' ' num2str(theta(index)) '.png']), '-dpng', '-r600' )
    % saveas(figure(1),fullfile(result_folder,['Phase Velocity Field ' num2str(TSR(num)) ' ' num2str(theta(index)) '.fig']))
    h = colorbar;
    ylabel(h,'Normalized Vorticity','Rotation',-90,'position',[4.5 0], 'Interpreter','latex');
    hColourbar.Label.Position(1) =100;
    print(gcf, fullfile(result_folder,['Velocity Field ' num2str(TSR(num)) ' ' num2str(theta(index)) '.png']), '-dpng', '-r600' )
    saveas(gcf,fullfile(result_folder,['Velocity Field ' num2str(TSR(num)) ' ' num2str(theta(index)) '.fig']))
end

figure(2)
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
tiledlayout("flow")
hold on
xlim([-4 4])
ylim([-4 4])
xlabel('x')
ylabel('y')
Uinf = 0.91;
avg_vort = curl(Uavg./chord./Uinf,Vavg./chord./Uinf);

pcolor(X,Y,avg_vort)
shading interp
box on
set(gca,'layer','top')
raw = [0 0.4470+(1-0.4470)/3 0.7410+(1-0.7410)/3; 1 1 1; 0.8500+(1-0.8500)/3 0.3250+(1-0.3250)/3 0.0980+(1-0.0980)/3];
N = 16;
map2 = interp1(vec,raw,linspace(100,0,N),'pchip');
map2 = abs(map2);
colormap(map2)
caxis([-1 1])
q = quiver(Xd,Yd,Uavgd*scalefactor,Vavgd*scalefactor,'color','black','linewidth',1,'Autoscale','off');
axis equal
xlim([-4 4])
ylim([-4 4])
xlabel('$x/c$', 'Interpreter','latex')
ylabel('$y/c$', 'Interpreter','latex')
h = colorbar;
ylabel(h,'Normalized Vorticity','Rotation',-90,'position',[4.5 0], 'Interpreter','latex');
hColourbar.Label.Position(1) =100;
print(figure(2), fullfile(result_folder,['Average Velocity Field ' num2str(TSR(num)) '.png']), '-dpng', '-r600' )
saveas(figure(2),fullfile(result_folder,['Average Velocity Field ' num2str(TSR(num)) '.fig']))


%%
clear all; close all;
%cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
%result_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\5-29-2022';
result_folder = 'E:\Williams Lab\Turbines\AOA Estimation Research\Results\5-29-2022(2)';
run('NameProcessing')
set(0,'defaulttextinterpreter','latex')
TSR = [11 0 19];

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
Xrange = [-2.5 1.5];
Yrange = [-1.5 1.5];
XYratio = (Xrange(2)-Xrange(1))/(Yrange(2)-Yrange(1));
Xnum = 25

vec = [100;50;0];
raw = [0 0.4470 0.7410; 1 1 1;0.8500 0.3250 0.0980];
N = 16;
map = interp1(vec,raw,linspace(100,0,N),'pchip');
map = abs(map);

chord = 0.0406; % Chord length in m
r_turbine = 0.172/2; % Radius of the turbine in m
r_circle_center = r_turbine/chord * 2 * 0.482 ;
[Xnew,Ynew] = meshgrid(linspace(Xrange(1),Xrange(2),Xnum*XYratio),linspace(Yrange(1),Yrange(2),Xnum));



for num = [1]
    for j = 1:length(variable_name(num).name)
        name = (variable_name(num).name(j));
        load(name.name)
    end
    cd 'E:\Williams Lab\Turbines\AOA Estimation Research'
    
    if num == 1
        %theta_list = 1:length(theta);
        theta_list  = [1 16 22 25 27 32 38 42 47];
    else
        %theta_list = 1:length(theta);
        theta_list  = [70 18 24 28 30 35 43 47 53];
    end
    
    for i = 1:length(theta_list)
        index = theta_list(i);
        
        [Xvort,Yvort] = meshgrid(linspace(Xrange(1),Xrange(2),50*XYratio),linspace(Yrange(1),Yrange(2),50));



        Vortnew = grid_rotation(theta(index),griddedInterpolant(X,Y,Vorticity(index).vort),Xrange,Yrange,50);
        if num == 1
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\blade_velocity_11P')
        else
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\blade_velocity_19P')
        end
        
        vort_max = 70;
        for a = 1:size(Vortnew,1)
            for b = 1:size(Vortnew,2)
                if Vortnew(a,b)>vort_max || Vortnew(a,b) < -vort_max
                    Vortnew(a,b) = 0;
                end
            end
        end
        
        
        close
        figure(1)
        %ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 50], 'pixels');
        tiledlayout("flow")
        pcolor(Xvort,Yvort,Vortnew)
        hold on
        box on
        set(gca,'layer','top')
        shading interp
        colormap(map);
        if num == 1
            caxis([-30 30])
        else
            caxis([-30 30])
        end
        
        color0 = zeros(7,3);
        color0(:,1) = linspace(1,0.2,7);
        color0(:,2) = linspace(1,0.2,7);
        color0(:,3) = linspace(1,0.2,7);
        color0 = color0(3:7,:);
        
        color1 = zeros(7,3);
        color1(:,1) = linspace(1,0.929,7);
        color1(:,2) = linspace(1,0.694,7);
        color1(:,3) = linspace(1,0.125,7);
        color1 = color1(3:7,:);
        
        color2 = zeros(7,3);
        color2(:,1) = linspace(1,0.3010,7);
        color2(:,2) = linspace(1,0.7450,7);
        color2(:,3) = linspace(1,0.9330,7);
        color2 = color2(3:7,:);
        
        color3 = zeros(7,3);
        color3(:,1) = linspace(1,0.494,7);
        color3(:,2) = linspace(1,0.184,7);
        color3(:,3) = linspace(1,0.556,7);
        color3 = color3(3:7,:);
        
        color4 = zeros(7,3);
        color4(:,1) = linspace(1,0.85,7);
        color4(:,2) = linspace(1,0.325,7);
        color4(:,3) = linspace(1,0.098,7);
        color4 = color4(3:7,:);
        
        radius = [1.6 1.7 1.8 1.9 2]./2;
        sizes = [1 1.3 1.6 1.9 2.2];
        
        for a = 1:5
            viscircles([0 0],radius(a),'color',color0(a,:),'linewidth',1.5)
            foil = plot_foil(0,sizes(a));
            foil(:,2) = foil(:,2) - r_circle_center;
            fill(foil(:,1),foil(:,2),color0(a,:),'FaceAlpha',0,'EdgeAlpha',1-color0(a,1),'linewidth',1.5)
            rectangle('position',[-sizes(a)-0.1, -1 0.2 2],'Edgecolor',color0(a,:),'linewidth',1.5)
        end
        scatter([-0.5 -0.5],[1 -1],'MarkerEdgeColor','k','linewidth',1.5)
        Uraw = grid_rotation(theta(index),griddedInterpolant(X,Y,U_field(index).u),Xrange,Yrange,Xnum) - blade_velocity(1,index);
        Vraw = grid_rotation(theta(index),griddedInterpolant(X,Y,V_field(index).v),Xrange,Yrange,Xnum) - blade_velocity(2,index);
        R=[cosd(-theta(index)) -sind(-theta(index)); sind(-theta(index)) cosd(-theta(index))];
        UV = [Uraw(:) Vraw(:)]*R';
        Unew = reshape(UV(:,1), size(Uraw,1), []);
        Vnew = reshape(UV(:,2), size(Vraw,1), []);
        % title(['Theta = ' num2str(theta(i))])
        scalefactor = 0.05;
        q = quiver(Xnew,Ynew,Unew.*scalefactor,Vnew.*scalefactor,'linewidth',1,'color','black','Autoscale','off');
        
        %
%         flow_data(i).theta = theta(i);
%         flow_data(i).X = Xvort;
%         flow_data(i).Y = Yvort;        
%         flow_data(i).u = Unew;
%         flow_data(i).v = Vnew;
%         flow_data(i).vort = Vortnew;

        %

        foil_coords = plot_foil(0,1);
        foil_coords(:,2) = foil_coords(:,2) - r_circle_center;
        fill(foil_coords(:,1),foil_coords(:,2),[0.6 0.6 0.6],'LineStyle','none')
        axis equal
        xlim(Xrange)
        ylim(Yrange)
        xlabel('$x/c$')
        ylabel('$y/c$')
        title(['$\theta$ = ' num2str(theta(index))])
        hb = colorbar;
        ylabel(hb,'Normalized Vorticity','Rotation',-90,'position',[4.5 0], 'Interpreter','latex');
        %hColourbar.Label.Position(1) =100;
        
        if num == 1
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_11P.mat')
            Ufluid = diff_dia_ufluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_11Pb.mat')
            UfluidPb = diff_dia_ufluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_11Pp.mat')
            UfluidPp = diff_dia_ufluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_11Pr.mat')
            UfluidPr = diff_dia_ufluid;
            
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_11P.mat')
            Vfluid = diff_dia_vfluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_11Pb.mat')
            VfluidPb = diff_dia_vfluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_11Pp.mat')
            VfluidPp = diff_dia_vfluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_11Pr.mat')
            VfluidPr = diff_dia_vfluid;
            
        else
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_19P.mat')
            Ufluid = diff_dia_ufluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_19Pb.mat')
            UfluidPb = diff_dia_ufluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_19Pp.mat')
            UfluidPp = diff_dia_ufluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_ufluid_19Pr.mat')
            UfluidPr = diff_dia_ufluid;
            
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_19P.mat')
            Vfluid = diff_dia_vfluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_19Pb.mat')
            VfluidPb = diff_dia_vfluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_19Pp.mat')
            VfluidPp = diff_dia_vfluid;
            load('E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\diff_dia_vfluid_19Pr.mat')
            VfluidPr = diff_dia_vfluid;
        end
        
        for row = 1:5;
            Ufluid(row,:)  = Ufluid(row,:) - blade_velocity(1,:);
            Vfluid(row,:)  = Vfluid(row,:) - blade_velocity(2,:);
            
            UfluidPb(row,:)  = UfluidPb(row,:) - blade_velocity(1,:);
            VfluidPb(row,:)  = VfluidPb(row,:) - blade_velocity(2,:);
            
            UfluidPr(row,:)  = UfluidPr(row,:) - blade_velocity(1,:);
            VfluidPr(row,:)  = VfluidPr(row,:) - blade_velocity(2,:);
        end
        
        UfluidPp(1,:)  = UfluidPp(1,:) - blade_velocity(1,:);
        VfluidPp(1,:)  = VfluidPp(1,:) - blade_velocity(2,:);
        
        if num == 1
            scale = 0.5
        else
            scale = 0.5
        end
        
        l = 1;
        for a = 1:5
            u = Ufluid(a,index);
            v = Vfluid(a,index);
            fluid = R*[u; v];
            h(l) = quiver(0,0,fluid(1),fluid(2),'color',color1(a,:),'AutoScaleFactor',scale,'linewidth',2);
            legendinfo{l} = ['$Phased Circle$'];
            hold on
        end
        l = l + 1;
        
        for a = 1:5
            u = UfluidPb(a,index);
            v = VfluidPb(a,index);
            fluid = R*[u; v];
            h(l) = quiver(0,0,fluid(1),fluid(2),'color',color2(a,:),'AutoScaleFactor',scale,'linewidth',2);
            legendinfo{l} = ['$Phased Blade$'];
            hold on
        end
        l = l + 1;
        
        for a = 1:1
            u = UfluidPp(a,index);
            v = VfluidPp(a,index);
            fluid = R*[u; v];
            h(l) = quiver(0,0,fluid(1),fluid(2),'color',color3(5,:),'AutoScaleFactor',scale,'linewidth',2);
            legendinfo{l} = ['$Phased Reference Point$'];
            hold on
        end
        l = l + 1;
        
        for a = 1:5
            u = UfluidPr(a,index);
            v = VfluidPr(a,index);
            fluid = R*[u; v];
            h(l) = quiver(0,0,fluid(1),fluid(2),'color',color4(a,:),'AutoScaleFactor',scale,'linewidth',2);
            legendinfo{l} = ['$Phased Rectangle$'];
            hold on
        end
        l = l + 1;
        
        
        
        legend(legendinfo,'FontSize',8,'location','southeast')
        print(gcf, fullfile(result_folder,['Rotated phase ' num2str(TSR(num)) ' ' num2str(theta(index)) '.png']), '-dpng', '-r600' )
        %saveas(gcf,fullfile(result_folder,['Rotated phase ' num2str(TSR(num)) ' ' num2str(theta(index)) '.fig']))
        
        hold off
    end
end
% save('1.9 Blade Centric.mat','flow_data')