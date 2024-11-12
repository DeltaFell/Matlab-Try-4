function [in,A] = Circle2(qc,r,X,Y)
thet = [0:pi/32:2*pi,0]';
xi = qc(1);
yi = qc(2);
xv = r*cos(thet)+xi;
yv = r*sin(thet)+yi;
in = inpolygon(X,Y,xv,yv);
A = [xv,yv];
end