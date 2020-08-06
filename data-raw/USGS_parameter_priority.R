## code to prepare `USGS_parameter_priority` dataset goes here


USGS_parameter_priority <- read.csv("inst/extdata/USGS_trial_sites.csv", stringsAsFactors = FALSE)
usethis::use_data(USGS_parameter_priority, overwrite = TRUE)
