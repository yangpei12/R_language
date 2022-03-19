# 创建一个数据集
name <- c('a', 'b', 'c', 'd')
age <- c(11, 12, 11, 11)
add <- c('HN', 'HB', 'AH', 'ZJ')
mark <- c('Good', 'Poor', 'Good', 'Comon')
df <- data.frame(row.names = name, age, add, mark)
tb <- table(df$age, df$add)
print(tb)


mark <- c('Good', 'Poor', 'Good', 'Comon', 'Poor', 'Comon')

# factor可为类别型变量创建值标签
# 如下所示，可设置level与labels为mark创建值标签，其中levels需要填入的是类别量的名称（去重后），
# 然后labels填入的是新的标签，其长度要与levels的长度相同
f <- factor(mark, levels = c('Poor', 'Comon', 'Good'), labels = c('a', 'b', 'c'))
print(f)

