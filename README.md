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

When examined I figured out that each label except PNS is about project department, we can understand the situation with following table;

|Project_Type           |Project_Phase_Planned_End_Date |Project_Budget_Amount |
|:----------------------|:------------------------------|:---------------------|
|SCA IEH                |IEH                            |IEH                   |
|DOE - RESOA            |DOER                           |DOER                  |
|DOE - Skilled Trades   |DOES                           |DOES                  |
|Fast Track Projects    |FTK                            |FTK                   |
|DIIT - RESOA           |DIIR                           |DIIR                  |
|Trust For Public Land  |TPL                            |TPL                   |
|SCA Emergency Response |EMER                           |EMER                  |
|DIIT - Project Connect |DIIT                           |DIIT                  |
|DOE - Lead Paint       |DOEL                           |DOEL                  |
|DOE Managed PRE-K      |DOEP                           |DOEP                  |

So we will convert these labels to NA because this labels does not exhibit a information on project apart from the project type which is a distinct column.

However, PNS is different. Eventough there is no information on metadata(or other resources) about PNS, by examining data thoroughly we may conclude that PNS label is about planning. My best guess is PNS stands for "Planned - Not Started"

## NAs

### Project_Phase_Actual_End_Date

Several columns have NA values most crucial one is Project_Phase_Actual_End_Date.
It has 4533 NA. When examined this is equal to amount of Project_Status of In-progress.
So these data actually is not missing but has not occurred yet so we need to hold the data 

### Project_Phase_Name

When examined the single observation of Na in this column we saw that by looking other columns values same with other observations this observations Phase name could be Construction.
This implementation can be done because every other column has meaningful values except phase name.

### Project_Phase_Planned_End_Date

After examination deeply one can find that this columns' NA occurs when project type and if Project status is PNS planned end date is PNS. And if it is completed or In-progress it has value NA.This means these projects starting with no planned end date. So in this case being NA has its own meaning so we cant implement anything that changes mentioned structure or drop these values.

### Final_Estimate_of_Actual_Costs_Through_End_of_Phase_Amount

Except two cases we can explain these NAs with following relationship; Emergency projects with zero actual spending has no estimated cost except one case. And another case has no estimated cost but it is not an emergency project. The latter case might be dropped out but other 16 cases should be handled as "can't estimate".

### Total_Phase_Actual_Spending_Amount

In these NAs each phase is completed. Also each phase is a "Construction" phase. No budget is determined for any observation but every case ahs an estimated costs. So we fill the actual cost with estimated cost to prevent information lost we will do this because pahses are completed and there is an estimated amount. So no change is expected and estimation when when a event occurred become observation.

### DSF_Number(s) 

In this case, each NA occurred at specific project: "LEAD PAINT ABATEMENT". When checked also every "LEAD PAINT ABATEMENT" project has NA DSF numbers. Another thinking point is DSF numbers is about info that connects project to 5 year plan so in terms of project management analysis it has no value. So we can easily drop this column so there will be NA problem also.

## Problematic Values/observations

If a phase has time or budget variables as group of columns it is okey for me we don't seek both of them to be exist but if none is available then no need to hold that observation.
Giving aggregated statistics is excluded from above statement. So we can only drop values after creating KPI columns.


## Last Manipulations

In Project Phase names "CM,Art,F&E","CM","F&E","CM,F&E" is merged and named "CM,F&E". Because these are not so different from each other and have small number of observations.


## KPI

I created delay_ratio and cost_override as my key performance indicators.

### Delay ratio 

$$
Completion_time = Project_Phase_Actual_End_Date-Project_Phase_Actual_Start_Date
Planned_time = Project_Phase_Planned_End_Date-Project_Phase_Actual_Start_Date,
Delay_ratio = Completion_time / Planned_time
$$

In this ratio phases with 1 done in exactly planned time, ratios lower than one represent quick completions. Finally more than 1 tells us that project phases with delays. higher the value more the delay in term "times": ratio 2 means phase completed 2 times the amount planned.

Two observations have negative delay ratios means that actual start date is after planned end date which is a mistake most prpbbaly project phase is postponed due to previous phases lags. Because we cannot analyze it we drop these two values.
Another 16 observation is removed temporarily to be able model Delay ratio. These observation have zero delay ratio which means they finished the phase asme day they started.

Another reamrk to keep in mind is becuase this is created on ended project phase this column dont give any insgiht about planning (PNS) or inprogress phases.
Also because scope and desing is early steps of a project each completed construction phase have completed scope and desing inverse is obivouly not true. So analysis contains this column have
### Cost override

$$
\text{Cost_override}= \frac{\text{Total_Phase_Actual_Spending_Amount} - \text{Project_Budget_Amount}}{\text{Project_Budget_Amount}}
$$





