library(edgeR)
library(multcomp)
library(openxlsx)
setwd("D:/R/test_file")
fpkm <- read.xlsx("genes_fpkm_expression.xlsx", 1)

# 实验组与对照组有几个样本有几个样本则control则有几个
treat <- factor(c(rep(c('control', 'control', 'treat', 'treat'), 6)))

# 试验材料通常一个实验材料中包含了对照与试验，例如根这个材料包含了盐水刺激和纯水刺激，因此材料得到factor则为6个
tissue <- factor(c('HU','HU','HU','HU','HU','HU','HU','HU','HU','HU','HU','HU',
                 'DO','DO','DO','DO','DO','DO','DO','DO','DO','DO','DO','DO'))

#实验设计（重要）
design <- model.matrix(~ treat+tissue) 


dge <- DGEList(counts=fpkm[, 38:61], 
             genes=fpkm[, 1], 
             group=rep(c('Dorper_H','Dorper_L','Hu_H','Hu_L'),each=6))

dge_1 <- calcNormFactors(dge)
dge_2 <- estimateGLMCommonDisp(dge, design)
dge_3 <- estimateGLMTagwiseDisp(dge, design)
fit <- glmFit(dge_3, design )

#设置共分析的组别（重要）
lrt.dge <- glmLRT(fit, coef = ) 

result <- topTags(lrt.dge, adjust.method="BH", sort.by="logFC")
write.xlsx(result, "two_way_anova_logfc.xlsx")