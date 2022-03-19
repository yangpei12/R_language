library(openxlsx)
library(tidyverse)
library(dplyr)
rm(list=ls())
path="D:/R/test_file/sorted_test.xlsx"

data <- read.xlsx(path, sheet=1)
plot_data <- data[, c(1,3)]

ggplot(plot_data)+
  geom_point(mapping = aes(x=factor(source), y=weight))+  #传递x轴y轴数据
  theme(axis.title.x=element_text(colour = 'blue'), #axis.title.x参数表示的是坐标轴标题，所以需要使用的函数是element_text修改
        axis.title.y=element_text(colour = 'red'), #axis.title.x参数表示的是坐标轴标题，所以需要使用的函数是element_text修改
        axis.ticks.x=element_line(colour = 'orange'),#axis.ticks.x参数表示的是坐标轴刻度，所以需要使用的函数是element_line修改
        axis.text.x=element_text(colour = 'red'))#axis.text.x参数表示的是坐标轴标签，所以所以需要使用的函数是element_text修改
  
  
  


