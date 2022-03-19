# 练习使用scale_x_continuous与scale_x_discrete的区别

# 因子化cyl变量，需要使用scale_x_discrete重新将x轴的刻度进行映射，因为因子化变量以后，该变量下的数字会被设置为离散型，因此在进行刻度映射时，break
# 刻度可不用factor按正常进行就行，
# 而limits参数则需要提供factor后的数据，limmits参数的主要作用是显示哪些刻度标签对应的数据。
# 例如在scale_x_discrete(breaks = c(1:8), limits = factor(c(4,8)))中x轴的长度是c(1:8)，而limits参数的使用首先需要用户知道自己传入X轴的数据是离散的还是连续的，如果是连续的则limits参数传入向量即可，如果是离散型变量，则需要传入离散型变量，显示范围视离散型变量所处的范围而定

f <- factor(mpg$cyl)
ggplot(data = mpg) + aes(x=f, y=displ) + geom_point() + scale_x_discrete(breaks = c(1:8), limits = factor(c(4,5,6,8)))
ggplot(data = mpg) + aes(x=f, y=displ) + geom_point() + scale_x_discrete(breaks = c(1:8), limits = factor(c(4,8)))

# 不因子化cyl变量
ggplot(data = mpg) + aes(x=cyl, y=hwy) + geom_point() + scale_x_continuous

