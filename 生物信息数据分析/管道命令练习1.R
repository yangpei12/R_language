library(dplyr)

# 管道命令练习
# 参数不是位于第一的位置，需要额外使用占位符


# 导入数据
data <- mtcars[,1]
# 计算最小值
min <- min(data)
# 生成随机数
rdn <- runif(n = 20, min = min, max = 100)

# 使用管道操作符
mtcars %>%
  pluck(1) %>%
  min() %>%
  runif(n = 20, ., max = 100) -> rdn