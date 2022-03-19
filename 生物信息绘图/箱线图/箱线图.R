#使用ggplot绘制箱线图。
library('ggplot2')
library('openxlsx')
rm(list = ls())

# 使用ggplot绘制多组比较的箱线图，

f <- factor(mtcars$gear)

# 未使用labs函数修改标题前
ggplot(mtcars) + geom_boxplot(aes(x=f, y=mpg, fill=f))

# 使用labs函数对标签进行各种修改
ggplot(mtcars) + geom_boxplot(aes(x=f, y=mpg, fill=f))+
  labs(x='Gear', y='Mpg', fill='Group', # 这三个参数与aes的参数相对应
       title = 'This is a boxplot for mtcars', # 添加主标题
       subtitle = 'Boxplot', #添加副标题
       caption = "(this based on matcars datasets)" # 添加字幕
       )+
  scale_x_discrete(breaks = c(3,4), limits=factor(3,4))

