function [in,A] = Points2(qc,n,m,X,Y)
% qc - quarterchord point
% n - spanwise distance from quarterchord
% m - streamwise distance from quarterchord
% xi = qc(1);
% yi = qc(2);
% 
% xo = xi+n;
% yo = yi+m;

P1 = qc-[m;n];
P2 = qc-[m;-n];
P11 = round((P1+4)*12.5);
P22 = round((P2+4)*12.5);
h1 = X == X(P11(1),:);
h2 = Y == Y(:,P11(2));
H1 = h1 & h2 ~= 0;

h1 = X == X(P22(1),:);
h2 = Y == Y(:,P22(2));
H2 = h1 & h2 ~= 0;
in = H1+H2;
A = [P1,P2];
end