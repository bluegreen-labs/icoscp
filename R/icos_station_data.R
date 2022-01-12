#' Station data
#'
#' A list of all station data types
#'
#' @param uri url pointing to a resource
#' @param level data quality level (default = 2)
#'
#' @return a list of station meta-data
#' @export
#'
#' @examples
#' \dontrun{
#' all_station_info <- icos_stations_data()
#' }

icos_station_data <- function(
  uri,
  level = 2
  ) {

  # https://github.com/ICOS-Carbon-Portal/pylib/blob/master/icoscp/sparql/sparqls.py

  # define endpoint
  endpoint <- server()

  if (tolower(level) == "all") {
    level <- ">0"
  } else if (level %in% c(1,2,3)) {
    level <- paste("=", level)
  } else {
    stop("Please check your specified data level!")
  }

  # format uri string
  uristr <- sprintf("<> <%s>", paste(uri, collapse = ""))

  print(level)
  print(uristr)

  # format query
  query <- sprintf('
	prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
			prefix prov: <http://www.w3.org/ns/prov#>
			select *
			where {
				VALUES ?station {%s}
				?dobj cpmeta:hasObjectSpec ?spec .
				FILTER NOT EXISTS {?spec cpmeta:hasAssociatedProject/cpmeta:hasHideFromSearchPolicy "true"^^xsd:boolean}
				FILTER NOT EXISTS {[] cpmeta:isNextVersionOf ?dobj}
				?dobj cpmeta:wasAcquiredBy / prov:startedAtTime ?timeStart .
				?dobj cpmeta:wasAcquiredBy / prov:endedAtTime ?timeEnd .
				?dobj cpmeta:wasAcquiredBy/prov:wasAssociatedWith ?station .
                ?spec rdfs:label ?specLabel .
                OPTIONAL {?dobj cpmeta:wasAcquiredBy/cpmeta:hasSamplingHeight ?samplingheight} .
				?spec cpmeta:hasDataLevel ?datalevel .
                ?dobj cpmeta:hasSizeInBytes ?bytes .
				FILTER (?datalevel %s)
            }
        ', uristr, level)

  # retrieve sparql data
  df <- try(
    SPARQL::SPARQL(
      endpoint,
      query,
      format = "xml"
    )$results
  )

  # check results
  if( inherits(df, "try-error") || nrow(df) == 0 ) {
    stop("No data returned, check your station name")
  }

  # return results as a dataframe
  return(df)
}
