library(ggplot2)
library(tidyverse)
library(openxlsx)
library(RColorBrewer)
setwd("E:/售后/张永峰circRNA/张永峰/circRNA特征")
windowsFonts(A=windowsFont('Arial'))

data <- read.xlsx("circRNA_外显子统计.xlsx",2)
internal <- factor(data$size,levels = data$size)



getPalette = colorRampPalette(brewer.pal(9, "Set1"))
colourCount = length(unique(internal))

p <- ggplot(data) + geom_bar(aes(x=internal,y=num,fill=internal), stat = 'identity', width = 0.5)+
  theme(axis.text.y=element_text(family = 'A', face = 'plain', size=7, color = 'black'))+
  theme(axis.text.x=element_text(family = 'A', face = 'plain', size=7, color = 'black'))+
  theme(legend.text=element_text(family = 'A', face = 'plain', size=7))+
  theme(axis.title.x = element_text(hjust = 0.5, vjust = 0.5))+
  theme(axis.title.y = element_text(hjust = 0.5, vjust = 0.5))+
  labs(x='Exon number',y='circRNAs number', fill=NULL)+
  scale_fill_manual(values = getPalette(colourCount))+
  theme_bw()+
  theme(panel.border = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.line=element_line(size=0.5,colour='black'))+
  scale_y_continuous(expand = c(0.0075, 1))
  
ggsave("circRNA_外显子统计.png", p, width = 8, height = 7)
ggsave("circRNA_外显子统计.pdf", p, width = 8, height = 7)


