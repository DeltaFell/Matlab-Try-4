clear all; close all; clc

load("G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\Vorticity_19P.mat")
load("G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\X_19P")
load("G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\Y_19P")
load("G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\theta_19P")
Vorticity_or = Vorticity;
%%
for i = 1:length(Vorticity);
    contor = plot_foil(theta(i),1.05);
    in = inpolygon(X,Y,contor(:,1),contor(:,2));
    num = numel(X(in))
     Vorticity(i).vort = Vorticity_or(i).vort.*~in;
     ds = linspace(-4,4,400);
     xs = meshgrid(ds,ds);
    Vorticity(i).vort = interp2(X.',Y.',Vorticity(i).vort,xs,xs.');
    Vorticity(i).vort = interp2(xs,xs.',Vorticity(i).vort,X.',Y.');
     %surf(X,Y,Vorticity(35).vort)
end
save("G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\Vorticity_19P.mat","Vorticity")
save("G:\Shared drives\Williams Lab\Turbines\AOA Estimation Research\Calculation Data\Vorticity_19A.mat","Vorticity")