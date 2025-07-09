load("../data/data_ready.Rdata")

output$home_pie_plot <- renderPlot({

  pie_data <- data %>% group_by(.data[[input$column]]) %>% summarise(count=n()) %>% 
    rename(category=1)
  p <- pie_data %>% 
    ggplot(aes(x="",fill=category,y=count))+
      geom_bar(stat="identity",width=1)+
      coord_polar(theta="y")+
      theme_void()
  
  }
  
)
