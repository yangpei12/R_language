library(DESeq2)
library(openxlsx)


sample_id="E:/售后/何宇/gene_count/rest/sample_id.xlsx"
sample_info <- read.xlsx(sample_id, 1, rowNames = T)

for (i in seq(length(sample_info$treat))){
  treat <- sample_info[i, 'treat']
  cont <- sample_info[i, 'cont']
  
  input_path <- paste("E:/售后/何宇/gene_count/rest/",treat, 'VS', cont, '.xlsx', sep = '')
  output_path <- paste("E:/售后/何宇/gene_count/rest/",treat, 'VS', cont, '_diff_exp_deseq2.xlsx', sep = '')

  condition <- factor(c(treat, treat, treat, cont, cont, cont))
  
  # 读取输入数据
  data <- read.xlsx(input_path, 1,rowNames = T)
  
  # 正式构建dds
  dds <- DESeqDataSetFromMatrix(data, DataFrame(condition), design= ~ condition )
  
  #对原始dds进行normalize
  dds <- DESeq(dds)

  # 将结果用results()函数来获取，赋值给res变量
  res <- results(dds)
  
  table(res$padj<0.05)
  res <- res[order(res$padj),]
  diff_gene_deseq2 <-subset(res,padj < 0.05 & (log2FoldChange > 1 | log2FoldChange < -1))
  diff_gene_deseq2 <- row.names(diff_gene_deseq2)
  resdata <-  merge(as.data.frame(res),as.data.frame(counts(dds,normalize=TRUE)),by="row.names",sort=FALSE)
  write.xlsx(resdata,file= output_path, row.names = F)
}