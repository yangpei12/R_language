library(openxlsx)
library(tidyverse)
library(dplyr)

rm(list=ls())
path="E:/工作/联川学习资料/mRNA测序/summary_report/5_differential_expression/treatVScon/treatVScon_Gene_differential_expression.xlsx"
raw_data <- read.xlsx(path, 1, colNames=T, rowNames = T)
pvalue_adj <- -log10(raw_data$pval)
m_data <- mutate(raw_data, pvalue_adj)
View(m_data)




# pval_adj <- data.frame('pvalue_adj' = -log10(raw_data$pval), row.names = row.names(raw_data))
# 
# new_data <- cbind(raw_data, pval_adj)
# 
# filter_data <- filter(new_data, pvalue_adj!=Inf)
# # View(filter)
# 
# 
# ggplot(data = filter_data) + geom_point(mapping = aes(x=log2(fc), y=pvalue_adj)) + geom_text(mapping = aes(x=log2(fc), y=pvalue_adj, label=row.names(filter_data)))
 

