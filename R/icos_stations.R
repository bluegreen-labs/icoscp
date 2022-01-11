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

  # define endpoint
  endpoint <- server()

  # add station filter
  if(!missing(station)){
    flt <- sprintf("FILTER(?stationId = '%s' ) . ",station)
  } else {
    flt <- ""
  }

  # define query
  # query <- sprintf("
  #           prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
  #           select *
  #           from <http://meta.icos-cp.eu/resources/icos/>
  #           from <http://meta.icos-cp.eu/resources/extrastations/>
  #           where {
  #           	?uri cpmeta:hasStationId ?id .
  #           	%s
  #           	OPTIONAL {?uri cpmeta:hasName ?name  } .
  #           	OPTIONAL {?uri cpmeta:countryCode ?country }.
  #           	OPTIONAL {?uri cpmeta:hasLatitude ?lat }.
  #           	OPTIONAL {?uri cpmeta:hasLongitude ?lon }.
  #           	OPTIONAL {?uri cpmeta:hasElevation ?elevation } .
  #           }
  #           ", flt)

  query <- sprintf('
            prefix st: <http://meta.icos-cp.eu/ontologies/stationentry/>
            select distinct ?stationId ?stationName ?stationTheme
            ?class  ?siteType
            ?lat ?lon ?eas ?eag ?firstName ?lastName ?email ?country
            from <http://meta.icos-cp.eu/resources/stationentry/>
            where{
                ?s st:hasShortName ?stationId .
                %s
                optional{?s st:hasLon ?lon} .
                optional{?s st:hasLat ?lat} .
                optional{?s st:hasElevationAboveSea ?eas} .
                optional{?s st:hasElevationAboveGround ?eag} .
                ?s st:hasLongName ?stationName .
                ?s st:hasPi ?pi .
                ?pi st:hasFirstName ?firstName .
                ?pi st:hasLastName ?lastName .
                ?pi st:hasEmail ?email .
                ?s a ?stationClass .
                ?s st:hasStationClass ?class .
                optional{?s st:hasCountry ?country} .
                optional{?s st:hasSiteType ?siteType} .

                BIND (replace(str(?stationClass), "http://meta.icos-cp.eu/ontologies/stationentry/", "") AS ?stationTheme )
            }
        ', flt)


  # retrieve sparql data
  df <- try(
    SPARQL::SPARQL(
        endpoint,
        query,
        format = "xml"
      )$results
    )

  # check results
  if(inherits(df, "try-error") || nrow(df) == 0 ) {
    stop("No data returned, check your station name")
  }

  # return results as a dataframe
  return(df)

}

