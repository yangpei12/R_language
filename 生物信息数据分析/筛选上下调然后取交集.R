library(openxlsx)
library(tidyverse)
setwd("F:/个人资料与软件/文档/售后/3月/董丹红/lncRNA/test/")
rm(list=ls())

# 读取比较组的差异表达谱文件；有多个比较组可按照示例添加即可
comp1 <- read.xlsx("A1VSB1_Known_lncRNA_differential_expression.xlsx", 1)
comp2 <- read.xlsx("A2VSB2_Known_lncRNA_differential_expression.xlsx", 1)
comp3 <- read.xlsx("A3VSB3_Gene_differential_expression.xlsx", 1)


# 这一步根据条件筛选符合条件的行，其中regulation=='up' & FPKM.A1 >= 2 & log2(fc)>=1为筛选条件，可自行添加或删除条件，可用逻辑运算符
# 且（&）、或（|）将筛选条件连接起来；其中merge函数一次只能两两合并，如果有第4个比较组可将 %>% merge(comp4_up,by='gene_id')添加到
# merge(comp3_up,by='gene_id')与%>% write.xlsx('up_venn.xlsx', rowNames=F)之间即可，以此类推。

comp1_up <- filter(comp1, regulation=='up' & FPKM.A1 >= 2 & log2(fc)>=1) # %>% write.xlsx('comp1_up.xlsx', rowNames=F)
comp2_up <- filter(comp2, regulation=='up' & FPKM.A2 >= 2 & log2(fc)>=1) # %>% write.xlsx('comp2_up.xlsx', rowNames=F)
comp3_up <- filter(comp3, regulation=='up' & FPKM.A3 >= 2 & log2(fc)>=1) # %>% write.xlsx('comp3_up.xlsx', rowNames=F)

merge(comp1_up,comp2_up, by='gene_id') %>% merge(comp3_up,by='gene_id') %>% write.xlsx('up_venn.xlsx', rowNames=F)

comp1_down <- filter(comp1, regulation=='down' & FPKM.B1 >= 2 & log2(fc)<=-1) # %>% write.xlsx('comp1_down.xlsx', rowNames=F)
comp2_down <- filter(comp2, regulation=='down' & FPKM.B2 >= 2 & log2(fc)<=-1) # %>% write.xlsx('comp2_down.xlsx', rowNames=F)
comp3_down <- filter(comp3, regulation=='down' & FPKM.B3 >= 2 & log2(fc)<=-1) # %>% write.xlsx('comp3_down.xlsx', rowNames=F)

merge(comp1_down,comp2_down, by='gene_id') %>% merge(comp3_down,by='gene_id') %>% write.xlsx('down_venn.xlsx', rowNames=F)






























# 对基因按照条件进行进行筛选，
comp1_up <- filter(comp1, log2(fc)>=1.2) # %>% write.xlsx('comp1_up.xlsx', rowNames=F)
comp2_up <- filter(comp2, log2(fc)>=1.2) # %>% write.xlsx('comp2_up.xlsx', rowNames=F)
comp3_up <- filter(comp3, log2(fc)>=1.2) # %>% write.xlsx('comp3_up.xlsx', rowNames=F)

merge(comp1_up,comp2_up, by='gene_id') %>% merge(comp3_up,by='gene_id') %>% write.xlsx('up_venn.xlsx', rowNames=F)


comp1_down <- filter(comp1, log2(fc)<=-1.2) # %>% write.xlsx('comp1_down.xlsx', rowNames=F)
comp2_down <- filter(comp2, log2(fc)<=-1.2) # %>% write.xlsx('comp2_down.xlsx', rowNames=F)
comp3_down <- filter(comp3, log2(fc)<=-1.2) # %>% write.xlsx('comp3_down.xlsx', rowNames=F)

merge(comp1_down,comp2_down, by='gene_id') %>% merge(comp3_down,by='gene_id') %>% write.xlsx('down_venn.xlsx', rowNames=F)

