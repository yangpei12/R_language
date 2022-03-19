library(openxlsx)
input="E:/R ѧϰ/input/test_1.xlsx"
output="E:/R ѧϰ/output/test_1.txt"

data <- read.xlsx(path, 1)

for (name in colnames(data)) {
  result <- summary(data[name])
  print(table(result)
}
