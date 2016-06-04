clear all; close all; clc;
%% ��������·��
trainpath = 'face/train/';
testpath = 'face/test/';

%% ��ȡѵ���������������ݾ���
trainface = dir([trainpath, '*.jpg']);
M = length(trainface);
N = 19 * 19;
facemat = zeros(N, M);
for i = 1 : M
    face = double(imread([trainpath, trainface(i).name]));
    facemat(:, i) = face(:); % ��ͼ��תΪ������
end
meanface = mean(facemat, 2); % ƽ����
facemat = facemat - repmat(meanface, 1, M); % ���Ļ�

%% ��Э��������ֽ�
C = 1/(M-1) * (facemat*facemat'); % Э�������
[eigface, lamb] = eig(C); % �����ֽ�
lamb = diag(lamb); % ����ֵ

%% �Բ�ͬͼƬ�����ؽ�
img1 = double(imread([trainpath, trainface(1).name]));
img2 = double(imread([testpath, 'face.jpg']));
img3 = double(imread([testpath, 'nonface.jpg']));
img1 = img1(:); img2 = img2(:); img3 = img3(:);
error1 = zeros(N, 1);
error2 = zeros(N, 1);
error3 = zeros(N, 1);
for k = 1 : N
    P = fliplr(eigface(:, end-k+1:end)); % ͶӰ����
    % ���������е�ͼƬ
    y1 = P' * (img1 - meanface); % �����ռ��ϵ��
    rebuild1 = meanface + P * y1; % �ؽ�ͼƬ
    error1(k) = norm(rebuild1 - img1) ^ 2; % �ؽ����
    % test/face.jpg
    y2 = P' * (img2 - meanface);
    rebuild2 = meanface + P * y2;
    error2(k) = norm(rebuild2 - img2) ^ 2;
    % test/nonface.jpg
    y3 = P' * (img3 - meanface);
    rebuild3 = meanface + P * y3;
    error3(k) = norm(rebuild3 - img3) ^ 2;
end

%% ��ͼ
% ��Ȼ��ʾ
figure;
x = 1:N;
plot(x, error1, 'r', x, error2, 'g', x, error3);
xlabel('K'); ylabel('||x''-x||^2');
title('Error ||x''-x||^2 versus K');
legend('(a)','(b)','(c)');
grid on;
% y�������ʾ�����ڹ۲�k->Nʱ�����
figure;
semilogy(x, error1, 'r', x, error2, 'g', x, error3);
xlabel('K'); ylabel('log(||x''-x||^2)');
title('Error ||x''-x||^2 versus K');
legend('(a)','(b)','(c)');
grid on;

%% end