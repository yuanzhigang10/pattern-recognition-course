function similarity = cal_similarity(img1, img2)
% 计算两个相同大小的二值图像的余弦相似度

vec1 = double(img1(:));
vec2 = double(img2(:));
assert(numel(vec1)==numel(vec2), '请确保所比较矩阵的元素个数相等！');

similarity = vec1' * vec2 / (norm(vec1) * norm(vec2));
end