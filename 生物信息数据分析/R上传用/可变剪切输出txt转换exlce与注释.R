# 文件格式转换将txt文件转换为excel
library(openxlsx)
rm(list = ls())
setwd("E:/售后/王秀玲_小麦/")
input_files <- read.xlsx("事件文件.xlsx")
anno <- read.xlsx("anno.xlsx")

files <- c("ACKVSCCK","ACKVSCT","ATVSACK","ATVSCCK","ATVSCT","BCKVSCCK","BCKVSCT",
           "BTVSBCK","BTVSCCK","BTVSCT","CTVSCCK","DCKVSCCK","DCKVSCT","DTVSCCK",
           "DTVSCT","DTVSDCK","ECKVSCCK","ECKVSCT","ETVSCCK","ETVSCT","ETVSECK")


for (file in files) {
  wd <- paste("E:/售后/王秀玲_小麦/", file ,"/", sep='')
  setwd(wd)
  
  for (variable in input_files$name) {
    a <- paste(wd,file,"_",variable,".txt",sep="")
    txt_data <- read.table(a, sep = "\t", header = T)
    asevent <- as.data.frame(txt_data)
    new_anno <- data.frame('GeneID' = anno[, "gene_id"], 
                           'GO' = anno[,'GO'],
                           'KEGG' = anno[,'KEGG'],
                           'EC' = anno[,'EC'],
                           'Description' = anno[,'Description'],
                           'trans_type' = anno[,'trans_type'])
    merged <- merge(asevent, new_anno, by='GeneID', all.x = TRUE, sort = FALSE)
    
    write.xlsx(merged, paste(file,"_",variable,"_anno.xlsx", sep = ""))
  }
}






























