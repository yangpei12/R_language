library(vioplot)
library(openxlsx)
path="E:/ÊÛºó/ÂíÀÖ/diff_expression_gene.xlsx"
data <- read.xlsx(path,1, rowNames = T)

gy0 <- log2(data$Gy0)
gy2 <- log2(data$Gy2)
gy4 <- log2(data$Gy4)
gy6 <- log10(data$Gy6)
gy8 <- log10(data$Gy8)
vioplot(gy0, gy2, gy4, gy6, gy8, names=c('Gy0', 'Gy2', 'Gy4', 'Gy6', 'Gy8'))

