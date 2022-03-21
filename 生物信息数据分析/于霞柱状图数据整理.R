library(tidyverse)
library(openxlsx)
setwd("E:/售后/于霞")
rm(list = ls())
gene_exp <- read.xlsx("4_genes_fpkm_expression.xlsx",1) 

# =========数据读取=======
gene_diff <- read.xlsx("POP_DVSControl_D_Gene_differential_expression.xlsx",1) 
total_gene_diff <- merge(gene_diff, gene_exp, by='gene_id', all.x = FALSE)

know_lncRNA <- read.xlsx("POP_DVSControl_D_Known_lncRNA_differential_expression.xlsx",1)
novel_lncRNA <- read.xlsx("POP_DVSControl_D_Novel_lncRNA_differential_expression.xlsx",1)
total_lncRNA <- rbind(know_lncRNA,novel_lncRNA) 

total_circRNA <- read.xlsx("1_POP_DVSControl_D_circRNA_differential_expression.xlsx",1)


# =======数据整理===========

# ===lncRNA====
# 首先按照“chr”进行筛选
# 筛选后统计一共有多少行
lncRNA_chr <- filter(total_lncRNA, chr==ch) %>% dim(.)

# 在"chr"筛选的基础上，再按照"significant"筛选
# 统计有多少行
lncRNA_chr_sig <- filter(total_lncRNA, chr==ch & significant=='yes') %>% dim(.)

# 计算比例
ratio_lncRNA <- lncRNA_chr_sig[1]/lncRNA_chr[1]
print(ratio_lncRNA)
# ===mRNA====
mRNA_chr <- filter(total_gene_diff, chr==ch) %>% dim(.)
mRNA_chr_sig <- filter(total_gene_diff, chr==ch & significant=='yes') %>% dim(.)
ratio_mRNA <- mRNA_chr_sig[1]/mRNA_chr[1]
print(ratio_mRNA)
# ===circRNA====
circRNA_chr <- filter(total_circRNA, chr==ch) %>% dim(.)
circRNA_chr_sig <- filter(total_circRNA, chr==ch & significant=='yes') %>% dim(.)
ratio_circRNA <- circRNA_chr_sig[1]/circRNA_chr[1]
print(ratio_circRNA)

# ===批量处理====
chrs <- c("chr1","chr10","chr11","chr12","chr13","chr14",
          "chr15","chr16","chr17","chr18","chr19","chr2",
          "chr20","chr21","chr22","chr3","chr4","chr5","chr6","chr7","chr8","chr9","X","Y")
df <- data.frame()
for (ch in chrs){
  lncRNA_chr <- filter(total_lncRNA, chr==ch) %>% dim(.)
  lncRNA_chr_sig <- filter(total_lncRNA, chr==ch & significant=='yes') %>% dim(.)
  ratio_lncRNA <- lncRNA_chr_sig[1]/lncRNA_chr[1]

  mRNA_chr <- filter(total_gene_diff, chr==ch) %>% dim(.)
  mRNA_chr_sig <- filter(total_gene_diff, chr==ch & significant=='yes') %>% dim(.)
  ratio_mRNA <- mRNA_chr_sig[1]/mRNA_chr[1]

  circRNA_chr <- filter(total_circRNA, chr==ch) %>% dim(.)
  circRNA_chr_sig <- filter(total_circRNA, chr==ch & significant=='yes') %>% dim(.)
  ratio_circRNA <- circRNA_chr_sig[1]/circRNA_chr[1]
  
  
  df <- rbind(df,data.frame('chr'=ch,
              'ratio_lncRNA'=ratio_lncRNA,
              'ratio_mRNA'=ratio_mRNA,
              'ratio_circRNA'=ratio_circRNA))
}




















