library(openxlsx)
library(xgboost)
library(Matrix)
library(caret)
library(pROC)
setwd('E:/售后/机器学习/xgboost')
set.seed(23)
# ==========================================================
#
#                     step1. 读取数据
#
# ==========================================================
input_data <- read.xlsx('Input/xgboost_input_data.xlsx')

# 将第一列设置为行名
row.names(input_data) <- input_data$sample
input_data <- input_data[, -1]


# ==========================================================
#
#                     step3. 数据格式转换--交叉验证
#
# ==========================================================
traindata1_cv <- data.matrix(input_data[,c(1:ncol(input_data)-1)])

traindata2_cv <- Matrix(traindata1_cv,sparse = T)

# 将标签的数据类型设置为因子
input_data[, ncol(input_data)] <- factor(input_data[, ncol(input_data)])
train_y <- as.numeric(input_data[, ncol(input_data)])-1

# 自变量因变量拼接成list
traindata <- list(data=traindata2_cv, label=train_y)

# 将数据转换为模型所需要的格式
dtrain <- xgb.DMatrix(data = traindata$data, label = traindata$label)


# ==========================================================
#
#                     step4. 训练模型---交叉验证
#
# ==========================================================
watchlist <- list()
watchlist$eval <- dtrain
trainModel <- function(){
  cv_model <- xgb.cv(data=dtrain, 
                     booster='gbtree', 
                     objective = "binary:logistic", 
                     max_depth=10, 
                     eta = 0.1,
                     stratified = T, 
                     nfold = 7, 
                     nrounds = 50, 
                     metrics = 'auc', 
                     prediction = T, 
                     min_child_weight = 1,
                     min_split_loss = 0, 
                     random_state = 23,
                     best_ntreelimit=500,
                     watchlist = watchlist$eval)
  
  # 绘制AUC曲线
  #pdf("Output/ROC_Curve_plot.pdf",width=6,height = 6)
  it <-  which.max(cv_model$evaluation_log$test_auc_mean)
  best_iter = cv_model$evaluation_log$iter[it]
  
  plot(roc(response = train_y,
           predictor = cv_model$pred,
           levels=c(0, 1)),lwd=1.5,print.auc=TRUE,
       grid=c(0.1, 0.2), col="blue",main="ROC Curve") 
  #dev.off()
  
  # 计算混淆矩阵
  confusionMatrixInfo <- confusionMatrix(factor(ifelse(cv_model$pred <= 0.5, 0, 1)), factor(train_y))
  return(confusionMatrixInfo$byClass)
}


# 导出信息
write.table(data.frame(confusionMatrixInfo$byClass), 
            'Output/confusionMatrixInfo_1.txt', quote = FALSE)

write.table(data.frame(confusionMatrixInfo$byClass), 
            'Output/confusionMatrixInfo_1.txt', quote = FALSE)

write.table(data.frame(confusionMatrixInfo$overall), 
            'Output/confusionMatrixInfo_overall.txt', quote = FALSE)
save.image(file="Output/session_xgboost.RData")
# 导出重要特征











# ========================== 非交叉验 证================================

# ==========================================================
#
#                     step2. 划分数据集--非交叉验证
#
# ==========================================================


# 数据切分，将数据划分为训练集train_set和测试集test_set
data_spliced <- createDataPartition(input_data$category, p=0.8, list = FALSE)
train_set <- input_data[data_spliced, ]
test_set <- input_data[-data_spliced, ]


# ==========================================================
#
#                     step3. 数据格式转换--非交叉验证
#
# ==========================================================


# ==== step3.1 训练集合数据转换 ====

traindata1 <- data.matrix(train_set[,c(1:ncol(train_set)-1)])

traindata2 <- Matrix(traindata1,sparse = T)

# 将标签的数据类型设置为因子
train_set[, ncol(train_set)] <- factor(train_set[, ncol(train_set)])
train_y <- as.numeric(train_set[, ncol(train_set)])-1

# 自变量因变量拼接成list
traindata <- list(data=traindata2, label=train_y)

# 将数据转换为模型所需要的格式
dtrain <- xgb.DMatrix(data = traindata$data, label = traindata$label)


# ==== step3.2 测试集数据转换 ====
testdata1 <- data.matrix(test_set[,c(1:ncol(test_set)-1)])

testdata2 <- Matrix(testndata1, sparse = T)

# 将标签的数据类型设置为因子
test_set[, ncol(test_set)] <- factor(test_set[, ncol(test_set)])
test_y <- as.numeric(test_set[, ncol(test_set)])-1

# 自变量因变量拼接成list
traindata <- list(data=testdata2, label=test_y)

# 将数据转换为模型所需要的格式
dtest <- xgb.DMatrix(data = testdata$data, label = testdata$label)





