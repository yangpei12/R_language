library(ggplot2)
library(openxlsx)
setwd("E:/售后/于霞4/于霞/lianhe/YY")
data <- read.xlsx("YY_meta_mRNA_enrichment.xlsx",1)


Pathway_name <- factor(data$Pathway_name)
Type <- factor(data$Type)

pl <- ggplot(data, aes(Pvalue,Pathway_name))+
  geom_point(aes(size=Size,color=Type))+
  theme(axis.text.x=element_text(color='black', size=10),
        axis.text.y=element_text(color='black', size=10))+
  theme(panel.border = element_rect(fill=NA, color="black", size=0.8, linetype="solid"))+
  labs(color='Pvalue')+
  theme_bw()
ggsave("KEGG_scatterplot.png", pl, width = 7.5, height = 6)
ggsave("KEGG_scatterplot.pdf", pl, width = 7.5, height = 6)

