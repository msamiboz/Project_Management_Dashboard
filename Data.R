renv::init()
library(tidyverse)
data <- read_csv("Capital_Project_Schedules_and_Budgets_20250705.csv")

#fixed the colnames
cnames <- data %>% colnames()
cnames_new <- cnames %>% gsub(x = .," ","_")
colnames(data) <- cnames_new
data

#Examine the data
data %>% view()
str(data)

data %>% distinct(Project_Building_Identifier,
                  Project_School_Name,
                  Project_Description,Project_Phase_Name,`DSF_Number(s)`)

data %>% group_by(Project_Building_Identifier,Project_School_Name,
                  Project_Description,Project_Phase_Name,`DSF_Number(s)`) %>% 
  summarise(count=n()) %>% filter(count>1)


data %>% filter(Project_Building_Identifier=="K680") %>% view()

summary