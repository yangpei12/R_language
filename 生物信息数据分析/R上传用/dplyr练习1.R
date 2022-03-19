library(tidyverse)
library(nycflights13)
vars <- c(
  "year", "mon", "day", "dep_delay", "arr_delay"
)

select(flights, all_of(vars))

select(flights,"year", "year", "month")

# 使用select选择变量构建新的数据框
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)

# 使用mutate将新列添加到已有数据框的最后，新列有gain speed
mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)

# 使用transmute只保留新变量
transmute(flights, gain = arr_delay - dep_delay,hours = air_time / 60, gain_per_hour = gain / hours)
