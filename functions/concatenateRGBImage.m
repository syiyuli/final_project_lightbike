function [ RGB_concat ] = concatenateRGBImage( RGB_image )

[m, n, dummy] = size(RGB_image);
RGB_concat = zeros(m, n, 'uint32');

%% Split image into 3 8-bit colors
R = RGB_image(:, :, 1);
G = RGB_image(:, :, 2);
B = RGB_image(:, :, 3);
for i = 1:size(RGB_image, 1)
    for j = 1:size(RGB_image, 2)
        % Concatenate into 32 bits
        RGB_concat(i, j) = typecast([R(i, j), G(i, j), B(i, j), 0], 'uint32');
    end
end

end