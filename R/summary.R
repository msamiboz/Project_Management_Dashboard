library(tidyverse)
library(moments)
load("~/Documents/GitHub/Project_Management_Dashboard/data/clean_data.Rdata")


formatted_data <- data %>% mutate(Project_Phase_Actual_Start_Date = mdy(Project_Phase_Actual_Start_Date),
                Project_Phase_Planned_End_Date = mdy(Project_Phase_Planned_End_Date),
                Project_Phase_Actual_End_Date = mdy(Project_Phase_Actual_End_Date),
                Project_Budget_Amount = as.numeric(Project_Budget_Amount)) %>% 
  mutate(Project_Geographic_District=as.factor(Project_Geographic_District),
         Project_Type=as.factor(Project_Type),
         Project_Phase_Name=as.factor(Project_Phase_Name),
         Project_Status_Name=as.factor(Project_Status_Name))

formatted_data %>% ggplot(aes(x=Project_Status_Name))+
  geom_point(aes(y=Project_Phase_Actual_Start_Date))

 # if histogram
 #    pick data column
 #    optional pick facet or color wrt identifier
# if point 
#     x identifier
#     y data
    
# column by column summary table
# 

cname <- "Total_Phase_Actual_Spending_Amount"
cdata <- formatted_data[cname]
ctype <- cdata %>% pull() %>% class()
# 
# # if numeric
#   n
#   missing
#   max
#   q3
#   mean
#   median
#   sd
#   q1
#   min
#   skewness
#   kurtosis
if (ctype=="numeric"){
count <- nrow(cdata)
missing <- cdata %>% is.na() %>% sum()
stat_df <- tibble("Stat"=c("Mean","Sd","Skewness","Kurtosis"),"Value"=rep(NA,4))
stat_df[1,2] <-mean(cdata %>% pull(),na.rm = TRUE)
stat_df[2,2] <-sd(cdata %>% pull(),na.rm = T)
stat_df[3,2] <-skewness(cdata %>% pull(),na.rm = T)
stat_df[4,2] <-kurtosis(cdata %>% pull(),na.rm = T)
df_quantile <- quantile(cdata,c(1,0.75,0.5,0.25,0),na.rm = T)

renderText(paste0("<p>This column has ",count," observation. Which ",missing," of it is missing.</p>"))

fluidrow(
  column(6,
         HTML(knitr::kable(df_quantile,format = "html",col.names = c("Quantile","Value")))
         ),
  column(6,
         HTML(knitr::kable(stat_df,format = "html"))
         )
  )



}

# # if date
#   n
#   missing
#   max
#   freq_table(year)
#   freq_table(month)
#   min
if (ctype=="Date"){
  count <- nrow(cdata)
  missing <- cdata %>% is.na() %>% sum()
  maxd <- max(cdata %>% pull(),na.rm=T)
  mind <- min(cdata %>% pull(),na.rm=T)
  qs <- quantile(rank(xtfrm(cdata %>% pull %>% sort()),na.last = NA,ties.method = "max"),probs = c(1,0.75,0.5,0.25,0))
  nona<- cdata %>% pull %>%sort() %>% na.omit()
  df_quantile <- nona[qs]
  names(df_quantile) <- c("100%",       "75%",       "50%",       "25%",        "0%")
 
  knitr::kable( table(cdata %>% mutate(year = year(.[[1]]),.keep="none")))
  knitr::kable(table(cdata %>% mutate(month = month(.[[1]],label = T),.keep="none")))
  renderText(paste0("<p>This column has ",count," observation. Which ",missing," of it is missing.</p>"))
  
}

# # if factor
#   n
#   missing
#   how many of category
#   mode
#   freq_table
#   top-n values
if (ctype=="factor") {
  count <- nrow(cdata)
  missing <- cdata %>% is.na() %>% sum()
  knitr::kable(table(cdata))
  renderText(paste0("<p>This column has ",count," observation. Which ",missing," of it is missing.</p>"))
  knitr::kable(table(cdata) %>% as_tibble() %>% arrange(n) %>% tail(5),caption = "Most observed 5 categories")
}