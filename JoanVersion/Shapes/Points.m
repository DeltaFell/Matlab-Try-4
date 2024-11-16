%returns the logical array for the reference points
% in - logical array
% A - coords
%
% theta - current angle
% m - tangengtial offset from quarter chord
% n - normal offset
% R - turbine radius
% X,Y - X and Y arrays

%Joan Matutes 8/16/24
function [in,A] = Points(theta,m,n,R,X,Y)
thetab = 365-theta;
xi = R*cosd(thetab); % finding the quarter chord
yi = R*sind(thetab);
xi = (xi+4)*12.5; % scaling up to 100x100
yi = (yi+4)*12.5;
o = [xi,yi];
o = o + m*[cosd(thetab+90),sind(thetab+90)]; % offsetting tangentially
p1 = o+n*[cosd(thetab),sind(thetab)];
p2 = o-n*[cosd(thetab),sind(thetab)];
P1 = round(p1);
h1 = X == X(P1(1));
h2 = Y == Y(:,P1(2));
H1 = h1 & h2 ~= 0;

P2 = round(p2);
h1 = X == X(P2(1));
h2 = Y == Y(:,P2(2));
H2 = h1 & h2 ~= 0;
in = H1+H2;
A = [p1;p2];
end