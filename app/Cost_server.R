correct_cost <- data %>% mutate(Project_Budget_Amount=as.double(Project_Budget_Amount),
                                Cost_override= (Total_Phase_Actual_Spending_Amount - Project_Budget_Amount)/Project_Budget_Amount)

output$cost_hist1 <- renderPlot({
  correct_cost %>% ggplot(aes(Cost_override))+
    geom_histogram(aes(y=after_stat(density)),binwidth = 0.50)
})

output$cost_hist2 <- renderPlot({correct_cost  %>% 
  ggplot(aes(log1p(Cost_override)))+
  geom_histogram(aes(y=after_stat(density)),binwidth = 0.25)
})

correct_cost1 <- correct_cost %>%
  mutate(transfrom_cost_override=log1p(Cost_override)) %>%
  filter(is.finite(transfrom_cost_override)) %>%
  select(Cost_override,Project_Geographic_District,Project_Type,Project_Phase_Name,Project_Status_Name)%>%
  na.omit()

model_cost1 <- lm(log1p(Cost_override) ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Status_Name,
                  data = correct_cost1,family = gaussian)

output$cost_regression <- renderUI({
  HTML(stargazer::stargazer(model_cost1,type = "html"),collapse="\n")
})

output$cost_coefs <- renderTable({
  coefs <- (exp(coef(model_cost1))-1)
  enframe(coefs)
})

output$cost_geo_image <- renderImage({
  list(src="www/nyc_geo_district.gif")
},deleteFile = F)