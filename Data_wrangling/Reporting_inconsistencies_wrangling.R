library(tidyverse)


reporting_inconsistencies <- read.csv("./Data/Raw/Reporting_inconsistencies.csv")

reporting_inconsistencies_clean <- reporting_inconsistencies %>%
  select(X.2, X.4:X.49) %>%
  filter(row_number() >= 6)

colnames(reporting_inconsistencies_clean) <- reporting_inconsistencies_clean[1,]
reporting_inconsistencies_clean <- reporting_inconsistencies_clean[-1,] 


reporting_inconsistencies_clean <- reporting_inconsistencies_clean %>% pivot_longer(reporting_inconsistencies_clean,
                                        names_to = "Company", values_to = count)

reporting_inconsistencies_clean <- as.data.frame(t(reporting_inconsistencies_clean))

colnames(reporting_inconsistencies_clean) <- reporting_inconsistencies_clean[1,]
reporting_inconsistencies_clean <- reporting_inconsistencies_clean[-1,] 

reporting_inconsistencies_clean <- data.frame(names = row.names(reporting_inconsistencies_clean),
                                              reporting_inconsistencies_clean)

rownames(reporting_inconsistencies_clean)<-NULL

colnames(reporting_inconsistencies_clean)<- c("Company","Company.report","CDP", "Deviation")

reporting_inconsistencies_clean <- reporting_inconsistencies_clean %>%
  select(Company:Deviation) %>%
  na_if(" -   ")

reporting_inconsistencies_clean$Company.report <- gsub(",", "", reporting_inconsistencies_clean$Company.report)
reporting_inconsistencies_clean$CDP <- gsub(",", "", reporting_inconsistencies_clean$CDP)
reporting_inconsistencies_clean$Deviation <- gsub(",", "", reporting_inconsistencies_clean$Deviation)

reporting_inconsistencies_clean$Company.report <- as.numeric(reporting_inconsistencies_clean$Company.report)
reporting_inconsistencies_clean$CDP <- as.numeric(reporting_inconsistencies_clean$CDP)
reporting_inconsistencies_clean$Deviation <- as.numeric(reporting_inconsistencies_clean$Deviation)

reporting_inconsistencies_clean <- reporting_inconsistencies_clean %>%
mutate(Inconsistency_ratio = (Deviation/CDP))

write.csv(reporting_inconsistencies_clean, "./Data/Processed/Reporting_inconsistencies_processed.csv", row.names = F)