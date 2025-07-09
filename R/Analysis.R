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

# to understand the delay ratio in time I looked its disrtibution, it does not contain any nonnegative values and it is continuos exponential distribution is suitable for it 

correct_date_data %>% ggplot(aes(x=Delay_ratio))+
  geom_histogram(aes(y=after_stat(density)),binwidth = 0.1)+
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



## Cost

#We dropped the Inf values to model cost overridden


correct_cost  %>% 
  ggplot(aes(log1p(Cost_override)))+
  geom_histogram(aes(y=after_stat(density)),binwidth = 0.25)

model_cost <- glm(Cost_override ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Status_Name,
    data = correct_cost %>% filter(!is.infinite(Cost_override)) %>% na.omit(),family = gaussian)
plot(residuals(model_cost,type = "deviance"))


correct_cost1 <- correct_cost %>%
  mutate(transfrom_cost_override=log1p(Cost_override)) %>%
  filter(is.finite(transfrom_cost_override)) %>% na.omit()

model_cost1 <- glm(log1p(Cost_override) ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Status_Name,
                   data = correct_cost1,family = gaussian)

summary(model_cost1)
plot(residuals(model_cost1,type = "deviance"))
exp(coef(model_cost1))-1

plot(cooks.distance(model_cost))


correct_cost %>%filter(Project_Status_Name!="PNS",Cost_override<40) %>%
  ggplot(aes(y=Cost_override,x=lubridate::mdy(Project_Phase_Actual_Start_Date)))+
  geom_point(aes(color =Project_Phase_Name))


save(correct_date_data,file = "data/date_data.Rdata")
save(correct_cost,file="data/cost_data.Rdata")
