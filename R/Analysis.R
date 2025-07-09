load("data/data_ready.Rdata")

library(tidyverse)
# ---- KPI ----

#Date
correct_date_data <- data %>% mutate(Project_Phase_Actual_Start_Date=lubridate::mdy(Project_Phase_Actual_Start_Date),
                                     Project_Phase_Actual_End_Date=lubridate::mdy(Project_Phase_Actual_End_Date),
                                     Project_Phase_Planned_End_Date=lubridate::mdy(Project_Phase_Planned_End_Date))

correct_date_data %>%  filter(Project_Phase_Actual_Start_Date > Project_Phase_Actual_End_Date) # No problem

correct_date_data %>% mutate(Completion_time = Project_Phase_Actual_End_Date-Project_Phase_Actual_Start_Date,
                             Planned_time = Project_Phase_Planned_End_Date-Project_Phase_Actual_Start_Date,
                             Delay_ratio = as.double.difftime(Completion_time) / as.double.difftime(Planned_time)) %>% 
  arrange(desc(Delay_ratio)) %>% view

correct_date_data %>% na.omit()


# Cost

data %>% colnames()

data %>% mutate(Project_Budget_Amount=as.double(Project_Budget_Amount),
                Cost_override= (Total_Phase_Actual_Spending_Amount - Project_Budget_Amount)/Project_Budget_Amount) %>% view
  
  