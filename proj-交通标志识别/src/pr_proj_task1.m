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
        train_img = zeros(signs(idx).train_num, img_size*img_size);
        for j = 1 : numel(filelist) % all images
            img_dir = ['data/', data(i).name, '/', filelist{j}];
            img = imresize(rgb2gray(imread(img_dir)), [img_size, img_size]);
            img = histeq(img); % enhance contrast using histogram equalization
            img = double(img(:)');
            if j <= 40
                test_img(j, :) = img;
            else
                train_img(j-40, :) = img;
            end
        end
        %% save to struct
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
% PCA
% coeff: the principle component matrix (eig vectors)
% score: the principle component scores (new coordinates)
% latent: the principle component variances
% mu: mean value of original data
[coeff, score, latent, ~, ~, mu] = pca(train_inst);

%% test
Kmax = 250; % max nearest neighbors
accuracy_mat = zeros(3, Kmax); % store all the results
far_mat = zeros(3, Kmax); % false alarm rate
max_accuracy = 0;
test_label = zeros(10*40, 1); % true test label, for evaluation
for i = 1 : 10
    test_label(40*(i-1)+1:40*i, :) = i;
end
for K = 1 : Kmax % number of principles selected
    fprintf('iteration for K = %d\n', K);
    for k = [1 3 5] % number of nearest neighbors
        sample = zeros(10*40, K); % test data for kNN
        training = score(:, 1:K); % train data for kNN
        group = [];
        for i = 1 : 10
            test = (signs(i).test_img - repmat(mu,40,1)) * coeff(:, 1:K);
            sample(40*(i-1)+1:40*i, :) = test;
            group = [group; repmat(i, signs(i).train_num, 1)]; %#ok<AGROW>
        end
        % kNN classify
        predicted_label = knnclassify(sample, training, group, k);
        
        %% evaluation
        confusion_mat = confusionmat(test_label, predicted_label);
        accuracy = sum(diag(confusion_mat)) / 400;
        far = (1-accuracy) / 9;
        accuracy_mat((k+1)/2, K) = accuracy;
        far_mat((k+1)/2, K) = far;
        if accuracy > max_accuracy
            max_accuracy = accuracy;
            confusion_img = uint8(confusion_mat / 40 * 256);
            max_paras = [K, k, accuracy, far];
        end
    end
end
save('task1.mat', 'accuracy_mat');

%% plot
figure; hold on; grid on;
plot(1:Kmax, accuracy_mat(1,:), 'r', 'linewidth', 1.5);
plot(1:Kmax, accuracy_mat(2,:), 'g', 'linewidth', 1.5);
plot(1:Kmax, accuracy_mat(3,:), 'b', 'linewidth', 1.5);
plot(1:Kmax, far_mat(1,:), 'r--');
plot(1:Kmax, far_mat(2,:), 'g--');
plot(1:Kmax, far_mat(3,:), 'b--');
xlabel('number of principle components');
ylabel('rate');
title('detection rate v.s. false alarm rate');
legend('k = 1', 'k = 3', 'k = 5');

figure; % show confusion image
imshow(confusion_img, 'InitialMagnification', 'fit');
title({['PCA: ', num2str(max_paras(1)), ',  kNN: ', num2str(max_paras(2)), ...
    ', reaches the best result:']; ['detection: ', num2str(max_paras(3)), ...
    ', false alarm:', num2str(max_paras(4))]});
fprintf('\ndone\n');
%% end of script