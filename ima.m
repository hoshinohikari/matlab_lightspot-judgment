reource_p = imread('image.jpg');
reource_p_sub = imread('temp.jpg');
[m, n] = size(reource_p);
[m0, n0] = size(reource_p_sub);
result = zeros(m - m0 + 1, n - n0 + 1);
vec_sub = double(reource_p_sub(:));
norm_sub = norm(vec_sub);

for i = 1:m - m0 + 1

    for j = 1:n - n0 + 1
        subMatr = reource_p(i:i + m0 - 1, j:j + n0 - 1);
        vec = double(subMatr(:));
        result(i, j) = vec' * vec_sub / (norm(vec) * norm_sub + eps);
    end

end

[iMaxPos, jMaxPos] = find(result == max(result(:)));
figure,
subplot(121); imshow(reource_p_sub), title('temp');
subplot(122);
imshow(reource_p);
title('result'),
hold on
plot(jMaxPos, iMaxPos, '*');
plot([jMaxPos, jMaxPos + n0 - 1], [iMaxPos, iMaxPos]);
plot([jMaxPos + n0 - 1, jMaxPos + n0 - 1], [iMaxPos, iMaxPos + m0 - 1]);
plot([jMaxPos, jMaxPos + n0 - 1], [iMaxPos + m0 - 1, iMaxPos + m0 - 1]);
plot([jMaxPos, jMaxPos], [iMaxPos, iMaxPos + m0 - 1]);

P = imcrop(reource_p, [jMaxPos, iMaxPos, n0 - 1, m0 - 1]);
figure;
imshow(P);

level = graythresh(P);
I = imbinarize(P, level);
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
t = linspace(0, 2 * pi, 500);
c1 = stats(ind).Centroid;
a1 = stats(ind).MajorAxisLength;
b1 = stats(ind).MinorAxisLength;
d1 = stats(ind).Eccentricity;
x1 = c1(1) + d1 * b1 * cos(t);
y1 = c1(2) + d1 * a1 * sin(t);
m = plot(x1, y1, 'b-');
