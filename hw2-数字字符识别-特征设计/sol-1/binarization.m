function img_bin = binarization( img )
% 对输入的图像进行二值化, 局部自适应二值化

[H, W] = size(img);
img_bin = zeros(H, W);

step = floor(W / 4);
for k = 1: step : floor(W/step)*step
    % 获取局部图像块
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

