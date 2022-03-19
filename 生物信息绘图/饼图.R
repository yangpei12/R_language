
# 使用ggplot绘制饼图
windowsFonts(A=windowsFont('Times New Roman'))
library('ggplot2')
library('openxlsx')
path <- "E:/售后/张永峰/diff_transcript/diff_exp_barplot/lncRNA/AdVSPread0_diff_exp.xlsx"
data <- read.xlsx(path, 1, rowNames = T)


# 设置level因为默认的染色体排序是'chr1', 'chr10', 'chr11' ... 'chr2', 'chr20', 'chr21',..'chr3', 'chr4', 'chr5' ...'chr9'，这显然不符合我们的要求因此要为因子重新设置顺序

f <- factor(data$chr, levels = c('chr1', 'chr2', 'chr3', 'chr4', 'chr5', 'chr6', 'chr7', 'chr8', 'chr9', 'chr10', 'chr11',
                                 'chr12', 'chr13', 'chr14', 'chr15', 'chr16', 'chr17', 'chr18', 'chr19', 'chr20', 'chr21',
                                 'chr22', 'chr23', 'chr24', 'chr25', 'chr26', 'chr27', 'chr28', 'chr29', 'X', 'Y')) 

ggplot(data) + 
  geom_bar(aes(f, fill=chr)) + coord_polar() #使用极坐标绘制饼图
  


