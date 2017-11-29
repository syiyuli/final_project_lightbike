function [ pixel_vector, rows, columns ] = flattenImage( RGB )
%FLATTENIMAGE Flattens image into uint32 0x00rrggbb vector
%   Loads image, gets rgb values, and puts each pixel into a vector
%   Returns the rows and columns to allow lossless reshaping
    
    % concatenate RGB values;
    RGB_cat = concatenateRGBImage(RGB);
    
    % Reshape RGB into 3 x N matrix (N is rows*columns)
    rows = size(RGB, 1);
    columns = size(RGB, 2);
    N = rows * columns;
    RGB_flat = reshape(RGB_cat', N, 1);

    pixel_vector = RGB_flat;
end

