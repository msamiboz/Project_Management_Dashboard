terms <- list(
  PNS = "Term found in dataset guessed as it stands for planning",
  "Early Cost Overrun Warning" = "this warning determined by comparing estimate spending is higher than budget. Phase level.",
  "Realized Cost Overrun Warning": "this warning determined by comparing actual spending is higher than the budget. Phase level.",
  "Realized Delay Warning"=  "Actual end date is later than planned end date. Phase level",
  "Early Delay Warning"= "For In-progress phases that planned end date is later than dataset time which is last end date observed: end of March 2025. Phase level",
  "Critical Cost Overrun and Delay Warning"= "Raised if both Cost and delay warnings are active.Phase level.",
  "Project Geographic District" = "District where building is located",
  "Project Building Identifier" = "Building ID",
  "Project School Name" = "School name",
  "Project Type" = "Type of project based on funding",
  "Project Description" = "Component(s) of work to be done",
  "Project Phase Name" = "Examples Scope , Design & Construction",
  "Project Status Name" = "Within the phase more detail, i.e. In-Progress, Hold",
  "Project Phase Actual Start Date" = "Date phase actually started",
  "Project Phase Planned End Date" = "Date phase originally scheduled to be completed",
  "Project Phase Actual End Date" = "Date phase actually completed",
  "Project Budget Amount" = "Award base budget by phase",
  "Final Estimate of Actual Costs Through End of Phase Amount" = "Current projected final estimate at completion of project by phase",
  "Total Phase Actual Spending Amount" = "Actual cumulative expenditures by phase",
  "DSF Number(s)" = "Number used to identify project in Five Year Plan"
)

for (term in names(terms)){
  cat("**",term,"**\n",terms[[term]],"\n\n")
}