clear all; close all; clc;
% add lib-file to path
addpath(genpath('vlfeat'));
addpath(genpath('libsvm'));

data = dir('data/');
signs = struct();
img_size = 32; % all images resize to 32*32
%% read data
fprintf('reading all images and preprocessing...\n');
dirs = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'neg2'};
test_nums = [repmat(40, 1 ,10), 200];
for i = 1 : numel(data)
    idx = find(strcmp(dirs, data(i).name)); % find the matching dir
    if ~isempty(idx)
        fprintf('reading images from dir "%s"... ', data(i).name);
        filelist = importdata(['data/', data(i).name, '/filelist.txt']);
        signs(idx).test_num = test_nums(idx);
        signs(idx).train_num = numel(filelist) - test_nums(idx);
        %% read images
        test_hog = zeros(signs(idx).test_num, 496);
        train_hog = zeros(signs(idx).train_num, 496);
        for j = 1 : numel(filelist) % all images
            img_dir = ['data/', data(i).name, '/', filelist{j}];
            img = imresize(rgb2gray(imread(img_dir)), [img_size, img_size]);
            img = histeq(img); % enhance contrast using histogram equalization
            hog = vl_hog(im2single(img), 8); % get hog feature
            hog = double(hog(:)'); % convert to vector
            if j <= signs(idx).test_num
                test_hog(j, :) = hog;
            else
                train_hog(j-signs(idx).test_num, :) = hog;
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
test_inst = zeros(10*40+200, 496);
test_label = zeros(10*40+200, 1);
% get data for SVM
for i = 1 : 10
    train_inst = [train_inst; signs(i).train_hog]; %#ok<AGROW>
    train_label = [train_label; repmat(i, signs(i).train_num, 1)]; %#ok<AGROW>
    test_inst(40*(i-1)+1:40*i, :) = signs(i).test_hog;
    test_label(40*(i-1)+1:40*i, :) = i;
end
% add neg data
train_inst = [train_inst; signs(11).train_hog];
train_label = [train_label; repmat(11, signs(11).train_num, 1)];
test_inst(401:600, :) = signs(11).test_hog;
test_label(401:600, :) = 11;

% multi-class SVM using linear kernal
% train
model = svmtrain(train_label, train_inst, '-s 0 -t 0 -q');
% predict
[predicted_label, ~, ~] = svmpredict(test_label, test_inst, model, '-q');

%% evaluation
confusion_mat = confusionmat(test_label, predicted_label);
detection = test_nums/sum(test_nums) * (diag(confusion_mat)./test_nums');
false_alarm = test_nums/sum(test_nums) * ...
    ((sum(confusion_mat)'-diag(confusion_mat)) ./ (sum(test_nums)-test_nums'));
tpr = sum(diag(confusion_mat(1:10, 1:10))) / 400; % sign 1-10
tnr = confusion_mat(11 ,11) / 200; % sign 11

confusion_img = confusion_mat;
confusion_img(1:10, :) = confusion_img(1:10, :) / 40 * 256;
confusion_img(11, :) = confusion_img(11, :) / 200 * 256;
confusion_img = uint8(confusion_img);
figure; % show confusion image
imshow(confusion_img, 'InitialMagnification', 'fit');
title({('SVM classification result:'); ...
    ['detection rate:', num2str(detection), ', false alarm rate: ', num2str(false_alarm)]; ...
    ['true pos rate(1-10):', num2str(tpr), ', true neg rate(11): ', num2str(tnr)]});
fprintf('\ndone\n');

%% end of script