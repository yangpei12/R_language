library(ggplot2)
library(openxlsx)

data <- read.xlsx("D:/R/test_file/barplot.xlsx", 1)

big <- expression(underline('very big'))
small <- expression(underline('very small')))


ggplot(data) + geom_bar(mapping=aes(x=name, y=count, fill=type),stat = 'identity')+
  theme(axis.line=element_line(), plot.margin = margin(10,10,10,10),  
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank())+
  facet_grid(.~type, scales = "free_x", labeller = labeller(type=big))+
  theme(strip.text.x = element_text(angle = 0, lineheight=10))
  
plot(1:6, type = "n", axes = F, ann = F)+
  text(3,3, expression(x^2))










  