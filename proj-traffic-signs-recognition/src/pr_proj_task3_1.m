clear all; close all; clc;

data = dir('data/');
signs = struct();
img_size = 32; % all images resize to 32*32
%% read data
fprintf('reading all images and preprocessing...\n');
dirs = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'neg'};
test_nums = [repmat(40, 1 ,10), 200];
for i = 1 : numel(data)
    idx = find(strcmp(dirs, data(i).name)); % find the matching dir
    if ~isempty(idx)
        fprintf('reading images from dir "%s"... ', data(i).name);
        filelist = importdata(['data/', data(i).name, '/filelist.txt']);
        signs(idx).test_num = test_nums(idx);
        signs(idx).train_num = numel(filelist) - test_nums(idx);
        %% read images
        test_img = zeros(signs(idx).test_num, img_size*img_size);
        train_img = zeros(signs(idx).train_num, img_size*img_size);
        for j = 1 : numel(filelist)
            img_dir = ['data/', data(i).name, '/', filelist{j}];
            img = imresize(rgb2gray(imread(img_dir)), [img_size, img_size]);
            img = histeq(img); % enhance contrast using histogram equalization
            img = double(img(:)');
            if j <= signs(idx).test_num
                test_img(j, :) = img;
            else
                train_img(j-signs(idx).test_num, :) = img;
            end
        end
        % save to struct
        signs(idx).test_img = test_img;
        signs(idx).train_img = train_img;
        fprintf('train: %d, test: %d\n', signs(idx).train_num, signs(idx).test_num);
    end
end

%% PCA
train_inst = [];
for i = 1 : 10
    train_inst = [train_inst; signs(i).train_img]; %#ok<AGROW>
end
[coeff, score, latent, ~, ~, mu] = pca(train_inst);
fprintf('\nPCA and classifying...\n');

%% test
K = 69; k = 1;
training = score(:, 1:K); % train data for kNN
sample = zeros(10*40+200, K); % test data for kNN
group = [];
for i = 1 : 10 % pos data
    test = (signs(i).test_img - repmat(mu,40,1)) * coeff(:, 1:K);
    sample(40*(i-1)+1:40*i, :) = test;
    group = [group; repmat(i, signs(i).train_num, 1)]; %#ok<AGROW>
end
% add neg data to test
sample(401:600, :) = (signs(11).test_img-repmat(mu,200,1)) * coeff(:, 1:K);
% kNN classify
[predicted_label, dist] = knnclassify2(sample, training, group, k);
%{
figure; hold on; grid on;
plot((1:600)', predicted_label/max(predicted_label), 'r');
plot((1:600)', dist/max(dist), 'b');
%}

%% evaluation
test_label = zeros(10*40, 1); % true test label, for evaluation
for i = 1 : 10
    test_label(40*(i-1)+1:40*i, :) = i;
end
tpr1_mat = []; tpr2_mat = [];
fpr_mat = []; tnr_mat = [];
for alpha = 0 : 0.1 : 1
    new_label = predicted_label;
    new_label(dist > alpha) = 11;
    tpr1 = sum(new_label(1:400) == test_label) / 400;
    tpr2 = sum(new_label(1:400) < 11) / 400;
    tnr = sum(new_label(401:600) == 11) / 200;
    tpr1_mat = [tpr1_mat, tpr1]; %#ok<AGROW>
    tpr2_mat = [tpr2_mat, tpr2]; %#ok<AGROW>
    tnr_mat = [tnr_mat, tnr]; %#ok<AGROW>
    fpr_mat = [fpr_mat, 1 - tnr]; %#ok<AGROW>
end

%% show result
figure; hold on; grid on;
plot(0:0.1:1, tpr1_mat, 'linewidth', 1.5);
plot(0:0.1:1, tnr_mat, 'r', 'linewidth', 1.5);
xlabel('\alpha'); ylabel('rate');
title('classification results');
legend('true pos rate (1-10)', 'true neg rate (11)');
% ROC
figure; hold on; grid on;
plot(fpr_mat, tpr2_mat, 'r', 'linewidth', 1.5);
plot(fpr_mat, fpr_mat);
axis([0 1 0 1]);
xlabel('false pos rate'); ylabel('true pos rate (amended)');
title('ROC curve');

%% save data for contrast
task3_1.tpr_mat = tpr1_mat;
task3_1.tnr_mat = tnr_mat;
save('task3_1.mat', 'task3_1');
fprintf('\ndone\n');

%% end of script