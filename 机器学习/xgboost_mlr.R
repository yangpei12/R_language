library(mlr)
library(tidyverse)
library(openxlsx)
# 设置工作路径
setwd('E:/售后/机器学习/xgboost')

# 读取数据
input_data <- read.xlsx('Input/xgboost_input_data_R.xlsx')

# 将第一列设置为行名
row.names(input_data) <- input_data$sample
input_data <- input_data[,-1]
xgbTib <- as_tibble(input_data)

# 定义学习器
xgb <- makeLearner('classif.xgboost')

# 定义学习任务
xgbTask <- makeClassifTask(data = xgbTib, target = 'category')

# 设置超参数
xgbParamSpace <- makeParamSet(
  makeNumericParam('eta', lower = 0.01, upper = 0.1),
  makeNumericParam('gamma', lower = 0, upper = 1),
  makeIntegerParam('max_depth', lower = 1, upper = 5),
  makeNumericParam('min_child_weight', lower = 1, upper = 10),
  makeNumericParam('subsample', lower = 0.5, upper = 1),
  makeIntegerParam('nrounds', lower = 20, upper = 20),
  makeDiscreteParam('eval_metric', values = c('auc'))
)

library(parallelMap)
library(parallel)
parallelStartSocket(cpus = 6)

# 定义超参数随机搜索模式
randSearch <- makeTuneControlRandom(maxit = 100)

# 设置交叉验证的采样模式
cvForTuning <- makeResampleDesc(method  = 'RepCV', folds = 5, reps=10, stratify = TRUE)

# 对模型构建过程进行交叉验证
outer <-  makeResampleDesc('CV', iters=10)
xgbWrapper <- makeTuneWrapper(xgb, resampling = cvForTuning, 
                              par.set = xgbParamSpace,
                              control = randSearch)
cvWithTuning <- resample(xgbWrapper, xgbTask, resampling = outer)
parallelStop()

# 训练最终的xgboost模型
tunnedXgb <- setHyperPars(xgb, par.vals = tunn)
# 绘制损失函数
xgbModelData <- getLearnerModel()











