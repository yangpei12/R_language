library(openxlsx)
library(tidyverse)
library(psych)
setwd("G:/售后/廖梅杰/TT30SVSTT10H")

# 首先导入ceRNA的network2输出数据
network2_path <- "TT30SVSTT10H_TT30SVSTT10H_network2_filter.xlsx"
network2_data <- read.xlsx(network2_path, 1)

# 导入isoform表达谱文件
expression_path <- "5_isoforms_fpkm_expression.xlsx"
expression_data <- read.xlsx(expression_path, 1)

#选择表达谱文件中的t_id列和样本表达谱列
transcript_exp_data <- select(expression_data,t_name, starts_with("FPKM."))


# 根据RNA_class选择lncRNA还是circRNA
type="lncRNA" 
ceRNA_network_data <- filter(network2_data, RNA_class==type)

# 选择出其中的lncRNA列和mRNA列，然后进行共表达分析
lncRNA_mRNA <- ceRNA_network_data[c("RNA", "mRNA")]

# 由于筛选出的lncRNA中含有.:这种形式，我们以t_id为准,首先选取lncRNA_mRNA中的lncRNA列
lncRNA_id <- separate(data=lncRNA_mRNA["RNA"], col=RNA, c(NA, "lncRNA"), sep = ":")
unique_lncRN_id <- unique(lncRNA_id)

# 同理将mRNA进行分列
mRNA_id <- separate(data=lncRNA_mRNA["mRNA"], col=mRNA, c(NA, "mRNA"), sep = ":")
unique_mRNA_id<- unique(mRNA_id)

# 根据lncRNA_id和mRNA_id提取其表达量
lncRNA_exp <- merge(unique_lncRN_id, transcript_exp_data, by=1, all.x = FALSE)
mRNA_exp <- merge(unique_mRNA_id, transcript_exp_data, by=1, all.x = FALSE)

# 根据lncRNA_exp和mRNA_exp表达量计算相关性,这一步时将其转换为数据框
lncRNA_exp_df <- data.frame(lncRNA_exp[,-1], row.names = lncRNA_exp[,1])
mRNA_exp_df <- data.frame(mRNA_exp[,-1], row.names = mRNA_exp[,1])

# 转置数据框
t_lncRNA_exp <- t(lncRNA_exp_df)
t_mRNA_exp <- t(mRNA_exp_df)

#必须将数据框中的数据转换为同一数据类型，因此需要进行矩阵转换
corr_data <- corr.test(as.matrix(t_lncRNA_exp), 
                   as.matrix(t_mRNA_exp))

Rho <- as.data.frame(corr_data$r)
Pvalue <- as.data.frame(corr_data$p)

# 创建一个空的数据库，然后使用rbind不断append

df_rho <- data.frame()
for (i in seq(length(Rho))) {
  df_rho <- rbind(df_rho, data.frame(node1=row.names(Rho),
                                     node2=rep(colnames(Rho)[i],dim(Rho)[1]),
                                     rho=Rho[,i]))
}

df_pvalue <- data.frame()
for (i in seq(length(Pvalue))) {
  df_pvalue <- rbind(df_pvalue, data.frame(node1=row.names(Pvalue),
                                           node2=rep(colnames(Pvalue)[i],dim(Pvalue)[1]),
                                           pvalue=Pvalue[,i]))
}
pvalue <- df_pvalue$pvalue
correlation <- na.omit(cbind(df_rho,pvalue))
write.xlsx(lncRNA_exp, 'lncRNA_exp.xlsx',rowNames=F)
write.xlsx(mRNA_exp, 'mRNA_exp.xlsx',rowNames=F)
write.xlsx(correlation,'TT30SVSTT10H_corr_lncRNA_mRNA.xlsx',rowNames=F)
# ============================================================================
# 使用order函数进行排序,order按照某列排序后，返回值是索引值(index)
#sorted <- filter_corr[order(filter_corr$rho, decreasing = T)]

# 输入感兴趣的lncRNA或者mRNA进行筛选
core_mRNA <- read.xlsx("mRNA_selected.xlsx", 1)
unique_core_mRNA <- unique(core_mRNA)

#首先创建一个空的数据框，然后将筛选得到的数据往数据框中添加
df_paired <- data.frame()

for (mRNA in unique_core_mRNA$name) {
  mRNA <- filter(correlation, node2==mRNA)
  select_paired <- filter(mRNA, abs(mRNA$rho)>=0.8 & pvalue < 0.05)
  df_paired <- rbind(df_paired, select_paired)
}

#将筛选到的关系对输出到文件中
write.xlsx(df_paired,'YY_circRNA_mRNA_network.xlsx',rowNames=F)






