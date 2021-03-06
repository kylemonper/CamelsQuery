#' Download CAMELS data
#'
#' downloads and unzips CAMELS data from https://ral.ucar.edu/solutions/products/camels into the user's chosen directory
#'
#' more specifically this is linked to the version 1.2 timeseries meterology, observed flow, metadata here:
#' https://ral.ucar.edu/sites/default/files/public/product-tool/camels-catchment-attributes-and-meteorology-for-large-sample-studies-dataset-downloads/basin_timeseries_v1p2_metForcing_obsFlow.zip
#'
#' as well as the CAMELS attribute data v 2.0 from here:
#' https://ral.ucar.edu/sites/default/files/public/product-tool/camels-catchment-attributes-and-meteorology-for-large-sample-studies-dataset-downloads/camels_attributes_v2.0.zip
#'
#'
#'
#'
#' @param data_dir NEW directory path that will be created by this function, the filepath leading up to the final folder should already exist, while the last folder should not yet exist and will be created for you
#'
#' @return NA
#' @export
#'
#' @examples
#'\donttest{
#' data_dir <- "~/CAMELS_data"
#' download_camels(data_dir)
#'}
#'
download_camels <- function(data_dir) {

  ### create directory and file paths based on it.
  dir.create(data_dir)
  attr_dest <- paste(data_dir, "/attributes.zip", sep = "")
  all_dest <- paste(data_dir, "/all_data.zip", sep = "")

  ## download attribute data
  message(cat("downloading attribute data:"))
  download.file("https://ral.ucar.edu/sites/default/files/public/product-tool/camels-catchment-attributes-and-meteorology-for-large-sample-studies-dataset-downloads/camels_attributes_v2.0.zip", destfile = attr_dest, method = "auto")

  ## a few (uneccessary) files within the .zip folder cause the unzip function to break, removing these here
  filt <- zip_list(attr_dest) %>%
    filter(!str_detect(filename, "Icon"))

  ## unzip into the user defined directory
  message(cat("unzipping attribute data to:", paste(attr_dest)))
  unzip(attr_dest, files = paste(filt$filename), exdir = data_dir)


  message(cat("downloading attribute data:"))
  download.file("https://ral.ucar.edu/sites/default/files/public/product-tool/camels-catchment-attributes-and-meteorology-for-large-sample-studies-dataset-downloads/basin_timeseries_v1p2_metForcing_obsFlow.zip", destfile = all_dest, method = "auto")

  ## removing the Icon file like before as well as one single file from daymet that ends with a '*' that breaks the unzip function
  filt <- zip_list(all_dest) %>%
    dplyr::filter(!str_detect(filename, "Icon") & !str_detect(filename, "\\*"))

  message(cat("unzipping attribute data to:", paste(all_dest)))
  unzip(all_dest, files = paste(filt$filename), exdir = data_dir)

}
