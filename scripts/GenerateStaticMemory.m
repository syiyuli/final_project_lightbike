%% Create data memory
clear; format short;

%% Data constants
mif_file = "data_memory.mif";
load('ColorMap');
dmem_depth = 2^12;

image_files = {'cards.png'};
num_files = length(image_files);
vecs{1, length(image_files)} = [];

comment = '';
address = 0;

for i = 1:num_files
    curr_file = image_files{i};
    image_vec = makeImageDataVector(curr_file, colorToIndexMap);
    vecs{i} = image_vec;
    
    comment = sprintf('%s-- %s at address %i\r\n', comment, curr_file, address);
end