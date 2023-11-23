library(pheatmap)
library(reshape2)
library(ggplot2)
setwd('/Users/yangpei/YangPei/after_sale/多组学测试')
# ===== 1. 读取数据 ====
heatmap_data <- read.table('Output/mRNA_meta_corr_result.txt', sep='\t', header = T)
heatmap_data_selected <- heatmap_data[,c('mRNA', 'meta', 'corr_coef')]
heatmap_data <- dcast(heatmap_data_selected, meta~mRNA)
rownames(heatmap_data) <- heatmap_data$meta
heatmap_data <- heatmap_data[,-1]

# ===== 2. 图形绘制 ======

pdf('Output/corr_heatmap.pdf', width = 6, height = 6)
pheatmap(heatmap_data, scale="row", display_numbers = TRUE)
dev.off()

