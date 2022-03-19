# 相关性分析
library(Hmisc)
library(tidyverse)
mydata <- mtcars[, c(1,3,4,5,6,7)]
dataA <- mydata[1:4, ]
dataB <- mydata[6:7, ]
t_A <- t(dataA)
t_B <- t(dataB)
corr_data <- rcorr(as.matrix(t_A), as.matrix(t_B))
Rho <- as.data.frame(corr_data$r)
Pvalue <- as.data.frame(corr_data$P)

df_rho <- data.frame()
for (i in seq(length(Rho))) {
  df_rho <- rbind(df_rho, data.frame(node1=row.names(Rho),
                             node2=rep(colnames(Rho)[i],length(Rho)),
                             rho=Rho[,i]))
}

df_pvalue <- data.frame()
for (i in seq(length(Pvalue))) {
  df_pvalue <- rbind(df_pvalue, data.frame(node1=row.names(Pvalue),
                                 node2=rep(colnames(Pvalue)[i],length(Pvalue)),
                                 pvalue=Pvalue[,i]))
}
correlation_2 <- na.omit(cbind(df_rho,df_pvalue$pvalue))


