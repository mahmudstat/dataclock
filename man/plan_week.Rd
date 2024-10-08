% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plan_week.R
\name{plan_week}
\alias{plan_week}
\title{Week Planner}
\usage{
plan_week(wtask)
}
\arguments{
\item{wtask}{A factor variable having values on each day of the week.}
}
\value{
A plot showing task planned or done on each day of the week.
}
\description{
This function plots works corresponding to each day of the week.
}
\examples{
set.seed(10)
wtask <- c("Desk Work", "Field Work", "Visit", "Monitoring", "Rest", "Reporting", "Meeting")
plan_week(wtask)
}
