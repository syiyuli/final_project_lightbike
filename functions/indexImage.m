function [ image_data, rows, cols ] = indexImage( filename, colorMap )
%% Index image with colormap as layer of indirection

%% load and flatten image
RGB = rgbImage(filename);
[RGB_flat, rows, cols] = flattenImage(RGB);

%% Create level of indirection through ColorMap
N = rows*cols;
image_data = zeros(N, 1,'uint32');

for i = 1:N
    image_data(i) = colorMap(RGB_flat(i));
end

end

