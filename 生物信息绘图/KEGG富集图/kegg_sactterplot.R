library(ggplot2)
library(openxlsx)

setwd("D:/R/test_file")
data <- read.xlsx('kegg_scatterplot.xlsx', 1)
#View(data)
richfactor <- data$S.gene.number/data$B.gene.number

p <- ggplot(data = data) + geom_point(aes(x=richfactor, y=pathway_name, size=S.gene.number, colour=pvalue))+
  scale_colour_gradient(low = 'darkblue', high = 'red')+
  theme(axis.text.y = element_text(face = 'bold', color='black'), 
        axis.text.x = element_text(face = 'bold', color='black'),
        axis.title.x = element_text(hjust=0.3, vjust = 0.5)) 
ggsave('kegg_scatterplot.png', p, width = 10, height = 8)

ggplot(Oxboys, mapping=aes(x=age, y=height))+
  geom_point() + geom_line()
ggsave('oxboys.png', p2, width = 10, height = 8)

ggplot(Oxboys, aes(age, height, group=Subject))+
  geom_line()+
  geom_smooth(method = "lm", se=FALSE)

