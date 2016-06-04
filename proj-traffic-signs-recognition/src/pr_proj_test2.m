clear all; close all; clc;

data = dir('data/');
signs = struct();
img_size = 32; % all images resize to 32*32
%% read data
fprintf('reading all images and preprocessing...\n');
dirs = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10'};
for i = 1 : numel(data)
    idx = find(strcmp(dirs, data(i).name)); % find the matching dir
    if ~isempty(idx)
        fprintf('reading images from dir "%s"... ', data(i).name);
        filelist = importdata(['data/', data(i).name, '/filelist.txt']);
        signs(idx).train_num = numel(filelist) - 40;
        signs(idx).test_num = 40;
        %% read images
        test_img = zeros(signs(idx).test_num, img_size*img_size);
        for j = 1 : 40 % test images
            img_dir = ['data/', data(i).name, '/', filelist{j}];
            img = imresize(rgb2gray(imread(img_dir)), [img_size, img_size]);
            img = histeq(img); % enhance contrast using histogram equalization
            img = double(img(:)');
            test_img(j, :) = img;
        end
        %% save to struct
        signs(idx).test_img = test_img;
        fprintf('test: %d\n', signs(idx).test_num);
    end
end

%% PCA
test_inst = zeros(10*40, img_size*img_size);
for i = 1 : 10
    test_inst(40*(i-1)+1:40*(i-1)+40, :) = signs(i).test_img;
end
test_inst1 = test_inst(1:40, :);
test_inst2_9 = test_inst(41:400, :);
% PCA
[coeff, score, latent, ~, ~, mu] = pca(test_inst);
[coeff1, score1, latent1, ~, ~, mu1] = pca(test_inst1);
score2_9 = (test_inst2_9 - repmat(mu1,400-40,1)) * coeff1;

%% show
% pca for all 10 classes
figure; hold on; grid on;
color = 'rgbkmrgbkm'; shape = '+o*x^^+o*x';
for i = 1 : 10
    plot3(score(40*(i-1)+1:40*(i-1)+40,1), score(40*(i-1)+1:40*(i-1)+40,2), ...
        score(40*(i-1)+1:40*(i-1)+40,3), [color(i), shape(i)]);
end
xlabel('\xi_1'); ylabel('\xi_2'); zlabel('\xi_3');
legend('01','02','03','04','05','06','07','08','09','10');
box on;
% pca for only one class (1 as example)
figure; hold on; grid on;
color = 'rgbkmrgbkm'; shape = '+o*x^^+o*x';
score_new = [score1; score2_9];
for i = 1 : 10
    plot3(score_new(40*(i-1)+1:40*(i-1)+40,1), score_new(40*(i-1)+1:40*(i-1)+40,2), ...
        score_new(40*(i-1)+1:40*(i-1)+40,3), [color(i), shape(i)]);
end
xlabel('\xi_1'); ylabel('\xi_2'); zlabel('\xi_3');
legend('01','02','03','04','05','06','07','08','09','10');
box on;

%% end of script