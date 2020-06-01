clear;
J = imread('temp.jpg');
figure;
imshow(J);
P = J;
level = graythresh(P);
I = imbinarize(P, level);
I = bwlabel(I);
figure;
imshow(I);
hold on;
stats = regionprops(I, {'Area', 'ConvexHull', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid'});
A = [];

for i = 1:length(stats)
    A = [A stats(i).Area];
end

[mA, ind] = max(A);
I1 = I;
I1(find(I ~= ind)) = 0;
figure;
imshow(I);
hold on;
temp = stats(ind).ConvexHull;
t = linspace(0, 2 * pi, 500);
c1 = stats(ind).Centroid;
a1 = stats(ind).MajorAxisLength;
b1 = stats(ind).MinorAxisLength;
d1 = stats(ind).Eccentricity;
x1 = c1(1) + d1 * b1 * cos(t);
y1 = c1(2) + d1 * a1 * sin(t);
m = plot(x1, y1, 'b-');

x2 = x1(1, 1);
y2 = y1(1, 1);
x3 = x1(1, 30);
y3 = y1(1, 30);
x4 = x1(1, 80);
y4 = y1(1, 80);
a = 2 * (x3 - x2);
b = 2 * (y3 - y2);
n = (x3 * x3 + y3 * y3 - x2 * x2 - y2 * y2);
d = 2 * (x4 - x3);
e = 2 * (y4 - y3);
f = (x4 * x4 + y4 * y4 - x3 * x3 - y3 * y3);
x0 = (b * f - e * n) / (b * d - e * a + eps)
y0 = (d * n - a * f) / (b * d - e * a + eps)
r0 = sqrt((x0 - x2) * (x0 - x2) + (y0 - y2) * (y0 - y2))
S = r0 * r0 * pi
