# ʹ��ggplot���Ʊ�ͼ
library('ggplot2')
library('openxlsx')
path <- "D:/R/test_file/factor.xlsx"
data <- read.xlsx(path, 1, rowNames = T)



f <- factor(data$circType)

ggplot() + geom_bar(aes(f, color=f, fill=f))


