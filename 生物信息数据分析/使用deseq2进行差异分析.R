library(DESeq2)
library(openxlsx)

rm(list = ls())
input_path="E:/售后/何宇/gene_count/In_lungVSInpi_lung.xlsx"
output_path="E:/售后/何宇/gene_count/In_lungVSInpi_lung_diff_exp_deseq2.xlsx"
sample_id="E:/售后/何宇/gene_count/lung/sample_id_lung.xlsx"

# data <- read.xlsx(input_path, 1,rowNames = T)

sample_info <- read.xlsx(sample_id, 1,rowNames = T)
# View(sample_info)

for (i in seq(length(sample_info$treat))){
  treat <- sample_info[i, 'treat']
  cont <- sample_info[i, 'cont']
  input_path="E:/售后/何宇/gene_count/In_lungVSInpi_lung.xlsx"
  output_path="E:/售后/何宇/gene_count/In_lungVSInpi_lung_diff_exp_deseq2.xlsx"
  sample_id="E:/售后/何宇/gene_count/lung/sample_id_lung.xlsx"
  condition <- factor(c(treat, treat, treat, cont, cont, cont))
  
  
  # 正式构建dds
  dds <- DESeqDataSetFromMatrix(countData, DataFrame(condition), design= ~ condition )
  
  #对原始dds进行normalize
  dds <- DESeq(dds)
  
  # 将结果用results()函数来获取，赋值给res变量
  res <- results(dds)
  
  table(res$padj<0.05)
  res <- res[order(res$padj),]
  diff_gene_deseq2 <-subset(res,padj < 0.05 & (log2FoldChange > 2 | log2FoldChange < -2))
  diff_gene_deseq2 <- row.names(diff_gene_deseq2)
  resdata <-  merge(as.data.frame(res),as.data.frame(counts(dds,normalize=TRUE)),by="row.names",sort=FALSE)
  write.xlsx(resdata,file= output_path, row.names = F)
}









# 构建dds矩阵
countData <- data
condition <- factor(c("In_lung", "In_lung", "In_lung", "Inpi_lung", "Inpi_lung", "Inpi_lung"))
colData <- data.frame(row.names=colnames(countData), condition)

# 正式构建dds
dds <- DESeqDataSetFromMatrix(countData, DataFrame(condition), design= ~ condition )

#对原始dds进行normalize
dds <- DESeq(dds)

# 将结果用results()函数来获取，赋值给res变量
res <- results(dds)

table(res$padj<0.05)
res <- res[order(res$padj),]
diff_gene_deseq2 <-subset(res,padj < 0.05 & (log2FoldChange > 2 | log2FoldChange < -2))
diff_gene_deseq2 <- row.names(diff_gene_deseq2)
resdata <-  merge(as.data.frame(res),as.data.frame(counts(dds,normalize=TRUE)),by="row.names",sort=FALSE)
write.xlsx(resdata,file= output_path, row.names = F)
