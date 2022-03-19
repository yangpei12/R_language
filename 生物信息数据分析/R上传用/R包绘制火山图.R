library(openxlsx)
library(EnhancedVolcano)

rm(list=ls())
path="E:/BaiduNetdiskDownload/summary_ÍõÎÀÁú/different_transcripts.xlsx"
data = read.xlsx(path, 1, rowNames = T)
EnhancedVolcano(toptable = data, x='log2(fc)', y='pval', lab = row.names(data))

