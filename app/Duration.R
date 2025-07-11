page_fluid(
  withMathJax(),
  HTML("To analyse duration we calculated the delay ratio variable as<br> $$
\\text{Completion_time} = \\text{Project_Phase_Actual_End_Date}-\\text{Project_Phase_Actual_Start_Date} <br>
$$
$$\\text{Planned_time} = \\text{Project_Phase_Planned_End_Date}-\\text{Project_Phase_Actual_Start_Date} $$
$$\\text{Delay_ratio} = \\frac{\\text{Completion_time}}{\\text{Planned_time}} 
$$"),
  HTML("<p>After that we examined the distribution of delay ratio.<br> We concluded with it seems like exponential distribution.</p>"),
  plotlyOutput(outputId = "duration_histogram"),
  HTML("<p>So we used GLM with exponential distribution which means gamma with log link. So above histograms plots $log(\text{delay_ratio})<br> follwoing table is the output of the regression</p>"),
  uiOutput(outputId = "duration_regression"),
  HTML("<p>One can comment on coefficients as follows:<br> 
      <ul>
        <li> For type and phase being the value changes delay ratio as below percent </li>
        <li> For geographic district each increase in number increases the delay ratio by that percent (look image for understanding geographic districts)</li>
        <li> Lastly Start time: each day past delay ratio expected to be that percent lower.
      </ul> The exact values can be seen below. </p>"),
  tableOutput(outputId = "duration_coef_table"),
  imageOutput(outputId = "duration_geo_image",width = "275px",height = "245px"),
  HTML("<p>So we can say that while following this path Manhattan, The Bronx, Brooklyn, Queens, Staten Island we expect to delay ratio to increase on average.</p>"),
  HTML("<p>Finally we can examine the delay ratios relationship with time by using following plot.<br>We expect this relationship to be exist because to delay to occur time should pass. So in more recent phases probability that phase has ended and probability to have delays is expected to be lower.</p>"),
  plotlyOutput(outputId = "duration_timeseries_plot")
  
)

