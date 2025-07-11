page_fluid(
  withMathJax(),
  HTML("<p>For Cost analysis we calculated a variable named Cost override its equation is as follows:<br>
  $$\\text{Cost_override} = \\frac{\\text{Total_Phase_Actual_Spending_Amount}-\\text{Project_Budget_Amount}}{\\text{Project_Budget_Amount}} 
$$
  To model it we need to understand its distribution
       </p>"),
  plotOutput("cost_hist1"),
  HTML("<p>Even though due to outliers it is hard observe but this variable starts from -1 goes to positive infinity theoriticaly.<br>
       So to make it stabilize I used $log(1+p)$<br>
       After that distribution becomes this:</p>"),
  plotOutput("cost_hist2"),
  HTML("this one can be modeled with OLS.<br>
       THe model result can be seen by following regression table"),
  uiOutput("cost_regression"),
  HTML("<p> According to regression we can say that for project types Capacity and Furniture & Equipment and for all Phases are significant. <br>
       To interpret coeffients we can use following table. This table has coeeficient as reversed transformated to original cost override.</p>"),
  tableOutput(("cost_coefs")),
  HTML("<p>One can comment on coefficients as follows:<br> 
      <ul>
        <li> For type Capacity and Furniture & Equipment is significantly lower cost overrun according to type 3K  </li>
        <li> Status; In-Progress and PNS are much lower cost overrun with respec to completed phases as expected. </li>
        <li> Most interestingly Furniture phase is significantly much higher cost overrun than Construction, Desing and Scope phases.</li>
        <li> For geographic district each increase in number decreases the cost overrun (look image for understanding geographic districts)</li>
      </ul> The exact values can be seen above </p>"),
  imageOutput(outputId = "duration_geo_image",width = "275px",height = "245px"),
  HTML("<p>As A last remark coefficients table as you see above effects cost overrun by like this: being PNS as a status, change cost overrun by multiplying  -0.96.<br>
       For example if a phase become PNS to completed (all other thing are equal) cost overrun become -0.48 to 0.5 (numbers are random) </p>")
  
  
)