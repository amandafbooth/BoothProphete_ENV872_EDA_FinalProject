library(tidyverse)
library(corrplot)
library(knitr)
#Load data

company_selection_clean <- read.csv("./Data/Processed/Company_Selection_Clean.csv")

Reporting_inconsistencies_processed <- read.csv("./Data/Processed/Reporting_inconsistencies_processed.csv")

Energy_Usage_Clean <- read.csv("./Data/Processed/Energy_Usage_Clean.csv")

#Join datasets 

company_profiles <- left_join(company_selection_clean, Reporting_inconsistencies_processed)

company_profiles <- left_join(company_profiles, Energy_Usage_Clean)

#Filter out 1.0 ratios 

company_profiles2 <- company_profiles[!is.na(company_profiles$Company.report),]
  

#Correlations 

correlation <- cor(company_profiles2 %>% select(Sales:Market.Value,
                    Inconsistency_ratio:Total.energy.consumption) %>% drop_na())

corrplot(correlation, method = "ellipse")


#Regressions


regression_assets_energy <- lm(data = company_profiles2, Total.energy.consumption ~ Assets)

regression_mv_energy <- lm(data = company_profiles2,  Total.energy.consumption ~ Market.Value)

regression_sales_energy <- lm(data = company_profiles2,  Total.energy.consumption ~ Sales)

regression_profits_energy <- lm(data = company_profiles2,  Total.energy.consumption ~ Profits)

regression_ratio_mv <- lm(data = company_profiles2,  Inconsistency_ratio ~ Market.Value)

summary(regression_assets_energy) #strongest relationship

summary(regression_mv_energy)

summary(regression_sales_energy)

summary(regression_profits_energy)

summary(regression_ratio_mv)

#Top 5 by inconsistency ratio 

top5 <- company_profiles2 %>% 
  slice_max(Inconsistency_ratio, n = 5) %>%
  select(Company, Inconsistency_ratio)

kable(top5, caption = "Top 5 Companies by Highest Reporting Inconsistency Ratio", align = 'l')


#Plots

options(scipen=5) 

Plot1 <- ggplot(company_profiles2, aes(x = Assets, y = Total.energy.consumption)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_log10() +
  scale_y_log10() +
  labs(x = "Value of assets (in millions)", y = "Total energy consumption (MWh)")
print(Plot1)


