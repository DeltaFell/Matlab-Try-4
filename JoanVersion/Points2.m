function [in,A] = Points2(qc,n,m,X,Y)
% xi = qc(1);
% yi = qc(2);
% 
% xo = xi+n;
% yo = yi+m;

P1 = qc+[m,n];
P2 = qc+[m,-n];
h1 = X == X(P1(1));
h2 = Y == Y(:,P1(2));
H1 = h1 & h2 ~= 0;

h1 = X == X(P2(1));
h2 = Y == Y(:,P2(2));
H2 = h1 & h2 ~= 0;
in = H1+H2;
A = [P1;P2];
end