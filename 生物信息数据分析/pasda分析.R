library(openxlsx)
library(ggplot2)
setwd("E:/售后/PLADA/")
exp <- read.xlsx("exp.xlsx", 1, rowNames = T)
group <- read.xlsx("group.xlsx", 1, rowNames = T)


data <- read.xlsx("LRDSIVSHRDSI_Gene_differential_expression - 副本.xlsx", 1, rowNames = T)

#将矩阵转置
tdata <- t(data)
result <- plsda(tdata, group$a, ncomp = 2)
pl <- plotIndiv(result, ind.names = TRUE, ellipse = TRUE, legend = TRUE)
ggsave('pla.pdf', pl$graph, width = 10, height = 8)
ggsave('pla.png', pl$graph, width = 10, height = 8)