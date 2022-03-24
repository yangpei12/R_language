# 数据重编码
library(openxlsx)
library(tidyverse)
setwd("E:/售后/于霞")
rm(list = ls())
data <- read.xlsx("test.xlsx")

# 数据重编码
data$POP_D1_srpbm[data$POP_D1_srpbm==0] <- 0.000001
data$POP_D2_srpbm[data$POP_D2_srpbm==0] <- 0.000001
data$POP_D3_srpbm[data$POP_D3_srpbm==0] <- 0.000001
data$POP_D4_srpbm[data$POP_D1_srpbm==0] <- 0.000001
data$POP_D5_srpbm[data$POP_D5_srpbm==0] <- 0.000001
data$POP_D6_srpbm[data$POP_D6_srpbm==0] <- 0.000001
data$Control_D1_srpbm[data$Control_D1_srpbm==0] <- 0.000001
data$Control_D2_srpbm[data$Control_D2_srpbm==0] <- 0.000001
data$Control_D3_srpbm[data$Control_D3_srpbm==0] <- 0.000001
data$Control_D4_srpbm[data$Control_D4_srpbm==0] <- 0.000001
data$Control_D5_srpbm[data$Control_D5_srpbm==0] <- 0.000001
data$Control_D6_srpbm[data$Control_D6_srpbm==0] <- 0.000001


#

df <- data.frame()
for (i in seq(dim(data)[1])){
  treat_fpkm <- sum(data[i,'POP_D1_srpbm'],data[i,'POP_D2_srpbm'],data[i,'POP_D3_srpbm'],
                    data[i,'POP_D4_srpbm'],data[i,'POP_D5_srpbm'],data[i,'POP_D6_srpbm'])
  
  cont_fpkm <- sum(data[i,'Control_D1_srpbm'],data[i,'Control_D2_srpbm'],data[i,'Control_D3_srpbm'],
                   data[i,'Control_D4_srpbm'],data[i,'Control_D5_srpbm'],data[i,'Control_D6_srpbm'])
  fold_change = treat_fpkm/cont_fpkm
  
  df <- rbind(df, data.frame('FC'=fold_change,
                       'Log2fc'=log2(fold_change)))
}

mutate(data, FC=df$FC,Log2fc=df$Log2fc) %>% write.xlsx(.,'test_out.xlsx')
