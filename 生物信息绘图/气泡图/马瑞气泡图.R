library(ggplot2)
library(openxlsx)
setwd("E:/售后/马瑞/马老师分析结果/JCEC/剪切事件富集分析")
data <- read.xlsx("go_scatterplot.xlsx",1)
View(data)


GO_Term <- factor(data$GO_Term)
type <- factor(data$Type,levels = c("A3SS", "A5SS","MXE", "RI", "SE", "ALL"))
Sig <- factor(data$Sig)

pl <- ggplot(data, aes(type,GO_Term))+
  geom_point(aes(size=Size,color=Sig))+
  theme(axis.text.x=element_text(colour='#FF66FF', size=10),
        axis.text.y=element_text(colour='#FF66FF', size=10))+
  theme(panel.border = element_rect(fill=NA, colour="black", size=0.8, linetype="solid"))+
  labs(color='Pvalue',size='Number of diff_exp_genes')+
  theme_bw()+
  theme(panel.grid.major=element_line(colour = 'gray'),panel.grid.minor=element_line(colour = 'gray'))
ggsave("KEGG_scatterplot.png", pl, width = 8.5, height = 6)
ggsave("KEGG_scatterplot.pdf", pl, width = 8.5, height = 6)