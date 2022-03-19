rm(list = ls())
library(tidyverse)
library(openxlsx)

comp <- read.xlsx("G:/售后/吴春霞/RESULT/高温/高温比较组.xlsx",1)

for(n in seq(dim(comp)[1])){
  group_1 <- comp[n,'group_1']
  group_2 <- comp[n,'group_2']

  wd <- paste("G:/售后/吴春霞/RESULT/高温/", group_1, sep="")
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
  inter_1 <- inner_join(group_1_data_diff, group_2_data_diff, by='Gene_ID')
  venn_overlapp <- data.frame('Gene_ID'=inter_1$Gene_ID)
  write.xlsx(venn_overlapp, 'venn_overlapp.xlsx', rowNames=F)
  
  # 得到交集后分别将venn_overlapp的输出merge，得到不同比较组交集的基因数据；目的是得到上下调信息，从而将不同表达趋势区分开
  group_1_diff_inter <- merge(venn_overlapp, group_1_data_diff, by='Gene_ID', all.x = FALSE)
  group_2_diff_inter <- merge(venn_overlapp, group_2_data_diff, by='Gene_ID', all.x = FALSE)
  
  # 干路：将得到的交集基因按照上下调趋势分开
  group_1_diff_inter_up <- filter(group_1_diff_inter, regulation=="up")
  group_1_diff_inter_down <- filter(group_1_diff_inter, regulation=="down")
  group_2_diff_inter_up <- filter(group_2_diff_inter, regulation=="up")
  group_2_diff_inter_down <- filter(group_2_diff_inter, regulation=="down")
  
  # 分支一 ：分别将eck_e6_e4_diff_inter_up和mhck_mh6_mh4_diff_inter_up取交集，
  # 将eck_e6_e4_diff_inter_down和mhck_mh6_mh4_diff_inter_down取交集;这一部分表示的是具有相同表达趋势(up/down)的基因
  inter_up <- inner_join(group_1_diff_inter_up, group_2_diff_inter_up, by='Gene_ID')
  venn_overlapp_inter_up <- data.frame('Gene_ID'=inter_up$Gene_ID)
  
  inter_down <- inner_join(group_1_diff_inter_down, group_2_diff_inter_down, by='Gene_ID')
  venn_overlapp_inter_down <- data.frame('Gene_ID'=inter_down$Gene_ID)
  
  #得到交集后分别将venn_overlapp_up/down的输出merge，得到不同比较组交集的基因数据
  group_1_diff_venn_overlapp_inter_up <- merge(venn_overlapp_inter_up, group_1_data_diff, by='Gene_ID', all.x = FALSE)
  group_1_diff_venn_overlapp_inter_down <- merge(venn_overlapp_inter_down, group_1_data_diff,by='Gene_ID', all.x = FALSE)
  
  group_2_diff_venn_overlapp_inter_up <- merge(venn_overlapp_inter_up, group_2_data_diff, by='Gene_ID', all.x = FALSE)
  group_2_diff_venn_overlapp_inter_down <- merge(venn_overlapp_inter_down, group_2_data_diff, by='Gene_ID', all.x = FALSE)
  
  write.xlsx(group_1_diff_venn_overlapp_inter_up, paste(group_1, '_diff_venn_overlapp_inter_up.xlsx', sep = ""), rowNames=F)
  write.xlsx(group_1_diff_venn_overlapp_inter_down, paste(group_1, '_diff_venn_overlapp_inter_down.xlsx', sep = ""), rowNames=F)
  
  write.xlsx(group_2_diff_venn_overlapp_inter_up, paste(group_2, '_diff_venn_overlapp_inter_up.xlsx', sep = ""), rowNames=F)
  write.xlsx(group_2_diff_venn_overlapp_inter_down, paste(group_2, '_diff_venn_overlapp_inter_down.xlsx', sep = ""), rowNames=F)
  
  # 分支二
  # 将eck_e6_e4_diff_inter_up和mhck_mh6_mh4_diff_inter_down取交集;
  # 将eck_e6_e4_diff_inter_down和mhck_mh6_mh4_diff_inter_up取交集；这一部分表示的是具有不同表达趋势的基因
  
  inter_group1_up_group2_down <- inner_join(group_1_diff_inter_up, group_2_diff_inter_down, by='Gene_ID')
  venn_overlapp_inter_group1_up_group2_down<- data.frame('Gene_ID'=inter_group1_up_group2_down$Gene_ID)
  
  inter_group1_down_group2_up <- inner_join(group_1_diff_inter_down, group_2_diff_inter_up, by='Gene_ID')
  venn_overlapp_inter_group1_down_group2_up <- data.frame('Gene_ID'=inter_group1_down_group2_up$Gene_ID)
  
  #得到交集后分别将venn_overlapp_inter_e6_up_mh6_down和venn_overlapp_inter_e6_down_mh6_up的输出merge，得到不同比较组交集的基因数据
  group1_diff_venn_overlapp_inter_group1_up_group2_down <- merge(venn_overlapp_inter_group1_up_group2_down, group_1_data_diff, by='Gene_ID', all.x = FALSE)
  group1_diff_venn_overlapp_inter_group1_down_group2_up <- merge(venn_overlapp_inter_group1_down_group2_up, group_1_data_diff, by='Gene_ID', all.x = FALSE)
  
  group2_diff_venn_overlapp_inter_group1_up_group2_down <- merge(venn_overlapp_inter_group1_up_group2_down, group_2_data_diff, by='Gene_ID', all.x = FALSE)
  group2_diff_venn_overlapp_inter_group1_down_group2_up <- merge(venn_overlapp_inter_group1_down_group2_up, group_2_data_diff, by='Gene_ID', all.x = FALSE)
  
  
  write.xlsx(group1_diff_venn_overlapp_inter_group1_up_group2_down, paste(group_1, '_diff_venn_overlapp_inter_', group_1, '_up_', group_2, '_down.xlsx', sep = ""), rowNames=F)
  write.xlsx(group1_diff_venn_overlapp_inter_group1_down_group2_up, paste(group_1, '_diff_venn_overlapp_inter_', group_1, '_down_', group_2, '_up.xlsx', sep = ""), rowNames=F)
  
  write.xlsx(group2_diff_venn_overlapp_inter_group1_up_group2_down, paste(group_2, '_diff_venn_overlapp_inter_', group_1, '_up_', group_2, '_down.xlsx', sep = ""), rowNames=F)
  write.xlsx(group2_diff_venn_overlapp_inter_group1_down_group2_up, paste(group_2, '_diff_venn_overlapp_inter_', group_1, '_down_', group_2, '_up.xlsx', sep= ""), rowNames=F)
}

