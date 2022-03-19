library(tidyverse)
library(openxlsx)

setwd("E:/售后/孙琬/Result/h")
data <- read.xlsx("h_GO_enrichment_Gene.xlsx",1)

df <- data.frame()
for (i in seq(dim(data)[1])) {
  selected_row <- data[i,]
  df1 <- data.frame('id'=selected_row$GO_ID,
                    'go_term'=selected_row$GO_Term,
                    'go_function'=selected_row$GO_function,
                    'go_class'=selected_row$GO_class,
                    'pvalue'=selected_row$pvalue)
  
  gene_id <- as.data.frame(strsplit(selected_row$Genes,";"),col.names = 'gene_id')
  
  len <- dim(gene_id)[1]
  
  id <- data.frame('id'=rep(selected_row[1,'GO_ID'],len),
                   'Gene_id'=gene_id$gene_id)
merged <- merge(df1,id,by=1,all.x = F)
df <- rbind(df, merged)
}
write.xlsx(df, "h_GO_enrichment_Gene_out.xlsx")
