sol-1/	根据列方向像素个数分布进行数字识别
	main2.m
		script
		主程序，调用其他各函数，完成对"test/"里图像的数字识别
	train_preprocess.m
		function
		对训练模板进行预处理（二值化，获取分布特征）
	recognize.m
		function
		根据模式的知识, 对（单张）测试图像进行模式识别
	analysis_match.m
		function
		根据模式匹配的结果, 分析识别的正确性
	binarization.m
		function
		对输入的图像进行二值化（局部自适应二值化）
	kldiv.m
		function
		计算两个分布的距离（对称KL距离）

sol-2/	根据强度、重心特征进行数字识别
	main2s.m
		script
		主程序，调用其他各函数，完成对"test/"里图像的数字识别
	train_preprocess.m
		function
		对训练模板进行预处理（获取重心等特征）
	recognize.m
		function
		根据模式的知识, 对（单张）测试图像进行模式识别
	analysis_match.m
		function
		根据模式匹配的结果, 分析识别的正确性
	binarization.m
		function
		对输入的图像进行二值化（局部自适应二值化）
	cal_dist1.m
		function
		计算两个图像对应的强度向量的距离
	cal_dist2.m
		function
		计算两个图像对应的重心向量的距离