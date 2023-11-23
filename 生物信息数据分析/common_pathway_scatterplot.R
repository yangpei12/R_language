# 绘制散点图
library(ggplot2)
setwd('/Users/yangpei/YangPei/after_sale/多组学测试')
point_data <- read.table('Output/common_pathway_result.txt', header = T, sep = '\t')
point_data['rich'] <- point_data$S/point_data$B

# 图片绘制
ggplot(point_data) + geom_point(mapping = aes(x= rich, y=Pathway, shape=type, 
                                              colour = Pvalue, size = S))+
  theme_bw()+ scale_colour_gradient(low="blue", high="red")+
  labs(x = 'Rich_Factor', shape = 'Type', colour = 'Pvalue')+
  theme(axis.text = element_text(colour = 'black', size=12))


ggsave('Output/common_pathway_scatterplot.png', width = 8, height = 6)
ggsave('Output/common_pathway_scatterplot.pdf', width = 8, height = 6)



