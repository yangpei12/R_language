library(openxlsx)
library(tidyverse)
library(ggplot2)
setwd('/Users/yangpei/YangPei/after_sale/多组学测试')
# ==== 1. 数据整理 ====
# 读取相关性系数表数据
mRNA_exp_data <- read.xlsx("mRNA/CdOPVSCd/CdOPVSCd_Gene_differential_expression.xlsx")
meta_exp_data <- read.xlsx("meta/Cd+1_CdCK/Cd+1_CdCK.significant.idms2.xlsx")

mRNA_log2fc <- mRNA_exp_data[, c('gene_id', 'log2(fc)')]
colnames(mRNA_log2fc) <- c('mRNA', 'mRNA_log2_foldchange')


meta_exp_data$ratio <- log2(meta_exp_data$ratio)
meta_log2fc <- meta_exp_data[, c('ID', 'ratio')]
colnames(meta_log2fc) <- c('meta', 'meta_log2_foldchange')

data <- read.table('Output/mRNA_meta_corr_result.txt', sep='\t', header = T)

# 筛选相关系数和p值的关系对
corr_filter <- subset(data, abs(corr_coef)>0.7 & corr_pvalue<0.15)

# 对关系对注释上表达量
corr_filter <- merge(corr_filter, mRNA_log2fc, by='mRNA')
corr_relation_paired_anno <- merge(corr_filter, meta_log2fc, by='meta')

# 为不同象限设置颜色
if (dim(subset(corr_relation_paired_anno, mRNA_log2_foldchange > 1 & meta_log2_foldchange>1))[1]>0) {
  quadrant_1 <- data.frame(subset(corr_relation_paired_anno, mRNA_log2_foldchange > 1 & meta_log2_foldchange>1), 'ponit_color'='color1')
}else(quadrant_1 <- NULL)


if (dim(subset(corr_relation_paired_anno, abs(mRNA_log2_foldchange) < 1 & meta_log2_foldchange>1))[1]>0) {
  quadrant_2 <- data.frame(subset(corr_relation_paired_anno, abs(mRNA_log2_foldchange) < 1 & meta_log2_foldchange>1), 'ponit_color'='color2')
}else(quadrant_2 <- NULL)


if (dim(subset(corr_relation_paired_anno, mRNA_log2_foldchange < -1 & meta_log2_foldchange>1))[1]>0) {
  quadrant_3 <- data.frame(subset(corr_relation_paired_anno, mRNA_log2_foldchange < -1 & meta_log2_foldchange>1), 'ponit_color'='color3')
}else(quadrant_3 <- NULL)


if (dim(subset(corr_relation_paired_anno, mRNA_log2_foldchange > 1 & abs(meta_log2_foldchange) < 1))[1]>0) {
  quadrant_4 <-  data.frame(subset(corr_relation_paired_anno, mRNA_log2_foldchange > 1 & abs(meta_log2_foldchange) < 1), 'ponit_color'='color4')
}else(quadrant_4 <- NULL)


if (dim(subset(corr_relation_paired_anno, abs(mRNA_log2_foldchange) < 1 & abs(meta_log2_foldchange)<1))[1]>0) {
  quadrant_5 <- data.frame(subset(corr_relation_paired_anno, abs(mRNA_log2_foldchange) < 1 & abs(meta_log2_foldchange)<1), 'ponit_color'='color5')
}else(quadrant_5 <- NULL)


if (dim(subset(corr_relation_paired_anno, mRNA_log2_foldchange < -1 & abs(meta_log2_foldchange)<1))[1]>0) {
  quadrant_6 <- data.frame(subset(corr_relation_paired_anno, mRNA_log2_foldchange < -1 & abs(meta_log2_foldchange)<1), 'ponit_color'='color6')
}else(quadrant_6 <- NULL)


if (dim(subset(corr_relation_paired_anno, mRNA_log2_foldchange > 1 & meta_log2_foldchange < -1))[1]>0) {
  quadrant_7 <- data.frame(subset(corr_relation_paired_anno, mRNA_log2_foldchange > 1 & meta_log2_foldchange < -1), 'ponit_color'='color7')
}else(quadrant_7 <- NULL)


if (dim(subset(corr_relation_paired_anno, abs(mRNA_log2_foldchange) < 1 & meta_log2_foldchange < -1))[1]>0) {
  quadrant_8 <- data.frame(subset(corr_relation_paired_anno, abs(mRNA_log2_foldchange) < 1 & meta_log2_foldchange < -1), 'ponit_color'='color8')
}else(quadrant_8 <- NULL)


if (dim(subset(corr_relation_paired_anno, mRNA_log2_foldchange< -1 & meta_log2_foldchange < -1))[1]>0) {
  quadrant_9 <- data.frame(subset(corr_relation_paired_anno, mRNA_log2_foldchange< -1 & meta_log2_foldchange < -1), 'ponit_color'='color9')
}else(quadrant_9 <- NULL)

quadrant_point_with_color <- rbind(quadrant_1, quadrant_2, quadrant_3, quadrant_4, quadrant_5, quadrant_6, quadrant_7, quadrant_8, quadrant_9)


# ==== 2. 绘制九象限图 ====
ggplot(quadrant_point_with_color) + geom_point(mapping = aes(x=mRNA_log2_foldchange, y=meta_log2_foldchange,color=ponit_color))+
  theme_classic()+
  geom_hline(yintercept = c(-1,1), colour="#990000", linetype="dashed") + 
  geom_vline(xintercept = c(-1,1), colour="#990000", linetype="dashed")

ggsave('Output/nine_quadrant.png', width = 6, height = 6)
ggsave('Output/nine_quadrant.pdf', width = 6, height = 6)






