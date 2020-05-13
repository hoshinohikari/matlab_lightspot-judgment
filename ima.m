J = imread('image.jpg');
figure;
imshow(J);
[P, rect] = imcrop(J);
imshow(P);
imwrite(P, 'temp.jpg');

temp_img = imread('temp.jpg');
src_img = imread('image.jpg');

temp = graythresh(temp_img); temp = im2double(temp);
src = graythresh(src_img); src = im2double(src);

figure('name', 'result'),
subplot(1, 2, 1), imshow(temp_img), title('temp'),

tempSize = size(temp);
tempHeight = tempSize(1); tempWidth = tempSize(2);
srcSize = size(src);
srcHeight = srcSize(1); srcWidth = srcSize(2);

srcExpand = padarray(src, [tempHeight - 1 tempWidth - 1], 'post');

distance = zeros(srcSize);

for height = 1:srcHeight

    for width = 1:srcWidth
        tmp = srcExpand(height:(height + tempHeight - 1), width:(width + tempWidth - 1));
        distance(height, width) = sum(sum(temp' * tmp - 0.5 .* (tmp' * tmp)));
    end

end

maxDis = max(max(distance));
[x, y] = find(distance == maxDis);

subplot(1, 2, 2), imshow(src_img); title('Æ¥Åä½á¹û'), hold on
rectangle('Position', [x y tempWidth tempHeight], 'LineWidth', 2, 'LineStyle', '--', 'EdgeColor', 'r'),
hold off

level = graythresh(P);
I = imbinarize(P, level);
%L = bwlabel(I);
L = I;
stats = regionprops(L, {'Area', 'ConvexHull', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid'});
A = [];

for i = 1:length(stats)
    A = [A stats(i).Area];
end

[mA, ind] = max(A);
I1 = I;
I1(find(L ~= ind)) = 0;
figure;
imshow(I1);
hold on;
temp = stats(ind).ConvexHull;
t = linspace(0, 2 * pi, 7);
c1 = stats(ind).Centroid;
a1 = stats(ind).MajorAxisLength;
b1 = stats(ind).MinorAxisLength;
d1 = stats(ind).Eccentricity;
x1 = c1(1) + d1 * b1 * cos(t);
y1 = c1(2) + d1 * a1 * sin(t);
m = plot(x1, y1, 'b-');
