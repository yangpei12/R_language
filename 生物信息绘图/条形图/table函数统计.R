library(ggplot2)
library(tidyverse)
library(openxlsx)
setwd("E:/售后/李淑霞/CKVSSVSSM")
gene_exp <- read.xlsx("CKVSSVSSM_Gene_differential_expression.xlsx",1)

a <- table(gene_exp$family)
write.xlsx(a,"CKVSSVSSM_Gene_differential_expression_family.xlsx")




family <- read.xlsx("MVSCK_Gene_differential_expression_family.xlsx")

bar <- ggplot(data = family) + 
  geom_bar(mapping = aes(x = family, y = count, fill=family), stat = 'identity', width = 0.5)+
  theme(axis.text.x=element_text(size=2,colour = 'red'))

#geom_text(mapping=aes(x = family,y = count, label = count))  #geom_text(mapping = aes(label=number, fontface=face)
            
p <- bar + coord_polar()+theme_bw()

ggsave("CKVSSVSSM_Gene_differential_expression_family.png", p, width = 20, height = 9)
ggsave("CKVSSVSSM_Gene_differential_expression_family.pdf", p, width = 20, height = 9)