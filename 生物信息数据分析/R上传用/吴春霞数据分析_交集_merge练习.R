library(tidyverse)
library(openxlsx)
setwd("F:/个人资料与软件/文档/售后/2月/吴春霞/低温/ECKE6E4_MHCKMH6MH4")

eck_e6_e4 <- read.xlsx("E_6_vs_E_CK_diff_exp.xlsx",1)
mhck_mh6_mh4 <- read.xlsx("MH_6_vs_MH_CK_diff_exp.xlsx",1)

#第一步先按照条件进行筛选
# 两两比较
eck_e6_e4$log2FC <- as.numeric(eck_e6_e4$log2FC)
mhck_mh6_mh4$log2FC <- as.numeric(mhck_mh6_mh4$log2FC)
eck_e6_e4_diff <- filter(eck_e6_e4, abs(log2FC)>=1 & pvalue<0.05)
mhck_mh6_mh4_diff <- filter(mhck_mh6_mh4, abs(log2FC)>=1 & pvalue<0.05)

#write.xlsx(eck_e6_e4_diff, 'E_6_vs_E_CK_diff_exp_out.xlsx',rowNames=F)
#write.xlsx(mhck_mh6_mh4_diff, 'MH_6_vs_MH_CK_diff_exp_out.xlsx',rowNames=F)

# 第二步取两个比较组交集，这个交集表示，在两个比较组中共同表达的基因。这个交集中包含了上调和下调的基因
inter_1 <- inner_join(eck_e6_e4_diff, mhck_mh6_mh4_diff, by='Gene_ID')
venn_overlapp <- data.frame('Gene_ID'=inter_1$Gene_ID)
write.xlsx(venn_overlapp, 'venn_overlapp.xlsx', rowNames=F)

# 得到交集后分别将venn_overlapp的输出merge，得到不同比较组交集的基因数据；目的是得到上下调信息，从而将不同表达趋势区分开
eck_e6_e4_diff_inter <- merge(venn_overlapp, eck_e6_e4_diff, by='Gene_ID', all.x = FALSE)
mhck_mh6_mh4_diff_inter <- merge(venn_overlapp, mhck_mh6_mh4_diff, by='Gene_ID', all.x = FALSE)

#write.xlsx(eck_e6_e4_diff_inter, 'eck_e6_e4_diff_inter.xlsx', rowNames=F)
#write.xlsx(mhck_mh6_mh4_diff_inter, 'mhck_mh6_mh4_diff_inter.xlsx', rowNames=F)

# 干路：将得到的交集基因按照上下调趋势分开
eck_e6_e4_diff_inter_up <- filter(eck_e6_e4_diff_inter, regulation=="up")
eck_e6_e4_diff_inter_down <- filter(eck_e6_e4_diff_inter, regulation=="down")
mhck_mh6_mh4_diff_inter_up <- filter(mhck_mh6_mh4_diff_inter, regulation=="up")
mhck_mh6_mh4_diff_inter_down <- filter(mhck_mh6_mh4_diff_inter, regulation=="down")

# 分支一 ：分别将eck_e6_e4_diff_inter_up和mhck_mh6_mh4_diff_inter_up取交集，
# 将eck_e6_e4_diff_inter_down和mhck_mh6_mh4_diff_inter_down取交集;这一部分表示的是具有相同表达趋势(up/down)的基因
inter_up <- inner_join(eck_e6_e4_diff_inter_up, mhck_mh6_mh4_diff_inter_up, by='Gene_ID')
venn_overlapp_inter_up <- data.frame('Gene_ID'=inter_up$Gene_ID)

inter_down <- inner_join(eck_e6_e4_diff_inter_down, mhck_mh6_mh4_diff_inter_down, by='Gene_ID')
venn_overlapp_inter_down <- data.frame('Gene_ID'=inter_down$Gene_ID)

#write.xlsx(venn_overlapp_inter_up, 'venn_overlapp_inter_e6_up_mh6_up.xlsx', rowNames=F)
#write.xlsx(venn_overlapp_inter_down, 'venn_overlapp_inter_e6_down_mh6_down.xlsx', rowNames=F)


#得到交集后分别将venn_overlapp_up/down的输出merge，得到不同比较组交集的基因数据
eck_e6_e4_diff_venn_overlapp_inter_up <- merge(venn_overlapp_inter_up, eck_e6_e4_diff, by='Gene_ID', all.x = FALSE)
eck_e6_e4_diff_venn_overlapp_inter_down <- merge(venn_overlapp_inter_down, eck_e6_e4_diff,by='Gene_ID', all.x = FALSE)

