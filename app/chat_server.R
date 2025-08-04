
querychat <- querychat_server("chat",querychat_config)

output$dt <- DT::renderDT({
  DT::datatable(querychat$df(),
                extensions = c("Scroller"),
                options = list(scrollY=650,
                               scrollX=500,
                               autoWidth=FALSE,
                               scroller=TRUE),
                rownames = FALSE)
}
  
)