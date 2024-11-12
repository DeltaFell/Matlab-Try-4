%creates a rectangle given certain parameters
function [x,y] = crect(o,w,h)
    w = w/2;
    h = h/2;
    x = [o(1)+w;o(1)-w;o(1)-w;o(1)+w;o(1)+w];
    y = [o(2)+h;o(2)+h;o(2)-h;o(2)-h;o(2)+h];
end