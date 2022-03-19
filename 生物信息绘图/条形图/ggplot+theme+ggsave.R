library(ggplot2)
library(openxlsx)
setwd("E:/售后/喻芳")
windowsFonts(A=windowsFont('Arial'))
rm(list=ls())
path <- "E:/售后/喻芳/total.xlsx"
data <- read.xlsx(path,3)
f <- factor(data$gene_name, levels = data$gene_name)

pl <- ggplot(data) + 
  geom_bar(mapping = aes(x = f, y= fc, fill=class), stat = 'identity', width =0.7)+
  theme(axis.text.x=element_text(family = 'A', angle = 45, hjust=0.85, vjust = 0.8, face = 'plain', color = 'black', size=7))+
  scale_x_discrete(breaks=c("NA","Igkv8-24","NA","Ighv14-2","NA","Igkv4-91","NA","Igkv4-59","NA","Igkv10-94","NA","Ighv1-55","NA","Ighv8-8","NA","Igkv3-10","NA","Ighv5-17","NA","Ighv10-1","NA","Igkv4-70","NA","Ighv1-59","NA","Igkv6-20","NA","Ighv14-3","NA","Ngp","NA","Igkv5-45","NA","Ighv2-3","NA","Igkv4-80","NA","Ighv8-12","NA","Ighv5-4","NA","Ighv1-54","NA","Ighv14-1","NA","Ighv9-2","NA","Ighv1-19","NA","Igkv1-88","NA","Ighv1-85","NA","Igkv8-16","NA","Ighv1-75","NA","Igkv4-79","NA","Ighv5-9","NA","Ighv1-66","NA","Ighv1-61","NA","Igkv1-133","NA","Igkv6-29","NA","Ighv1-78","NA","Ighv1-58","NA","Ighv5-9-1","NA","Ighv9-4","NA","Retnlg","NA","Ighv9-1","NA","Ighv6-6","NA","Ighv2-9","NA","Igkv3-7","NA","Ighv4-1","NA","Igkv8-21","NA","Ighv1-4","NA","Ighv2-5","NA","Ighv10-3","NA","Igkv17-121","NA","Ighv1-81"), expand = c(0.015, 0))+
  theme(axis.text.y=element_text(family = 'A', face = 'plain', size=7, color = 'black'))+
  theme(legend.text=element_text(family = 'A', face = 'plain', size=7))+
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  labs(x=NULL, fill=NULL, y='Log2 Fold Change') +
  scale_y_continuous(expand = c(0.1, 0)) +
  scale_fill_manual(values = c('#66FFCC', '#000000'))+
  guides(fill=guide_legend(reverse = T))   #修改图例的位置

ggsave("total.png", pl, width = 10, height = 3.5) #ggsave正确的使用方式ggsave(文件名字, ggplot对象, 宽度和高度)
ggsave("total.pdf", pl, width = 10, height = 3.5)
while (!is.null(dev.list()))  dev.off()


