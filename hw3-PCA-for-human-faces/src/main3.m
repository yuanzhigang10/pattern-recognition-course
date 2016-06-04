clear all; close all; clc;
%% 设置样本路径
trainpath = 'face/train/';
testpath = 'face/test/';

%% 读取训练样本，构建数据矩阵
trainface = dir([trainpath, '*.jpg']);
M = length(trainface);
N = 19 * 19;
facemat = zeros(N, M);
for i = 1 : M
    face = double(imread([trainpath, trainface(i).name]));
    facemat(:, i) = face(:); % 将图像转为列向量
end
meanface = mean(facemat, 2); % 平均脸
facemat = facemat - repmat(meanface, 1, M); % 中心化

%% 求协方差，特征分解
C = 1/(M-1) * (facemat*facemat'); % 协方差矩阵
[eigface, lamb] = eig(C); % 特征分解
lamb = diag(lamb); % 特征值

%% 对不同图片进行重建
img1 = double(imread([trainpath, trainface(1).name]));
img2 = double(imread([testpath, 'face.jpg']));
img3 = double(imread([testpath, 'nonface.jpg']));
img1 = img1(:); img2 = img2(:); img3 = img3(:);
error1 = zeros(N, 1);
error2 = zeros(N, 1);
error3 = zeros(N, 1);
for k = 1 : N
    P = fliplr(eigface(:, end-k+1:end)); % 投影矩阵
    % 测试样例中的图片
    y1 = P' * (img1 - meanface); % 特征空间的系数
    rebuild1 = meanface + P * y1; % 重建图片
    error1(k) = norm(rebuild1 - img1) ^ 2; % 重建误差
    % test/face.jpg
    y2 = P' * (img2 - meanface);
    rebuild2 = meanface + P * y2;
    error2(k) = norm(rebuild2 - img2) ^ 2;
    % test/nonface.jpg
    y3 = P' * (img3 - meanface);
    rebuild3 = meanface + P * y3;
    error3(k) = norm(rebuild3 - img3) ^ 2;
end

%% 作图
% 自然显示
figure;
x = 1:N;
plot(x, error1, 'r', x, error2, 'g', x, error3);
xlabel('K'); ylabel('||x''-x||^2');
title('Error ||x''-x||^2 versus K');
legend('(a)','(b)','(c)');
grid on;
% y轴对数显示，便于观察k->N时的情况
figure;
semilogy(x, error1, 'r', x, error2, 'g', x, error3);
xlabel('K'); ylabel('log(||x''-x||^2)');
title('Error ||x''-x||^2 versus K');
legend('(a)','(b)','(c)');
grid on;

%% end