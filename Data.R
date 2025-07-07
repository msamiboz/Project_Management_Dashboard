renv::init()
# ---- Load packages ----
library(tidyverse)
# ---- Load data ----
data <- read_csv("Capital_Project_Schedules_and_Budgets_20250705.csv")

# ---- Prep Data ----

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

summary(data)

# ---- Non data Labels ----

# Examine nondata(date or numeric)
t5 <- data %>% filter(is.na(as.numeric(Project_Budget_Amount))) %>%
  pull(Project_Budget_Amount) %>% na.omit() %>% 
  table(dnn = "Project_Budget_Amount") %>%
  as.data.frame() %>% rename(label=1,Project_Budget_Amount=2)

t4 <- data %>% filter(is.na(mdy(Project_Phase_Actual_End_Date))) %>%
  pull(Project_Phase_Actual_End_Date) %>% na.omit() %>% 
  table() %>%
  as.data.frame() %>% rename(label=1,Project_Phase_Actual_End_Date=2)

t3 <- data %>% filter(is.na(mdy(Project_Phase_Planned_End_Date))) %>%
  pull(Project_Phase_Planned_End_Date) %>% na.omit() %>% 
  table() %>% as.data.frame() %>% rename(label=1,Project_Phase_Planned_End_Date=2)

t2 <- data %>% filter(is.na(mdy(Project_Phase_Actual_Start_Date))) %>%
  pull(Project_Phase_Actual_Start_Date) %>% na.omit() %>% 
  table(dnn = "Project_Phase_Actual_Start_Date") %>%
  as.data.frame() %>% rename(label=1,Project_Phase_Actual_Start_Date=2)

t1 <- data %>% filter(Project_Status_Name=="PNS") %>%
  pull(Project_Status_Name) %>% na.omit() %>% 
  table(dnn = "Project_Status_Name") %>%
  as.data.frame() %>% rename(label=1,Project_Status_Name=2)


label_table <- full_join(t1,t2,by="label") %>% full_join(.,t3,by="label") %>%
  full_join(.,t4,by="label") %>% full_join(.,t5,by="label") %>% knitr::kable()


data %>%  filter(Project_Phase_Planned_End_Date!="PNS",
                 is.na(mdy(Project_Phase_Planned_End_Date)) &
                 is.na(as.numeric(Project_Budget_Amount))) %>%
  distinct(Project_Type,Project_Phase_Planned_End_Date,Project_Budget_Amount) %>% knitr::kable()

#get only full rows


full_data <- data %>% mutate(Project_Phase_Actual_Start_Date = mdy(Project_Phase_Actual_Start_Date),
                Project_Phase_Planned_End_Date = mdy(Project_Phase_Planned_End_Date),
                Project_Phase_Actual_End_Date = mdy(Project_Phase_Actual_End_Date),
                Project_Budget_Amount = as.numeric(Project_Budget_Amount)) %>% 
  filter(Project_Status_Name!="PNS") %>% na.omit()

full_data %>% distinct(Project_Status_Name)

data %>% filter(Project_Status_Name=="Complete") %>% filter(!complete.cases(.)) %>% view


data %>% mutate(Project_Phase_Actual_Start_Date = mdy(Project_Phase_Actual_Start_Date),
                Project_Phase_Planned_End_Date = mdy(Project_Phase_Planned_End_Date),
                Project_Phase_Actual_End_Date = mdy(Project_Phase_Actual_End_Date),
                Project_Budget_Amount = as.numeric(Project_Budget_Amount)) %>% 
  filter(Project_Status_Name!="PNS") %>% na.omit()


# ---- NAs ----

na_counts <- colSums(is.na(data))
na_df <- tibble(columns=names(na_counts),na_counts=as.numeric(na_counts))

na_df %>% ggplot(aes(x=columns,y=na_counts))+
  geom_bar(stat="Identity")+
  theme_classic()+
  theme(axis.text.x = element_text(angle=45,hjust=1))



# Project_Phase_Actual_End_Date
data %>% select(Project_Status_Name,Project_Phase_Actual_End_Date) %>%
  filter(Project_Status_Name=="In-Progress") %>% na.omit()


# Project_Phase_Name
data %>% filter(is.na(Project_Phase_Name)) %>% view

data %>% filter(Project_Budget_Amount=="DOER",Project_Status_Name=="PNS") %>%
  summarise(count=n(),.by=Project_Phase_Name)


# Project_Phase_Planned_End_Date

data %>% filter(is.na(Project_Phase_Planned_End_Date)) %>% view


data %>% filter(Project_Type=="SCA Furniture & Equipment") %>% view

# Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount
data %>% filter(is.na(Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount)) %>% view

data %>% filter(Total_Phase_Actual_Spending_Amount==0,Project_Phase_Name=="Construction") %>% view

data %>% filter(Project_Type=="SCA Emergency Response",Total_Phase_Actual_Spending_Amount==0) %>% view

#Total_Phase_Actual_Spending_Amount
data %>% filter(is.na(Total_Phase_Actual_Spending_Amount))

Total_Phase_Actual_Spending_Amount

#DSF_Number(s)
data %>% filter(is.na(`DSF_Number(s)`)) %>% view

data %>% filter(Project_Description=="LEAD PAINT ABATEMENT") %>% view

#PNS

data %>% filter(Project_Status_Name=="PNS") %>% view

#NA corrections

data[is.na(data$Project_Phase_Name),"Project_Phase_Name"] <- "Construction"
data <- data[-(is.na(data$Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount) & data$Project_Phase_Planned_End_Date=="DOES"),]



# ---- KPI ----

#Date
correct_date_data <- data %>% mutate(Project_Phase_Actual_Start_Date=lubridate::mdy(Project_Phase_Actual_Start_Date),
                                     Project_Phase_Actual_End_Date=lubridate::mdy(Project_Phase_Actual_End_Date),
                                     Project_Phase_Planned_End_Date=lubridate::mdy(Project_Phase_Planned_End_Date))

correct_date_data %>%  filter(Project_Phase_Actual_Start_Date > Project_Phase_Actual_End_Date) %>% view # No problem

correct_date_data %>% mutate(Completion_time = Project_Phase_Actual_End_Date-Project_Phase_Actual_Start_Date) %>% 
  arrange(desc(Completion_time)) %>% view





