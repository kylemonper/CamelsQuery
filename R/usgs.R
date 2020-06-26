#' get sample data from dataRetrieval pacakge
#'
#' this is mainly a helper function for using the readWQPdata() function from the dataRetrieval package in that it helps the user identify if any of the station of interest don't have sample data associated with them, or simply don't exist.
#'
#' @param site_names list of site names
#'
#' @return water quality sample data for sites
#' @export
#'
#' @examples
#'\dontrun{
#' site_names <- c("USEPA-440432070255401","test", "USGS-010158001", "USGS-01011100", "test2")
#' sample_data <- get_sample_data(site_names)
#'}
get_sample_data <- function(site_names) {

  ## the goal of this function is make the dataRetrieval::readWQPdata() function a bit easier to use
  #~ if site codes are incorrect readWQPdata() gives a vague error and also stops the function entirely, also it doesn't tell the user which sites dont have any qater quality data
  #~~ this function indentifies site codes that arn't present/dont have data tells the user about those, and then uses only sites with data to run the readWQPdata() function

  ### create empty logical variables to be used for indexing working from non-working site codes
  err <- logical(length(site_names))
  no_data <- logical(length(site_names))
  working <- logical(length(site_names))

  for (i in 1:length(site_names)) {
    ## look for sites that have sample data associated with them
    ## we use trycatch() because if a site doesn't exist the function is aborted/exited
    data <- tryCatch(
      dataRetrieval::whatWQPsamples(siteid = site_names[i]),
      error=function(e) e
    )

    ## if try catch recieved and error, ID this site code as being an error
    if (inherits(data, "error")) {
      err[i] <- TRUE
      next

    ## if there was no sample data present for this site, ID this as a "no data" site
    } else if (length(data) == 1) {
      no_data[i] <- TRUE
      next
    }

    ## if niether of the past two if statements didnt trigger, ID this site code as working
    working[i] <- TRUE

  }

    ## throw a message letting the user know about incorrect site codes, or sites that don't have any data.
  if(any(err)) cat("following sites not found please check that these station codes are correct: \n", sprintf("%s \n", site_names[err]))
  if(any(no_data)) cat("no sample data found for sites: \n", sprintf(" %s \n", site_names[no_data]))



  # run readWQPdata() using working site names,
  # then filter for only water quality data of interest based on the list of param_codes that is stored in the package data
  ##~~~ NOTE: may want to remove this feature/ add it as a T/F option in the function
  wq_data <- dataRetrieval::readWQPdata(siteid = site_names[working]) %>%
    filter(USGSPCode %in% param_codes$`5_digit_code`)

  return(wq_data)

}










