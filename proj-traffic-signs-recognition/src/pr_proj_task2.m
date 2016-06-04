clear all; close all; clc;
% add lib-file to path
addpath(genpath('vlfeat'));
addpath(genpath('libsvm'));

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
        test_hog = zeros(signs(idx).test_num, 496);
        train_hog = zeros(signs(idx).train_num, 496);
        for j = 1 : numel(filelist) % all images
            img_dir = ['data/', data(i).name, '/', filelist{j}];
            img = imresize(rgb2gray(imread(img_dir)), [img_size, img_size]);
            img = histeq(img); % enhance contrast using histogram equalization
            hog = vl_hog(im2single(img), 8); % get hog feature
            hog = double(hog(:)'); % convert to vector
            if j <= 40
                test_hog(j, :) = hog;
            else
                train_hog(j-40, :) = hog;
            end
        end
        %% save to struct
        signs(idx).test_hog = test_hog;
        signs(idx).train_hog = train_hog;
        fprintf('train: %d, test: %d\n', signs(idx).train_num, signs(idx).test_num);
    end
end

%% SVM classify
fprintf('\nSVM classifying...\n');
train_inst = [];
train_label = [];
test_inst = zeros(10*40, 496);
test_label = zeros(10*40, 1);
% get data for SVM
for i = 1 : 10
    train_inst = [train_inst; signs(i).train_hog]; %#ok<AGROW>
    train_label = [train_label; repmat(i, signs(i).train_num, 1)]; %#ok<AGROW>
    test_inst(40*(i-1)+1:40*i, :) = signs(i).test_hog;
    test_label(40*(i-1)+1:40*i, :) = i;
end
% multi-class SVM using linear kernal
% train
model = svmtrain(train_label, train_inst, '-s 0 -t 0 -q');
% predict
[predicted_label, accuracy, ~] = svmpredict(test_label, test_inst, model, '-q');

%% evaluation
result = reshape(predicted_label, [40 10])';
confusion_mat = confusionmat(test_label, predicted_label);
accuracy = accuracy(1)/100;
far = (1-accuracy/100) / 9;
confusion_img = uint8(confusion_mat / 40 * 256);
figure; % show confusion image
imshow(confusion_img, 'InitialMagnification', 'fit');
title({('SVM with Hog classification');
    ['detection: ', num2str((accuracy)), ', false alarm:', num2str(far)]});
fprintf('\ndone\n');

%% end of script