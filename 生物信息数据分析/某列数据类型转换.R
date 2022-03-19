library(tidyverse)
library(openxlsx)
setwd("D:/R/test_file/数据转换")
input_data <- read.xlsx("A3SS.MATS.JC.xlsx",1)
input_data$FDR <- as.numeric(input_data$FDR) # 直接转换数据框中某一列变量的数据类型
input_data$FDR <- as.numeric(input_data$FDR)
input_data$geneSymbol <- gsub("\"","",input_data$geneSymbol)
input_data$GeneID <- gsub("\"","",input_data$GeneID)


fdr <- input_data[input_data$FDR<0.05,] # 使用布尔索引进行筛选




# 使用sapply对rmats的输出结果进行格式转换，并使用subset进行筛选
# sapply可对list类型进行转换，也就是sapply函数中的x参数可以是列表格式，因此我们可将需要修改的列/行放进列表中
attach(input_data)
ls <- list('Pvalue'=PValue,
           'FDR'=FDR,
           'IncLevelDifference'=IncLevelDifference)
# sapply需要两个参数X,FUN,其中X可以是列表，FUN则是函数，也就是将列表中的每一个元素应用到函数中，因此我们创建的列表，这个列表中变量可以是我们数据框中某一列数据，因此一个列表可以放进去多个变量数据，也就实现了同时对数据框中的多列同时传递进函数中
df <- sapply(ls, as.numeric)
detach(input_data)

input_data$PValue <- df[,'Pvalue']
input_data$FDR <- df[,'FDR']
input_data$IncLevelDifference <- df[,'IncLevelDifference']

# 使用subset进行筛选，第一个参数为数据，参数subset为比较表达式，也就是选择子集的条件，select参数为选择保留哪几列数据
subset(df,subset = df[,'FDR']<0.05, select = c(Pvalue,FDR))

write.xlsx(input_data,'A3SS.MATS.JC.out2.xlsx', rowNames=F)
