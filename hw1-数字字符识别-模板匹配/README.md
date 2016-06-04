# 基于模式匹配的数字识别

代码说明

- `main.m`
	- script
	- 主程序，调用其他各函数，完成对"test/"里10幅图像的数字识别
- `train_preprocess.m`
	- function
	- 对训练模板进行预处理（统一大小，二值化）
- `recognize.m`
	- function
	- 根据模式的知识, 对（单张）测试图像进行模式识别
- `analysis_match.m`
	- function
	- 根据模式匹配的结果, 分析识别的正确性
- `binarization.m`
	- function
	- 对输入的图像进行二值化（局部自适应二值化）
- `cal_similarity.m`
	- function
	- 计算两个相同大小的二值图像的余弦相似度