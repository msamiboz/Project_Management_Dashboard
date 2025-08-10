

formatted_data <- data %>% mutate(Project_Phase_Actual_Start_Date = mdy(Project_Phase_Actual_Start_Date),
                                  Project_Phase_Planned_End_Date = mdy(Project_Phase_Planned_End_Date),
                                  Project_Phase_Actual_End_Date = mdy(Project_Phase_Actual_End_Date),
                                  Project_Budget_Amount = as.numeric(Project_Budget_Amount)) %>% 
  mutate(Project_Geographic_District=as.factor(Project_Geographic_District),
         Project_Type=as.factor(Project_Type),
         Project_Phase_Name=as.factor(Project_Phase_Name),
         Project_Status_Name=as.factor(Project_Status_Name))


output$home_pie_plot <- renderPlot({

  pie_data <- data %>% group_by(.data[[input$column]]) %>% summarise(count=n()) %>% 
    rename(category=1)
  pie_data %>% 
    ggplot(aes(x="",fill=category,y=count))+
      geom_bar(stat="identity",width=1)+
      coord_polar(theta="y")+
      theme_void()
  
  }
  
)

observeEvent(input$home_plot_button,{
  
  ptype <- input$home_plot_type
  xcol <- input$home_plot_x
  ycol <- input$home_plot_y
  
  
  output$home_plot <- renderPlot({
    if (ptype=="point") {
      p  <- ggplot(formatted_data) + 
        geom_point(aes_string(x=xcol,y=ycol))+
        theme_classic()
    }else if (ptype=="histogram") {
      p <- ggplot(formatted_data) +
        geom_histogram(aes_string(x=ycol,fill=xcol))+
        theme_classic()
    }
    p
  })


})



output$home_summary_table <- renderUI({
  cname <- input$home_column_selected
  cdata <- formatted_data[cname]
  ctype <- cdata %>% pull() %>% class()
  if (ctype=="numeric"){
    count <- nrow(cdata)
    missing <- cdata %>% is.na() %>% sum()

    stat_mean<- mean(cdata %>% pull(),na.rm = TRUE) %>%
      format(x = .,scientific=F,big.mark=",")
    stat_sd <-sd(cdata %>% pull(),na.rm = T)%>%
      format(x = .,scientific=F,big.mark=",")
    stat_skew <-skewness(cdata %>% pull(),na.rm = T)%>% 
      round(2) %>%
      format(x = .,scientific=F) 
    stat_kurt <-kurtosis(cdata %>% pull(),na.rm = T) %>% round(2) %>%
      format(x = .,scientific=F)
    
    stat_df <- tibble("Stat"=c("Mean","Sd","Skewness","Kurtosis"),
                      "Value"=c(stat_mean,stat_sd,stat_skew,stat_kurt))
    df_quantile <- quantile(cdata,c(1,0.75,0.5,0.25,0),na.rm = T) %>%
      as_tibble(rownames = "Quantile") %>%
      mutate(Value=format(x = value,scientific=F,big.mark=","),.keep="unused")
    
      tagList(
        HTML(paste0("<p>This column has <strong>",count,"</strong> observation. Which <strong>",missing,"</strong> of it is missing.</p>")),
        h4("Summary Tables"),
      fluidRow(
        column(3,
               HTML(knitr::kable(df_quantile,format = "html",col.names = c("Quantile","Value")))
        ),
        column(3,
               HTML(knitr::kable(stat_df,format = "html"))
        ),
        column(6)
      )
      )
  }else if (ctype=="Date"){
    count <- nrow(cdata)
    missing <- cdata %>% is.na() %>% sum()
    qs <- quantile(rank(xtfrm(cdata %>% pull %>% sort()),na.last = NA,ties.method = "max"),probs = c(1,0.75,0.5,0.25,0))
    nona<- cdata %>% pull %>%sort() %>% na.omit()
    df_quantile <- nona[qs]
    names(df_quantile) <- c("100%",       "75%",       "50%",       "25%",        "0%")
    
    tagList(
      HTML(paste0("<p>This column has <strong>",count,"</strong> observation. Which <strong>",missing,"</strong> of it is missing.</p>")),
      h4("Frequency Tables"),
      fluidRow(
        column(3,HTML(knitr::kable(df_quantile,format = "html",col.names = c("Quantile","Value")))),
        column(3,HTML(knitr::kable( table(cdata %>% mutate(year = year(.[[1]]),.keep="none")),format = "html")),),
        column(3,HTML(knitr::kable(table(cdata %>% mutate(month = month(.[[1]],label = T),.keep="none")),format = "html"))),
        column(3)
      )
      
      
    )

  }else if (ctype=="factor") {
    count <- nrow(cdata)
    missing <- cdata %>% is.na() %>% sum()
    
    tagList(
    HTML(paste0("<p>This column has <strong>",count,"</strong> observation. Which <strong>",missing,"</strong> of it is missing.</p>")),
    HTML(knitr::kable(table(cdata) %>% as_tibble() %>% arrange(n) %>% tail(5),caption = "Most observed 5 categories",format = "html"))
    )
  }else{
    tagList(
      p("Skip summarizing columns where the majority of values are unique")
    )
  }

  
  
})
