% clear all; close all;
% a = imread('binary.png');
% a = a(:,:,3);
% bw = a < 150;
a = binary(1).plot;
a = rot90(a);
imshow(a)
CC = bwconncomp(a,4)

stats = regionprops('table',CC,'Centroid','MajorAxisLength','MinorAxisLength')
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
diameters(1) = 0;
radii = diameters/2;
[M,I] = max(diameters)
hold on
viscircles(centers(I,:),radii(I))
hold off
