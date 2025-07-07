# Project_Management_Dashboard
This is a comprehensive project to conduct project management analysis and create dashboard. Using public data.

## Data Source 
Data is donloaded from webpage:
https://data.cityofnewyork.us/Housing-Development/Capital-Project-Schedules-and-Budgets/2xh6-psuq
its name is 
Data.gov: Capital Project Schedules and Budgets.

## Data

After examination one can say that each row represents a phase in a project. Phase has values of actual start date,planned end date, actual end date,budget,estimate of actual costs,actual spending.

Some projects have same building several schools for schools there are several buildings. And for some cases for same building same school same project the job entered 5 year plane with different name and for some rare cases. Eventough they are under the same number in the 5 year plan, project phase conducted again.

Due to these causes we can identify phases of ordinary projects with building identifier, school name, project description,phase name for repeated projects we'll use DSF_numbers and actual start time. geographic district,project type variables can be used for filtering when analyzing.


## Comments
Some of the value columns have labeled with certain words, following table explains the situation

|label | Project_Status_Name| Project_Phase_Actual_Start_Date| Project_Phase_Planned_End_Date| Project_Phase_Actual_End_Date| Project_Budget_Amount|
|:-----|-------------------:|-------------------------------:|------------------------------:|-----------------------------:|---------------------:|
|PNS   |                4886|                            4863|                           4863|                          4863|                    NA|
|FTK   |                  NA|                              23|                            353|                            23|                   353|
|DIIR  |                  NA|                              NA|                            350|                            NA|                  1058|
|DIIT  |                  NA|                              NA|                             53|                            NA|                    53|
|DOEL  |                  NA|                              NA|                             21|                            NA|                    21|
|DOEP  |                  NA|                              NA|                              5|                            NA|                     5|
|DOER  |                  NA|                              NA|                            661|                            NA|                  1860|
|DOES  |                  NA|                              NA|                           1051|                            NA|                  1051|
|EMER  |                  NA|                              NA|                            119|                            NA|                   119|
|IEH   |                  NA|                              NA|                            694|                            NA|                   694|
|TPL   |                  NA|                              NA|                              9|                            NA|                    12|

## NAs

### Project_Phase_Actual_End_Date

Several columns have NA values most crucial one is Project_Phase_Actual_End_Date.
It has 4533 NA when examined this is equal to amount of Project_Status of In-progress.
So these data actually is not missing but has not occurred yet so we need to hold the data 


### Project_Phase_Name

When examined the single observation of Na in this column we saw that by looking other columns values same with other observations this observations Phase name could be Construction.
This implementation can be done because every other column has meaningful values except phase name.

### Project_Phase_Planned_End_Date

After examination deeply one can find that this columns NA occurs when project type and if Project status is PNS planned enddate is PNS and if it is completed it has proper date and if it is In-progress it has value NA. So in this case being NA has its own meaning so we cant implement anything that changes mentioned structure or drop these values.






