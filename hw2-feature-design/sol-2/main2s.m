clear all; close all; clc;

%% 设置样本路径
train_path = 'train/';
test_path = 'test/';

%% 预处理训练样本,获得模式的知识
train_idx = [0,1,2,3,4,6,8,9];
[train_img, centroid] = train_preprocess(train_path, train_idx);

%% 对图片中的数字进行识别
test_idx = {'1','2','3','4','5','6','划痕','噪声'};
% 三个参数的含义
% thres(1) mask重叠程度，用于防重复识别的判定
% thres(2) 两个距离特征的组合系数
% thres(3) 判定某区域是数字的距离阈值
thres = [
    0.2, 0.3, 0.4
    0.2, 0.3, 0.35
    0.2, 0.3, 0.4
    0.2, 0.3, 0.4
    0.2, 0.3, 0.38
    0.2, 0.3, 0.4
    0.2, 0.3, 0.4
    0.2, 0.3, 0.4
    ];
for i = 1 : length(test_idx)
    % for tt = 0.3 : 0.02 : 0.5
        eval(['test_img=rgb2gray(imread(''',test_path,test_idx{i},'.bmp''));']);
        if i == 8
            test_img = medfilt2(test_img); % 中值滤波
        end
        test_img = ~binarization(test_img); % 测试图像二值化
        % figure; subplot(2,1,1); imshow(test_img);
        
        % 根据模式进行匹配
        match = recognize(test_img, train_img, centroid, train_idx, thres(i,:));
        
        % 分析匹配结果
        [line1, line2, error_idx] = analysis_match(match);
        disp(line1); disp(line2);
        % fprintf('tt: %f\t', tt);
        fprintf('%s.bmp\t\terror: %d\n', test_idx{i}, length(error_idx));
    % end
end

