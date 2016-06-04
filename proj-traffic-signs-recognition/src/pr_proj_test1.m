clear all; close all; clc;

img_dirs = {
    'data/2/0022.jpg';
    'data/5/0056.jpg';
    'data/6/0008.jpg';
    'data/7/0034.jpg';
    'data/9/0045.jpg';
    'data/10/0065.jpg'
    };
titles = {
    'original';
    'gray';
    'histeq'
    };
n = length(img_dirs);
img_size = [128 NaN];

for i = 1 : n
    img1 = imresize(imread(img_dirs{i}), img_size);
    img2 = rgb2gray(img1);
    img3 = histeq(img2);
    
    for j  = 1 : 3
        subplot(3,n,i+(j-1)*n);
        eval(['imshow(img', num2str(j), ');']);
        if mod(i,n) == 1
            ylabel(titles{j});
        end
    end
end