getwd()
library(tidyverse)
library(lubridate)

#import dataset
Energy.Usage <- read.csv('./Data/Raw/Emission_Predictors.csv', stringsAsFactors = FALSE)

#isolate values of interest
Energy.Usage.clean <- Energy.Usage %>% 
  slice(c(4, 32)) %>%
  select(-c(X:X.1)) #%>%
row_to_names(row_number = 1) 

#transpose data frame; rename columns
Energy.Usage.transposed <- 
  as.data.frame(t(Energy.Usage.clean)) %>%
  row_to_names(row_number = 1) %>%
  rownames_to_column() %>%
  slice(2:57) %>%
  select(-c("rowname"))

#convert values to numeric
Energy.Usage.transposed$`Total energy consumption`<- 
  as.numeric(gsub(",", "", Energy.Usage.transposed$`Total energy consumption`))

Energy.Usage.transposed.clean <- Energy.Usage.transposed.clean

#save
write.csv(Energy.Usage.transposed, file = './Data/Processed/Energy_Usage_Clean.csv', row.names = FALSE)
