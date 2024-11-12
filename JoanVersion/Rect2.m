function [in,A] = Rect2(qc,w,h,X,Y)
[x,y] = crect(qc,w,h);
in = inpolygon(X,Y,x,y);
A = [x,y];
end