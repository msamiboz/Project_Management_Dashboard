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
Due to these causes we can identify phases of ordinary projects with building identifier, school name, project description,phase name
for repeated projects we'll use DSF_numbers and actual start time.
geographic district,project type variables can be used for filtering when analyzing.


