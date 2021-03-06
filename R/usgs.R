#' get sample data from dataRetrieval pacakge
#'
#' this is mainly a helper function for using the readWQPdata() function from the dataRetrieval package in that it helps the user identify if any of the station of interest don't have sample data associated with them, or simply don't exist.
#'
#' @param site_names list of site names
#' @param chem_codes a data frame with the USGS water chemistry codes of the parameters you want to query
#'
#' @return water quality sample data for sites
#' @export
#'
#' @examples
#'\dontrun{
#' site_names <- c("USEPA-440432070255401","test", "USGS-010158001", "USGS-01011100", "test2")
#' sample_data <- get_sample_data(site_names)
#'}
get_sample_data <- function(site_names, chem_codes=USGS_parameter_priority) {

  ## the goal of this function is make the dataRetrieval::readWQPdata() function a bit easier to use
  #~ if site codes are incorrect readWQPdata() gives a vague error and also stops the function entirely,
  # also it doesn't tell the user which sites dont have any qater quality data
  #~~ this function identifies site codes that aren't present/don't have data tells the user about those,
  # and then uses only sites with data to run the readWQPdata() function

  ### create empty logical variables to be used for indexing working from non-working site codes
  err <- logical(length(site_names))
  no_data <- logical(length(site_names))
  working <- logical(length(site_names))

  for (i in 1:length(site_names)) {
    ## look for sites that have sample data associated with them
    ## we use trycatch() because if a site doesn't exist the function is aborted/exited
    water_quality <- tryCatch(
      dataRetrieval::whatWQPsamples(siteid = paste0("USGS-", site_names[i])), # need to add a check on this
      error=function(e) e
    )


    ## if try catch received and error, ID this site code as being an error
    if (inherits(water_quality, "error")) {
      err[i] <- TRUE
      next

    ## if there was no sample data present for this site, ID this as a "no data" site
    } else if (length(water_quality) == 1) {
      no_data[i] <- TRUE
      next
    }

    ## if neither of the past two if statements did not trigger, ID this site code as working
    working[i] <- TRUE



  }

    ## throw a message letting the user know about incorrect site codes, or sites that don't have any data.
  if(any(err)) cat("following sites not found please check that these station codes are correct: \n", sprintf("%s \n", site_names[err]))
  if(any(no_data)) cat("no sample data found for sites: \n", sprintf(" %s \n", site_names[no_data]))



  # run readWQPdata() using working site names,
  # then filter for only water quality data of interest based on the list of param_codes that is stored in the package data
  ##~~~ NOTE: may want to remove this feature/ add it as a T/F option in the function
  wq_data <- dataRetrieval::readWQPdata(siteid = paste0("USGS-",site_names[working])) %>%
    filter(USGSPCode %in% chem_codes$`5_digit_code`)

  # Get the corresponding stream flow data
  flow_code <- "00060"
  flow_daily <- dataRetrieval::readNWISdv(site_names[working], flow_code) # Assuming they all have a flow - to be tested

  # Get the corresponding site information
  site_info <- dataRetrieval::readNWISsite(site_names[working]) %>%
    dplyr::select(agency_cd, site_no, station_nm, dec_lat_va, dec_long_va, dec_coord_datum_cd, state_cd, county_cd,
                  alt_va, huc_cd, drain_area_va, contrib_drain_area_va, tz_cd) # select the columns of interest

  # Put all the tables into a list (for now)
  usgs_data <- list(discharge = flow_daily,
                    water_q = wq_data,
                    sites = site_info)


  return(usgs_data)

}










