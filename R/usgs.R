#' get sample data from dataRetrieval pacakge
#'
#' this is mainly a helper function for using the readWQPdata() function from the dataRetrieval package in that it helps the user identify if any of the station of interest don't have sample data associated with them, or simply don't exist.
#'
#' @param site_names list of site names
#'
#' @return
#' @export
#'
#' @examples
#'
#' site_names <- c("USEPA-440432070255401","test", "USGS-010158001", "USGS-01011100", "test2")
#' sample_data <- get_sample_data(site_names)
#'
get_sample_data <- function(site_names) {


  err <- logical(length(site_names))
  no_data <- logical(length(site_names))
  working <- logical(length(site_names))
  for (i in 1:length(site_names)) {

    data <- tryCatch(
      whatWQPsamples(siteid = site_names[i]),
      error=function(e) e
    )

    if (inherits(data, "error")) {
      err[i] <- TRUE
      next
    } else if (length(data) == 1) {
      no_data[i] <- TRUE
      next
    }

    working[i] <- TRUE

  }

  if(any(err)) cat("following sites not found please check that these station codes are correct: \n", sprintf("%s \n", site_names[err]))
  if(any(no_data)) cat("no sample data found for sites: \n", sprintf(" %s \n", site_names[no_data]))

  present <- working[!is.na(working)]

  wq_data <- readWQPdata(siteid = site_names[working]) %>%
    filter(USGSPCode %in% param_codes$`5_digit_code`)

  return(wq_data)

}
