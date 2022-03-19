library(tidyverse)
library(openxlsx)
library(ggplot2)
setwd("G:/王秀玲/WT_NVSWT_CK/")

files <- c("A3SS.MATS.JC.xlsx","A3SS.MATS.JCEC.xlsx","A5SS.MATS.JC.xlsx",
           "A5SS.MATS.JCEC.xlsx","MXE.MATS.JC.xlsx","MXE.MATS.JCEC.xlsx",
           "RI.MATS.JC.xlsx","RI.MATS.JCEC.xlsx","SE.MATS.JC.xlsx",
           "SE.MATS.JCEC.xlsx")
# 读入rmats输出结果文件
df <- data.frame()
for(file in files){
  data <- read.xlsx(file,1)
  padj <- as.numeric(data$FDR)
  df1 <- data.frame('FDR'=padj)
  filtered <- filter(df1,FDR<0.05)
  diff_num <- dim(filtered)[1]
  df <- rbind(df, data.frame('event'=file,'num'=diff_num))
}
write.xlsx(df, 'WT_NVSWT_CK_diff_AS_statics.xlsx',rowNames=F)

# 绘制条形图
setwd("G:/王秀玲/plot")

data2 <- read.xlsx("WT_NVSWT_CK_diff_AS_JCEC.xlsx",1)
event <- factor(data2$event,levels = data2$event)
pl <- ggplot(data = data2) + geom_bar(mapping = aes(x=event,y=num, fill=event),stat = 'identity', width = 0.7)+
    theme(axis.text.x = element_text(colour = 'black'))+
    geom_text(mapping = aes(label=num,x=event,y=num),vjust=-0.5)+
    theme_test()+
    guides(fill="none") 
ggsave("WT_NVSWT_CK_diff_AS_JCEC.png",pl, width = 6,height = 8)
