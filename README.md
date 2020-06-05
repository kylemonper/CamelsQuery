# CamelsQuery

This package ease the processing of NCAR Catchement Attributes and Meteorlogy for Large-sample Studies (CAMELS) data using R using a set of USGS stream gages ([here](https://help.waterdata.usgs.gov/) for more). This package offers a function for downloading the data automatically, are it can be downloaded at the following site:

CAMELS data: https://ral.ucar.edu/solutions/products/camels

## More about this data set

671 small - medium size catchments over the contiguous US (CONUS) minimally impacted by human activities.

2 main type of daily time-series:

- Daily atmospheric forcing (source: Daymet, Maurer and NLDAS)
- Hydrologic reponse (source: USGS daily streamflow)

Attributes data (climatologies):

- topography
- climate
- streamflow
- land cover
- soil
- geology

code creating the data: https://github.com/naddor/camels

## Package installation:
``` 
install.packages("devtools")
devtools::install_github("kylemonper/CamelsQuery")
```
