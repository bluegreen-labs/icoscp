#' List all ICOS station info
#'
#' A list of all station meta-data such as latittude, longitude and elevation
#'
#' @param station station id to subset from larger list (default missing)
#'
#' @return a list of station meta-data
#' @export
#'
#' @examples
#' \dontrun{
#' all_station_info <- icos_stations()
#' }

icos_stations <- function(station) {

  # Step 1 - Set up preliminaries and define query
  # Define the data.gov endpoint
  endpoint <- "https://meta.icos-cp.eu/sparql"

  # add station filter
  if(!missing(station)){
    flt <- sprintf("FILTER(?id = '%s' ) . ",station)
  } else {
    flt <- ""
  }

  query <- sprintf("
            prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
            select *
            from <http://meta.icos-cp.eu/resources/icos/>
            from <http://meta.icos-cp.eu/resources/extrastations/>
            where {
            	?uri cpmeta:hasStationId ?id .
            	%s
            	OPTIONAL {?uri cpmeta:hasName ?name  } .
            	OPTIONAL {?uri cpmeta:countryCode ?country }.
            	OPTIONAL {?uri cpmeta:hasLatitude ?lat }.
            	OPTIONAL {?uri cpmeta:hasLongitude ?lon }.
            	OPTIONAL {?uri cpmeta:hasElevation ?elevation } .
            }
            ", flt)

  # retrieve data
  df <- try(SPARQL(endpoint, query, format = "xml")$results)

  if(inherits(df, "try-error") || nrow(df) == 0 ) {
    stop("No data returned, check your station name")
  }

  # return results as a dataframe
  print(df)

}
