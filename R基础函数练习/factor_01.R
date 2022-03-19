# condition <- factor(c("E_6dB", "E_6dB", "M_6dB", "M_6dB", "M_6dB"))

rm(list=ls())
condition <- factor(c("E_6dB", "E_6dB","E_6dB", "M_6dB", "M_6dB", "M_6dB"))
col_name <- c('E_6dB_1', 'E_6dB_3', 'M_6dB_1', 'M_6dB_2', 'M_6dB_3')

df <- data.frame(row.names = col_name, condition)
print(df)