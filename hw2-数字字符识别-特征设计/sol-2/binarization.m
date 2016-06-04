function img_bin = binarization( img )
% �������ͼ����ж�ֵ��, �ֲ�����Ӧ��ֵ��

[H, W] = size(img);
img_bin = zeros(H, W);

step = floor(W / 4);
for k = 1: step : floor(W/step)*step
    % ��ȡ�ֲ�ͼ���
    if k + step - 1 > W
        w = W - k + 1;
    else
        w = step;
    end
    img_blk = img(:, k:k+w-1);
    img_blk_bin = im2bw(img_blk, graythresh(img_blk));
    img_bin(:, k:k+w-1) = img_blk_bin;
end

end

