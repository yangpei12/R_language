
# 使用ggplot绘制饼图
windowsFonts(A=windowsFont('Times New Roman'))
library('ggplot2')
library('openxlsx')
path <- "E:/售后/张永峰/diff_transcript/diff_exp_barplot/lncRNA/AdVSPread0_diff_exp.xlsx"
data <- read.xlsx(path, 1, rowNames = T)
View(data)

# 设置level因为默认的染色体排序是'chr1', 'chr10', 'chr11' ... 'chr2', 'chr20', 'chr21',..'chr3', 'chr4', 'chr5' ...'chr9'，这显然不符合我们的要求因此要为因子重新设置顺序

f <- factor(data$chr, levels = c('chr1', 'chr2', 'chr3', 'chr4', 'chr5', 'chr6', 'chr7', 'chr8', 'chr9', 'chr10', 'chr11',
                                 'chr12', 'chr13', 'chr14', 'chr15', 'chr16', 'chr17', 'chr18', 'chr19', 'chr20', 'chr21',
                                 'chr22', 'chr23', 'chr24', 'chr25', 'chr26', 'chr27', 'chr28', 'chr29', 'X', 'Y')) 

ggplot(data) + 
  geom_bar(aes(f, fill=chr)) + # 注意此处使用图形属性fill将数据映射为不同颜色，请注意是数据，也就是说直接使用data中的离散变量即可
  theme(axis.text.x=element_text(family = 'A', angle = 45, hjust=1, vjust = 0.5), # hjust与vjust调整坐标刻度与刻度线的对齐以及 修改坐标轴刻度的字体等
        axis.text.y=element_text(family = 'A'),
        panel.border = element_blank(),        
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.title.x=element_text(family = 'A'),
        axis.title.y=element_text(family = 'A'),
        axis.ticks.x=element_blank()  # 取消x轴的坐标刻度线
  )