mhck_mh6_mh4_diff_venn_overlapp_inter_up <- merge(venn_overlapp_inter_up, mhck_mh6_mh4_diff, by='Gene_ID', all.x = FALSE)
mhck_mh6_mh4_diff_venn_overlapp_inter_down <- merge(venn_overlapp_inter_down,mhck_mh6_mh4_diff,by='Gene_ID', all.x = FALSE)

write.xlsx(eck_e6_e4_diff_venn_overlapp_inter_up, 'eck_e6_e4_diff_venn_overlapp_inter_up.xlsx', rowNames=F)
write.xlsx(eck_e6_e4_diff_venn_overlapp_inter_down, 'eck_e6_e4_diff_venn_overlapp_inter_down.xlsx', rowNames=F)

write.xlsx(mhck_mh6_mh4_diff_venn_overlapp_inter_up, 'mhck_mh6_mh4_diff_venn_overlapp_inter_up.xlsx', rowNames=F)
write.xlsx(mhck_mh6_mh4_diff_venn_overlapp_inter_down, 'mhck_mh6_mh4_diff_venn_overlapp_inter_down.xlsx', rowNames=F)

# 分支二
# 将eck_e6_e4_diff_inter_up和mhck_mh6_mh4_diff_inter_down取交集;
# 将eck_e6_e4_diff_inter_down和mhck_mh6_mh4_diff_inter_up取交集；这一部分表示的是具有不同表达趋势的基因

inter_e6_up_mh6_down <- inner_join(eck_e6_e4_diff_inter_up, mhck_mh6_mh4_diff_inter_down, by='Gene_ID')
venn_overlapp_inter_e6_up_mh6_down<- data.frame('Gene_ID'=inter_e6_up_mh6_down$Gene_ID)

inter_e6_down_mh6_up <- inner_join(eck_e6_e4_diff_inter_down, mhck_mh6_mh4_diff_inter_up, by='Gene_ID')
venn_overlapp_inter_e6_down_mh6_up <- data.frame('Gene_ID'=inter_e6_down_mh6_up$Gene_ID)

#得到交集后分别将venn_overlapp_inter_e6_up_mh6_down和venn_overlapp_inter_e6_down_mh6_up的输出merge，得到不同比较组交集的基因数据
eck_e6_e4_diff_venn_overlapp_inter_e6_up_mh6_down <- merge(venn_overlapp_inter_e6_up_mh6_down, eck_e6_e4_diff, by='Gene_ID', all.x = FALSE)
eck_e6_e4_diff_venn_overlapp_inter_e6_down_mh6_up <- merge(venn_overlapp_inter_e6_down_mh6_up, eck_e6_e4_diff,by='Gene_ID', all.x = FALSE)

mhck_mh6_mh4_diff_venn_overlapp_inter_e6_up_mh6_down <- merge(venn_overlapp_inter_e6_up_mh6_down, mhck_mh6_mh4_diff, by='Gene_ID', all.x = FALSE)
mhck_mh6_mh4_diff_venn_overlapp_inter_e6_down_mh6_up <- merge(venn_overlapp_inter_e6_down_mh6_up,mhck_mh6_mh4_diff,by='Gene_ID', all.x = FALSE)

write.xlsx(eck_e6_e4_diff_venn_overlapp_inter_e6_up_mh6_down, 'eck_e6_e4_diff_venn_overlapp_inter_e6_up_mh6_down.xlsx', rowNames=F)
write.xlsx(eck_e6_e4_diff_venn_overlapp_inter_e6_down_mh6_up, 'eck_e6_e4_diff_venn_overlapp_inter_e6_down_mh6_up.xlsx', rowNames=F)

write.xlsx(mhck_mh6_mh4_diff_venn_overlapp_inter_e6_up_mh6_down, 'mhck_mh6_mh4_diff_venn_overlapp_inter_e6_up_mh6_down.xlsx', rowNames=F)
write.xlsx(mhck_mh6_mh4_diff_venn_overlapp_inter_e6_down_mh6_up, 'mhck_mh6_mh4_diff_venn_overlapp_inter_e6_down_mh6_up.xlsx', rowNames=F)








