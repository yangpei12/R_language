library(ggplot2)
library(openxlsx)
library(reshape2)
library(ggpubr)
setwd('E:/售后/胡灿/箱线图/ssGSEA_estimate')
bar_data <- read.xlsx('estimate.xlsx')
melt_data <- melt(bar_data, id.vars = 'group')


melt_data <- rename(melt_data, variable_x = variable)
# 统计分析
melt_data_p_val <- melt_data %>% group_by(variable_x) %>%
  wilcox_test(value~group) %>%
  adjust_pvalue(p.col = "p") %>%
  add_significance(p.col = "p") %>% 
  add_xy_position('group')

Group = factor(melt_data$group)
# 画图
ggplot(melt_data) + geom_boxplot(aes(group,value,fill = group),position=position_dodge(width =0.2),width=0.4)+
  theme_classic()+
  stat_pvalue_manual(melt_data_p_val,label = "p.adj.signif",label.size=6,hide.ns = T)+
  scale_size_continuous(range=c(1,3))+
  facet_wrap(.~variable_x,nrow=1, strip.position = "bottom")+
  theme(strip.placement = "outside")+
  theme(axis.text.x = element_blank())+
  theme(strip.text = element_text(angle = 90, color = 'black', size=10),
        strip.background = element_blank())+
  labs(x='Cell Type', y = 'Estimate Proportion', fill = 'Cluster')

ggsave('estimate.png', width = 8, height = 8)
ggsave('estimate.pdf', width = 8, height = 8)

  
  


   

















