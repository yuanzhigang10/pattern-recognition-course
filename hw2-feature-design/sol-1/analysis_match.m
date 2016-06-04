function [line1, line2, error_idx] = analysis_match(match, i)
% 根据模式匹配的结果, 分析识别的正确性

aera = [
    10 1 36 25
    14 34 39 56
    9 71 39 96
    11 103 38 134
    12 139 36 164
    7 178 35 202
    2 208 31 240
    1 243 32 274
    46 38 72 60
    45 67 72 100
    45 107 72 131
    43 137 72 169
    42 175 72 208
    40 212 72 237];
if i == 9
    aera = floor(aera * 2);
end
if i == 10
    aera = floor(aera * 0.5);
end
truth = [2,0,1,3,0,1,2,9,1,8,1,6,4,1];

result = (-1) * ones(1,14);
for i = 1 : size(aera,1)
    for j = 1 : size(match,1)
        if match(j,1)>aera(i,1) && match(j,1)<aera(i,3) && ...
                match(j,2)>aera(i,2) && match(j,2)<aera(i,4)
            result(i) = match(j,3);
        end
    end
end
    
line1 = result(1:8);
line2 = result(9:14);
error_idx = find(truth ~= result);

end