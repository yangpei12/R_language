library(OmicsPLS)
library(magrittr) 
library(ggplot2)
library(openxlsx)

setwd('/Users/yangpei/YangPei/after_sale/多组学测试')

# ==== 1. 读取数据 ==== 

mRNA_exp_matrix <- read.table('Output/mRNA_exp_matrix.txt', sep = '\t', header = T)
meta_exp_matrix <- read.table('Output/meta_exp_matrix.txt', sep = '\t', header = T)

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

# 自变量筛选
xj <- loadings(modelfit, "Xjoint", 1:2) %>% abs %>% rowSums

xj[-(order(xj,decreasing=T)[1:5])] = 0
xj <- sign(xj)
print(xj)
plot(modelfit, loading_name="Xj", i=1, j=2, label = "c", use_ggplot2 = TRUE,
     alpha = xj,
     aes(label = stringr::str_sub(colnames(mRNA_exp_matrix_scaled), start = 1)),size=4,col='red')+
  theme_bw() +
  coord_fixed(1, c(-1,1),c(-1,1)) +
  geom_point(alpha = 0.5+0.5*xj, col = 'blue',size=1.5) +
  labs(title = "taxonomy joint loadings",
       x = "First Joint Loadings", y = "Second Joint Loadings") +
  theme(plot.title = element_text(face='bold'))
        
        
# 因变量筛选
yj<- loadings(modelfit, "Yjoint", 1:2) %>% abs %>% rowSums
yj[-(order(yj,decreasing=T)[1:10])] = 0
yj <- sign(yj)
print (yj)
plot(modelfit, loading_name="Yj", i=1, j=2, label = "c", use_ggplot2 = TRUE,
     alpha = yj,
     aes(label = stringr::str_sub(colnames(meta_exp_matrix_scaled), start = 1)),size=4,col='red')+
  theme_bw() +
  coord_fixed(1, c(-1,1),c(-1,1)) +
  geom_point(alpha = 0.5+0.5*yj, col = 'blue',size=1.5) +
  labs(title ="metabolite joint loadings",
       x = "First Joint Loadings", y = "Second Joint Loadings") +
  theme(plot.title = element_text(face='bold'))






        
        
        
        
        
        
        
        
        
        