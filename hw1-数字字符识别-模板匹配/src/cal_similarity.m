function similarity = cal_similarity(img1, img2)
% ����������ͬ��С�Ķ�ֵͼ����������ƶ�

vec1 = double(img1(:));
vec2 = double(img2(:));
assert(numel(vec1)==numel(vec2), '��ȷ�����ȽϾ����Ԫ�ظ�����ȣ�');

similarity = vec1' * vec2 / (norm(vec1) * norm(vec2));
end