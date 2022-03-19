rm(list = ls())
library(openxlsx)
library(tidyverse)

comp <- read.xlsx("G:/售后/吴春霞/RESULT/低温/低温比较组.xlsx",1)

for(n in seq(dim(comp)[1])){
  group_1 <- comp[n,'group_1']
  group_2 <- comp[n,'group_2']
  
  wd <- paste("G:/售后/吴春霞/RESULT/低温/", group_1, sep="")
  setwd(wd)
  group_1_path <- paste(group_1, "_diff_exp.xlsx", sep = "")
  group_2_path <- paste(group_2, "_diff_exp.xlsx", sep = "")
  
  group_1_data <- read.xlsx(group_1_path, 1)
  group_2_data <- read.xlsx(group_2_path, 1)
  
  # 两两比较
  group_1_data$log2FC <- as.numeric(group_1_data$log2FC)
  group_2_data$log2FC <- as.numeric(group_2_data$log2FC)
  
  group_1_data_diff <- filter(group_1_data, abs(log2FC)>=1 & FDR<0.05)
  group_2_data_diff<- filter(group_2_data, abs(log2FC)>=1 & FDR<0.05)
  
  # 第二步取两个比较组交集，这个交集表示，在两个比较组中共同表达的基因。这个交集中包含了上调和下调的基因
  inter <- inner_join(group_1_data_diff, group_2_data_diff, by='Gene_ID')
  venn_overlapp <- data.frame('Gene_ID'=inter$Gene_ID)
  
  group_1_diff_venn_overlapp <- merge(venn_overlapp, group_1_data_diff, by='Gene_ID', all.x = FALSE)
  group_2_diff_venn_overlapp <- merge(venn_overlapp, group_2_data_diff, by='Gene_ID', all.x = FALSE)
  
  write.xlsx(group_1_diff_venn_overlapp, paste(group_1,'_diff_venn_overlapp.xlsx', sep = ""), rowNames=F)
  write.xlsx(group_2_diff_venn_overlapp, paste(group_2,'_diff_venn_overlapp.xlsx', sep = ""), rowNames=F)
  
  # 取补集
  group_1_anti_venn <- anti_join(group_1_data_diff, venn_overlapp, by='Gene_ID')
  group_2_anti_venn <- anti_join(group_2_data_diff, venn_overlapp, by='Gene_ID')
  
  
  write.xlsx(group_1_anti_venn, paste(group_1,'_anti_venn.xlsx', sep = ""), rowNames=F)
  write.xlsx(group_2_anti_venn, paste(group_2,'_anti_venn.xlsx', sep = ""), rowNames=F)
}
