load("data/data_ready.Rdata")

library(tidyverse)
# ---- KPI ----

#Date
correct_date_data <- data %>% mutate(Project_Phase_Actual_Start_Date=lubridate::mdy(Project_Phase_Actual_Start_Date),
                                     Project_Phase_Actual_End_Date=lubridate::mdy(Project_Phase_Actual_End_Date),
                                     Project_Phase_Planned_End_Date=lubridate::mdy(Project_Phase_Planned_End_Date))

correct_date_data <- correct_date_data %>% mutate(Completion_time = Project_Phase_Actual_End_Date-Project_Phase_Actual_Start_Date,
                             Planned_time = Project_Phase_Planned_End_Date-Project_Phase_Actual_Start_Date,
                             Delay_ratio = as.double.difftime(Completion_time) / as.double.difftime(Planned_time))


correct_date_data %>% filter(Delay_ratio <= 0)
correct_date_data <- correct_date_data[-which(correct_date_data$Delay_ratio<=0),]

correct_date_data %>% na.omit()


# Cost

data %>% colnames()

correct_cost <- data %>% mutate(Project_Budget_Amount=as.double(Project_Budget_Amount),
                Cost_override= (Total_Phase_Actual_Spending_Amount - Project_Budget_Amount)/Project_Budget_Amount)
  

#Full correct data 

full_data <- data %>% mutate(Project_Phase_Actual_Start_Date = mdy(Project_Phase_Actual_Start_Date),
                             Project_Phase_Planned_End_Date = mdy(Project_Phase_Planned_End_Date),
                             Project_Phase_Actual_End_Date = mdy(Project_Phase_Actual_End_Date),
                             Project_Budget_Amount = as.numeric(Project_Budget_Amount)) %>% 
  filter(Project_Status_Name!="PNS") %>% na.omit()


#Plots

## Date

sd(x=correct_date_data$Delay_ratio, na.rm=TRUE)


### time series
correct_date_data %>% ggplot(aes(x=Project_Phase_Actual_Start_Date,y=Delay_ratio))+
  geom_point()+
  geom_smooth()+
  theme_classic()

# to understand the delay ratio in time I looked its distribution, it does not contain any nonnegative values and it is continuos exponential distribution is suitable for it 

correct_date_data %>% ggplot(aes(x=Delay_ratio))+
  geom_histogram(aes(y=after_stat(density)),binwidth = 0.4)+
  theme_classic()+
  labs(title="Distribution of Delay Ratio")


#model2 is exponential distribution

model1 <- glm(Delay_ratio ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Phase_Actual_Start_Date,
              data=correct_date_data %>% na.omit(),family = gaussian())
model2 <- glm(Delay_ratio ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Phase_Actual_Start_Date,
    data=correct_date_data %>% na.omit(),family = Gamma(link = "log"))
model3 <- glm(Delay_ratio ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Phase_Actual_Start_Date,
             data=correct_date_data %>% na.omit(),family = Gamma(),start = coef(model2))

summary(model2)
exp(coef(model2)["Project_Phase_Actual_Start_Date"])
#one more day recent project decreases the expected value of delay ratio by 3.4 per ten thousand.

#we can follow the relationship by following plot
correct_date_data %>% ggplot(aes(x=Project_Phase_Actual_Start_Date,y=log(Delay_ratio)))+
  geom_point()+
  geom_smooth()+
  theme_classic()+
  labs(title = "log Delay Ratio Through Time")

correct_date_data %>% ggplot(aes(x=Project_Phase_Actual_Start_Date,y=log(Delay_ratio)))+
  geom_point()+
  geom_smooth()+
  theme_()+
  labs(title = "log Delay Ratio Through Time")

## Cost

#We dropped the Inf values to model cost overridden

correct_cost %>% ggplot(aes(Cost_override))+
  geom_histogram(aes(y=after_stat(density)),binwidth = 0.50)

correct_cost  %>% 
  ggplot(aes(log1p(Cost_override)))+
  geom_histogram(aes(y=after_stat(density)),binwidth = 0.25)

model_cost <- glm(Cost_override ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Status_Name,
    data = correct_cost %>% filter(!is.infinite(Cost_override)) %>% na.omit(),family = gaussian)
plot(residuals(model_cost,type = "deviance"))


