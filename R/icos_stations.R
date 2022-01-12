#' List all ICOS collections
#'
#' A list of all ICOS collections. Collections are aggregate products, you
#' will find additional identifying DOIs for proper referencing and further
#' exploration in the returned table.
#'
#' @param station station id to subset from larger list (default missing)
#'
#' @return a data frame with ICOS collections
#' @export
#'
#' @examples
#' \dontrun{
#' station_info <- icos_stations()
#' print(station_info)
#' }

icos_stations <- function(
  station
  ) {

  # define endpoint
  endpoint <- server()

  # add station filter
  if(!missing(station)){
    flt_icos <- sprintf("FILTER(?stationId = '%s' ) . ",station)
    flt_full <- sprintf("FILTER(?id = '%s' ) . ",station)
  } else {
    flt_icos <- ""
    flt_full <- ""
  }

  # define query
  icos_query <- sprintf('
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
        ', flt_icos)

  full_query <- sprintf("
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
            ", flt_full)

  # retrieve sparql data
  # for well documented icos sites
  # from the python implementation
  # it seems that this will be the final table
  # the full table listed below will not be
  # required in the end (or vise versa)
  icos_df <- try(
    SPARQL::SPARQL(
        endpoint,
        icos_query,
        format = "xml"
      )$results
    )

  # retrieve sparql data
  # for all sites (regardless of meta-data quality)
  full_df <- try(
    SPARQL::SPARQL(
      endpoint,
      full_query,
      format = "xml"
    )$results
  )

  # check results
  if(inherits(full_df, "try-error") || nrow(full_df) == 0 ) {
    message("Station not found, check your station name")
    return(NULL)
  } else {
    # reformat the uri
    full_df$uri <- gsub("<||>","", full_df$uri)
  }

  # check results
  if(inherits(icos_df, "try-error") || nrow(icos_df) == 0 ) {
    message("
      No ICOS data returned, returning limited meta-data for
      requested site.
      ")
    # return
    df <- full_df
  } else {
    # rename columns
    icos_df <- dplyr::rename(icos_df,
                             'id' = 'stationId',
                             'name' = 'stationName',
                             'theme' = 'stationTheme',
                             'type' = 'siteType',
                             'first_name' = 'firstName',
                             'last_name' = 'lastName'
    ) |>
      dplyr::select(
        -"lat",
        -"lon",
        -"country"
      )

    # Certain columns are dropped due to duplicate use and above all
    # inconsistent values between what should be equivalent tables
    # not sure why, also not my problem. For convenience the values
    # are dropped from the ICOS table (as this is a subset of the
    # full site list)

    # join both the full data and the ICOS fully annotated meta-data
    # tables
    df <- dplyr::left_join(full_df, icos_df, by = c('id','name'))
  }

  # return results as a data frame
  return(df)
}

