
output$duration_timeseries_plot <- renderPlotly({
  p<- correct_date_data %>% ggplot(aes(x=Project_Phase_Actual_Start_Date,y=log(Delay_ratio)))+
    geom_point()+
    geom_smooth()+
    theme_classic()+
    labs(title = "log Delay Ratio Through Time")
  
  ggplotly(p)})


output$duration_histogram <- renderPlotly({
  p <- correct_date_data %>% ggplot(aes(x=Delay_ratio))+
    geom_histogram(aes(y=after_stat(density)),binwidth = 0.4)+
    theme_classic()+
    labs(title="Distribution of Delay Ratio")
  ggplotly(p)
})

model2 <- glm(Delay_ratio ~ Project_Geographic_District + Project_Type+ Project_Phase_Name+Project_Phase_Actual_Start_Date,
              data=correct_date_data %>% na.omit(),family = Gamma(link = "log"))

output$duration_regression <- renderUI({
  HTML(stargazer::stargazer(model2,type="html"),collapse="\n")
  })


output$duration_coef_table <- renderTable({
  coefs <- ((exp(coef(model2)) - 1) * 100)
  enframe(coefs)
})

output$duration_geo_image <- renderImage({
  list(src="www/nyc_geo_district.gif")
},deleteFile = F)

