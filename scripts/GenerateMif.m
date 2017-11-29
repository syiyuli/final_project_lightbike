%% Generate Mif file
clear; format short;

%% Data Constants
load('ColorMap')

%% Make Color Mapping MIF file
color_depth = 2^8;
color_width = 24;
color_filename = 'color_data.mif';
color_keys = cell2mat(keys(colorToIndexMap));

writeMif(color_filename, color_keys, color_depth, color_width);

%% Make Image data MIF file
image_data_vec = indexImage('asset16.png', colorToIndexMap);
image_depth = 60*60;
image_width = 8;
image_filename = 'image_data.mif';

writeMif(image_filename, image_data_vec, image_depth, image_width);