getwd()
library(tidyverse)
library(lubridate)

#import dataset
Selection <-read.csv('./Data/Raw/Company_Selection.csv', stringsAsFactors = FALSE)

#wrangle Selection data
#install.packages("janitor")

Selection.clean <- Selection %>% slice(5:111, 113:138) %>%
  select(c(X.2: X.9)) %>%
  rename("Company" = "X.2", "Industry" = "X.3", "Country" = "X.4", "Sales" = "X.5", "Profits" = "X.6",
         "Assets" = "X.7", "Market Value" = "X.8", "CDP Score 2019" = "X.9") %>% 
  slice(2:133)

#convert values to numeric
Selection.clean$Sales <- str_sub(Selection.clean$Sales, 2)
Selection.clean$Sales <- as.numeric(gsub(",", "", Selection.clean$Sales))

Selection.clean$Profits <- str_sub(Selection.clean$Profits, 2)
Selection.clean$Profits <- as.numeric(gsub(",", "", Selection.clean$Profits))

Selection.clean$Assets <- str_sub(Selection.clean$Assets, 2)
Selection.clean$Assets <- as.numeric(gsub(",", "", Selection.clean$Assets))

Selection.clean$`Market Value` <- str_sub(Selection.clean$`Market Value`, 2)
Selection.clean$`Market Value` <- as.numeric(gsub(",", "", Selection.clean$`Market Value`))

#save
write.csv(Selection.clean, file = './Data/Processed/Company_Selection_Clean.csv', row.names = FALSE)