correct_cost1 <- correct_cost %>%
  mutate(transfrom_cost_override=log1p(Cost_override)) %>%
  filter(is.finite(transfrom_cost_override)) %>%
  select(Cost_override,Project_Geographic_District,Project_Type,Project_Phase_Name,Project_Status_Name)%>%
  na.omit()

model_cost1 <- lm(log1p(Cost_override) ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Status_Name,
                   data = correct_cost1,family = gaussian)

summary(model_cost1)
plot(residuals(model_cost1))
stargazer::stargazer(model_cost1,type = "html")
exp(coef(model_cost1))-1

plot(cooks.distance(model_cost))


correct_cost %>%filter(Project_Status_Name!="PNS",Cost_override<40) %>%
  ggplot(aes(y=Cost_override,x=lubridate::mdy(Project_Phase_Actual_Start_Date)))+
  geom_point(aes(color =Project_Phase_Name))


save(correct_date_data,file = "data/date_data.Rdata")
save(correct_cost,file="data/cost_data.Rdata")

### Time series analysis


full_data1 <- full_data %>% mutate(Completion_time = Project_Phase_Actual_End_Date-Project_Phase_Actual_Start_Date,
                     Planned_time = Project_Phase_Planned_End_Date-Project_Phase_Actual_Start_Date,
                     Delay_ratio = as.double.difftime(Completion_time) / as.double.difftime(Planned_time)) %>%
  mutate(Cost_override= (Total_Phase_Actual_Spending_Amount - Project_Budget_Amount)/Project_Budget_Amount)



#will continue


## Simple summary after mutates

full_data %>% summarise(
  Project_Phase_Actual_Start_Date = glue("{round(mean(Project_Phase_Actual_Start_Date, na.rm = TRUE), 1)} - {round(median(Project_Phase_Actual_Start_Date, na.rm = TRUE), 1)} ({round(sd(Project_Phase_Actual_Start_Date, na.rm = TRUE), 1)})\n{min(Project_Phase_Actual_Start_Date, na.rm = TRUE)} - {max(Project_Phase_Actual_Start_Date, na.rm = TRUE)}"),
  Project_Phase_Planned_End_Date = glue("{round(mean(Project_Phase_Planned_End_Date, na.rm = TRUE), 1)} - {round(median(Project_Phase_Planned_End_Date, na.rm = TRUE), 1)} ({round(sd(Project_Phase_Planned_End_Date, na.rm = TRUE), 1)})\n{min(Project_Phase_Planned_End_Date, na.rm = TRUE)} - {max(Project_Phase_Planned_End_Date, na.rm = TRUE)}"),
  Project_Phase_Actual_End_Date = glue("{round(mean(Project_Phase_Actual_End_Date, na.rm = TRUE), 1)} - {round(median(Project_Phase_Actual_End_Date, na.rm = TRUE), 1)} ({round(sd(Project_Phase_Actual_End_Date, na.rm = TRUE), 1)})\n{min(Project_Phase_Actual_End_Date, na.rm = TRUE)} - {max(Project_Phase_Actual_End_Date, na.rm = TRUE)}"),
  Project_Budget_Amount = glue("{round(mean(Project_Budget_Amount, na.rm = TRUE), 1)} - {round(median(Project_Budget_Amount, na.rm = TRUE), 1)} ({round(sd(Project_Budget_Amount, na.rm = TRUE), 1)})\n{min(Project_Budget_Amount, na.rm = TRUE)} - {max(Project_Budget_Amount, na.rm = TRUE)}"),
  Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount = glue("{round(mean(Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount, na.rm = TRUE), 1)} - {round(median(Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount, na.rm = TRUE), 1)} ({round(sd(Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount, na.rm = TRUE), 1)})\n{min(Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount, na.rm = TRUE)} - {max(Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount, na.rm = TRUE)}"),
  Total_Phase_Actual_Spending_Amount= glue("{round(mean(Total_Phase_Actual_Spending_Amount, na.rm = TRUE), 1)} - {round(median(Total_Phase_Actual_Spending_Amount, na.rm = TRUE), 1)} ({round(sd(Total_Phase_Actual_Spending_Amount, na.rm = TRUE), 1)})\n{min(Total_Phase_Actual_Spending_Amount, na.rm = TRUE)} - {max(Total_Phase_Actual_Spending_Amount, na.rm = TRUE)}")
) %>% t() %>% 
knitr::kable(format="html")
janitor::tabyl(full_data,Project_Phase_Name,Project_Status_Name)



