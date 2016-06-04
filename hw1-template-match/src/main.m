clear all; close all; clc;

%% 设置样本路径
train_path = 'train/';
test_path = 'test/';

%% 预处理训练样本,获得模式的知识
idx = [0,1,2,3,4,6,8,9];
[train_img_bin, pattern_size] = train_preprocess(train_path, idx);

%% 设置识别过程中的预置参数
thres = [0.01, 0.73, 0.05];

%% 对图片中的数字进行识别
test = {'1','2','3','4','5','6','划痕','噪声'};
size_mat = zeros(length(test), 2);
for i = 1 : length(test)
    eval(['test_img=rgb2gray(imread(''',test_path,test{i},'.bmp''));']);
    size_mat(i,:) = size(test_img);
    
    if i == 7 % 带有划痕图片
        test_img = medfilt2(test_img); % 中值滤波
        thres = [0.01, 0.70, 0.05]; % 调整参数
    end
    if i == 8 % 带有噪声图片
        test_img = medfilt2(test_img);
        thres = [0.01, 0.72, 0.05];
    end
    % 根据模式进行匹配
    match = recognize(test_img, train_img_bin, pattern_size, thres, idx);
    % 分析匹配结果
    [line1, line2, error_idx] = analysis_match(match);
    fprintf('%s.bmp\t\terror: %d\n', test{i}, length(error_idx));
    % disp(line1); disp(line2);
end

%% 处理大小不一致的图片
mean_size = round(mean(size_mat)); % 图像平均大小
supp = {'补充1', '补充2'};
thres = [0.01, 0.72, 0.1];
for i = 1 : length(supp)
    eval(['test_img=rgb2gray(imread(''',test_path,supp{i},'.bmp''));']);
    test_img = imresize(test_img, mean_size);
    match = recognize(test_img, train_img_bin, pattern_size, thres, idx);
    [line1, line2, error_idx] = analysis_match(match);
    fprintf('%s.bmp\terror: %d\n', supp{i}, length(error_idx));
    % disp(line1); disp(line2);
end



