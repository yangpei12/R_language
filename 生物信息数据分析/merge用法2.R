library(openxlsx)
library(tidyverse)
setwd("E:/售后/王秀玲/")
anno <- read.xlsx('anno.xlsx', 1)

files <- c("ES_ACK1_CCK1_output.xlsx","ES_ACK1_CT1_output.xlsx","ES_AT1_ACK1_output.xlsx","ES_AT1_CCK1_output.xlsx","ES_AT1_CT1_output.xlsx","ES_BCK1_CCK1_output.xlsx","ES_BCK1_CT1_output.xlsx","ES_BT1_BCK1_output.xlsx","ES_BT1_CCK1_output.xlsx","ES_BT1_CT1_output.xlsx","ES_CT1_CCK1_output.xlsx","ES_DCK1_CCK1_output.xlsx","ES_DCK1_CT1_output.xlsx","ES_DT1_CCK1_output.xlsx","ES_DT1_CT1_output.xlsx","ES_DT1_DCK1_output.xlsx","ES_ECK1_CCK1_output.xlsx","ES_ECK1_CT1_output.xlsx","ES_ET1_CCK1_output.xlsx","ES_ET1_CT1_output.xlsx","ES_ET1_ECK1_output.xlsx")

for (file in files){
  data <- read.xlsx(file,1)
  merged <- merge(data, anno, by=1, all.x = TRUE, sort = F) #all.x = TRUE保留未merge上的
  output_path <- paste('Output/',file,sep = '')
  write.xlsx(merged, output_path, rowNames=F)
}

