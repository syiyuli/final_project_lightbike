%% ColorMap Maker
% Combs through an image file or set of image files and builds a color map
% from it

clear; format hex;

%% Iterate across files
files = {'asset16.png'};

colorMap = containers.Map('KeyType', 'uint32', 'ValueType', 'uint32');
value_iter = 0;

for i = 1:length(files)
    % load image
    filename = files{i};
    
    RGB_image = rgbImage(filename);
    [RGB_flat, rows, cols] = flattenImage(RGB_image);
        
    % Trim duplicate elements
    RGB_unique = unique(RGB_flat, 'rows');

    % "Concatenate" RGB colors to uint32 (0x00rrggbb)
    N_unique = length(RGB_unique);

    % add to map from colormap
    currMap = containers.Map(uint32(RGB_unique), uint32(1:N_unique));
    keySet = keys(currMap);

    % iterate across all keys and add new values
    for k_index = 1:length(keySet)
        k = keySet{k_index};
        hasKey = isKey(colorMap, k);
        
        if(~hasKey)
            colorMap(k) = value_iter;
            value_iter = value_iter + 1;
        end
    end
end

%% Save final products
colorToIndexMap = colorMap;
indexToColorMap = containers.Map(values(colorMap), keys(colorMap));
save("ColorMap", 'colorToIndexMap', 'indexToColorMap');