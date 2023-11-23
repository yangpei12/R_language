library(OmicsPLS)
library(magrittr) 
library(ggplot2)
library(openxlsx)

setwd('E:/售后/多组学测试/o2pls_test')

# ==== 1. 读取数据 ==== 

mRNA_exp_matrix <- read.xlsx('o2pls_mRNA.xlsx', rowNames = T)
meta_exp_matrix <- read.xlsx('o2pls_meta.xlsx', rowNames = T)

# ==== 2. 数据归一化 ====
mRNA_exp_matrix_scaled <-  scale(t(mRNA_exp_matrix), scale=F)
meta_exp_matrix_scaled <-  scale(t(meta_exp_matrix), scale=F)

# ==== 3. 模型构建 ==== 
set.seed(123)

# nr_folds应小于等于样本数
cross_validtion <- crossval_o2m(mRNA_exp_matrix_scaled, meta_exp_matrix_scaled, 
             a = c(2:5), ax = c(1:3), ay = c(1:3), nr_folds = 6) 


# 基于交叉验证结果确定成分数目参数
modelfit <- o2m(mRNA_exp_matrix_scaled, meta_exp_matrix_scaled, 
              n = 2, nx = 1, ny = 1)  

print (modelfit)

# 自变量物种变量筛选及绘图
xj <- loadings(modelfit, "Xjoint", 1:2) %>% abs %>% rowSums


xj[-(order(xj,decreasing=T)[1:5])] = 0
xj <- sign(xj)

plot(modelfit, loading_name="Xj", i=1, j=2, label = "c", use_ggplot2 = TRUE,
     alpha = xj,
     aes(label = stringr::str_sub(colnames(mRNA_exp_matrix_scaled), start = 1)),size=4,col='red')+
  theme_bw() +
  coord_fixed(1, c(-1,1),c(-1,1)) +
  geom_point(alpha = 0.5+0.5*xj, col = 'blue',size=1.5) +
  labs(title = "mRNA joint loadings",
       x = "First Joint Loadings", y = "Second Joint Loadings") +
  theme(plot.title = element_text(face='bold'))

ggsave('mRNA_joint_loadings.png', width = 6, height = 6)
ggsave('mRNA_joint_loadings.pdf', width = 6, height = 6)        
        
# 因变量代谢物筛选及绘图
yj<- loadings(modelfit, "Yjoint", 1:2) %>% abs %>% rowSums
yj[-(order(yj,decreasing=T)[1:10])] = 0
yj <- sign(yj)

plot(modelfit, loading_name="Yj", i=1, j=2, label = "c", use_ggplot2 = TRUE,
     alpha = yj,
     aes(label = stringr::str_sub(colnames(meta_exp_matrix_scaled), start = 1)),size=4,col='red')+
  theme_bw() +
  coord_fixed(1, c(-1,1),c(-1,1)) +
  geom_point(alpha = 0.5+0.5*yj, col = 'blue',size=1.5) +
  labs(title ="metabolite joint loadings",
       x = "First Joint Loadings", y = "Second Joint Loadings") +
  theme(plot.title = element_text(face='bold'))
ggsave('metabolite_joint_loadings.png', width = 6, height = 6)
ggsave('metabolite_joint_loadings.pdf', width = 6, height = 6)


# 输出自变量的载荷表
x_loding <- loadings(modelfit, "Xjoint", 1:2)
x_loding_table <- data.frame('X'=rownames(x_loding), 'Loading_1'=x_loding[,1], 'Loading_2'=x_loding[,2])
write.table(x_loding_table, 'x_loding_table.txt', sep = '\t', quote = F, row.names = F)

# 输出因变量的载荷表
y_loding <- loadings(modelfit, "Yjoint", 1:2)
y_loding_table <- data.frame('Y'=rownames(y_loding), 'Loading_1'=y_loding[,1], 'Loading_2'=y_loding[,2])
write.table(y_loding_table, 'y_loding_table.txt', sep = '\t', quote = F, row.names = F)        

# 绘制联合载荷图
x_loding_table['Type'] <- 'mRNA'
y_loding_table['Type'] <- 'metabolite'

x_y <- rbind(x_loding_table[,2:4], y_loding_table[,2:4])

ggplot(x_y) + geom_point(mapping = aes(x=Loading_1, y=Loading_2, color=type, shape=type),size=3)+
  labs(x='First Joint Loadings', y='Second Joint Loadings', subtitle='Top joint loading')+ 
  theme_test()+
  geom_hline(yintercept = 0, linetype='dashed')+ geom_vline(xintercept = 0, linetype='dashed')+
  geom_text(mapping = aes(x=Loading_1, y=Loading_2, label=row.names(x_y)), 
            size=1.5, vjust=0.1, hjust=-0.1)

ggsave('Top_joint_loadings.png', width = 10, height = 8)
ggsave('Top_joint_loadings.pdf', width = 10, height = 8)