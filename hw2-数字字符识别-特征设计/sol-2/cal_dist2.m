function dist = cal_dist2(img_blk, centroid)
% dist2(k) = cal_dist2(img_blk, centroid{k});

[h, w] = size(img_blk);
halfw = floor(w/2);

imgcent1 = zeros(h, 1);
imgcent2 = zeros(h, 1);
for i = 1 : h
    left = find(img_blk(i,1:halfw) == 1);
    right = find(img_blk(i,halfw+1:end) == 1);
    if ~isempty(left)
        imgcent1(i) = mean(left);
    end
    if ~isempty(right)
        imgcent2(i) = mean(right);
    else
        imgcent2(i) = halfw;
    end
end
imgcent = [imgcent1; imgcent2];
% πÈ“ªªØ
imgcent = imgcent / norm(imgcent);
dist = norm(imgcent - centroid);

end