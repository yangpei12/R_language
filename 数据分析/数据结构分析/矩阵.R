# 创建矩阵的语法
# mymatrix <- matrix(vector,nrow = N,ncol = N, byrow = T/F, dimnames=list(char_vector_rownames, char_vector_colnames)

mymatrix <- matrix(c(1:12), 
                   nrow = 3, ncol = 4, 
                   dimnames=list(c('one','two','three'), c('a','b','c','d')))


# 数组
# 创建3个维度的2行3列的数组
myarray <- array(c(1:18), dim = c(2,3,3))

# 创建数据框
City_Id <- c(1,2,3,4)
Post_Id <- c('0371', '0311', '0334', '0441')
City_Name <- c('HenNan', 'HeBei', 'ShanXi', 'LiaoNing')
Capital <- c('ZhengZhou', 'ShiJiaZhuang', 'XiAn', 'ShenYang')
Population <- c('1000', '987', '874', '511')

City <- data.frame(Post_Id, City_Name, Capital, Population, row.names = City_Id)

with(City, {
  print(City_Name) 
  old_population <- Population
  })

print(old_population)
  
# 将数值型变量转换为因子，例如在学校的教务系统中将男生编码为1，女生编码为2，
# 但是在某些情况下我们需要显式表示男女，因此需要将数值型变量转换为因子
# 系统对男女的编码
sex_system_code <- c(1,1,1,2,2,1,2,2)

# 可读性别信息
readable_sex <- factor(sex_system_code, levels = c(1, 2), labels = c('boy', 'girl'))
print(readable_sex)

# 因子存储名义型（无序）变量diabetes
diabetes <- c("Type1", "Type2", "Type1", "Type1")
diabetes_factor <- factor(diabetes)
print(diabetes_factor)

# 因子存储有序型变量status
status <- c("Improved", "poor", "Excellent", "poor")
# 默认情况下的排序是按照字母进行排序的，某些情况下是不符合预期的，因此我们需要自定义顺序
# 例如我们统计了患者的身体状况以后，需要按照身体状况进行排序

# 在默认情况下"Improved"排在"Excellent"之前，但是默认是按照字母顺序进行排序的
status_default_ordered <- factor(status, ordered=TRUE)

print(status_default_ordered)

# 自定义排序，此处使用levels参数指定层级
status_customer_ordered <- factor(status, levels = c("poor", "Improved", "Excellent"))
print(status_customer_ordered)


# factor的意义：为离散型变量寻找适合的统计方法
# 例如我想统计某个班中有多少男生多少女生
# 入学信息统计
student_id <- c(1:6)
student_name <- c('a', 'b', 'c', 'd', 'e', 'f')
student_sex <- c('boy', 'girl', 'girl', 'girl', 'boy', 'boy')
student_city <- c('HenN', 'HuB', 'HenN', 'ShanD', 'ShanX', 'ShanX')

student_info <- data.frame(student_name, student_city, student_sex, row.names = student_id)
summary(student_sex)

student_sex_count <- factor(student_info$student_sex)

summary(student_sex_count)

# 创建一个列表
g <- "My First List"
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow=5)
k <- c("one", "two", "three")

# 对列表中的部分对象命名
mylist <- list(title=g, ages=h, j, k)

# 以索引形式提取列表中的值
print(mylist[1])
print(mylist[c(1,3)])

# 以变量名的形式提取列表中的值
print(mylist[])









