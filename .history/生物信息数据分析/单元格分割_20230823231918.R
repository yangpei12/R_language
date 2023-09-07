library(openxlsx)
library(tidyverse)
setwd('E:/售后/马梅')
rna_data <- read.xlsx('CVSA_Gene_differential_expression.xlsx')

# 按照逐行扫描的方式进行拆分
# rowId参数：1，2，3，...dim(test_data)[1]
# splitedCol参数：需要进行分列的列
oneFun <- function(rowId, splitedCol, splited_symbol){
    gene_name <- rna_data[rowId, splitedCol]
    genes <- strsplit(rna_data[rowId,splitedCol], split = splited_symbol)
  
    # 在原始数据中保留除需要拆分的列
    rest_data <- rna_data[rowId,-grep(splitedCol, names(rna_data))]
  
    splitedData <- data.frame('gene_name' = unlist(genes))
    result <- cbind(splitedData, rest_data)
    return(result)
}

# 数据中行数
rowLength <- dim(rna_data)[1]


# 提前构造pmap的参数列表
## 需要分割的列名及分隔符
splited_col_name <- 'gene_name'
splited_symbol <- ';'

pmapParas <- list(seq(rowLength), rep(splited_col_name, rowLength), rep(splited_symbol, rowLength))


# 使用pmap函数将参数批量传递进去函数
result <- pmap(pmapParas, ~oneFun(..1,..2,..3)) %>% do.call(rbind,.)
write.xlsx(result, 'result.xlsx')

