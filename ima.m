J = imread('image.jpg');
figure;
imshow(J);
[P, rect] = imcrop(J);
imshow(Img0);
level = graythresh(P);
I = imbinarize(P, level);
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
imshow(I1);
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
%imwrite(m, 'temp.jpg');
