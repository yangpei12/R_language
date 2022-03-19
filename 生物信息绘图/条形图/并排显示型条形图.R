library(ggplot2)
library(openxlsx)
rm(list=ls())
path <- "E:/ÊÛºó/Ó÷·¼/total.xlsx"
data <- read.xlsx(path,1)
View(data)
x_data <- factor(data$gene_name, levels = c("Igkv8-24","Ighv14-2","Igkv4-91","Igkv4-59","Igkv10-94","Ighv1-55","Ighv8-8","Igkv3-10","Ighv5-17","Ighv10-1","Igkv4-70","Ighv1-59","Igkv6-20","Ighv14-3","Ngp","Igkv5-45","Ighv2-3","Igkv4-80","Ighv8-12","Ighv5-4","Ighv1-54","Ighv14-1","Ighv9-2","Ighv1-19","Igkv1-88","Ighv1-85","Igkv8-16","Ighv1-75","Igkv4-79","Ighv5-9","Ighv1-66","Ighv1-61","Igkv1-133","Igkv6-29","Ighv1-78","Ighv1-58","Ighv5-9-1","Ighv9-4","Retnlg","Ighv9-1","Ighv6-6","Ighv2-9","Igkv3-7","Ighv4-1","Igkv8-21","Ighv1-4","Ighv2-5","Ighv10-3","Igkv17-121","Ighv1-81"
))
ggplot(data) + 
  geom_bar(mapping = aes(x = x_data, y= fc), stat = 'identity', fill='orange') + 
  theme(axis.text.x=element_text(family = 'A', angle = 45, hjust=1, vjust = 0.5))+
  scale_y_continuous(expand = c(0,0.5))

  