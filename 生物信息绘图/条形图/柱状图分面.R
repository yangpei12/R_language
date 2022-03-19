library(ggplot2)
library(openxlsx)
data <- read.xlsx("D:/R/test_file/barplot.xlsx",1)
View(data)

#载入数据，创建图层
ggplot(data) + geom_bar(mapping=aes(x=name, y=count, fill=type), stat = 'identity')+
  facet_grid(.~type, scales = "free_x")

rename <- c(big="very big", small="very small")


ggplot(data) + geom_bar(mapping=aes(x=name, y=count, fill=type), stat = 'identity', width = 0.5)+
  facet_wrap(~type, scales = "free_x",labeller = labeller(type=rename))+
  annotate('segment', x='a',xend='c', y=4.25, yend = 4.25)


anno <- data.frame(x1 = c(1.75, 0.75), x2 = c(2.25, 1.25), 
                   y1 = c(36, 36), y2 = c(37, 37), 
                   xstar = c(2, 1), ystar = c(38, 38),
                   lab = c("***", "**"),
                   region = c("North", "South"))



annoa <- data.frame(x1=c('a','d'), x2=c('c','g'),
                    y1=c(4.25,4.25),y2=c(4.25,4.25),
                    xstart=c('b','e'),ystart=c(4.5, 4.5),
                    lab=c('big','small'))

ggplot(data) + geom_bar(mapping=aes(x=name, y=count, fill=type), stat = 'identity', width = 0.5)+
  geom_segment(aes(x=x1,xend=x2,y=y1,yend=y2, color=lab), data = annoa)+
  geom_text(aes(x=xstart, y=ystart,label=lab),data=annoa,vjust='middle',hjust='left')
  



ann <- data.frame(x=c('big', 'small'))
  
ggplot(data) + geom_bar(mapping=aes(x=name, y=count, fill=type), stat = 'identity', width = 0.5)+
  annotate('segment', x='a',xend = 'c' ,y = 4.25, yend = 4.25)+
  annotate('text', x='b',y = 4.5,label='big')+
  annotate('segment', x='d',xend = 'g' ,y = 4.25, yend = 4.25)+
  annotate('text', x='e',y = 4.5,label='small')
  