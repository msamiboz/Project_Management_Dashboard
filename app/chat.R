page_fluid(
  fluidRow(
    column(4,
           querychat_ui("chat")
           ),
    column(8,
           DT::DTOutput("dt")
           )
  )
  
)