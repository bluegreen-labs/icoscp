#' List products for a station
#'
#' A list of all station data types including some
#' meta-data such as the estimated size, the type of data,
#' the time frame and the required URI for downloading
#' the data.
#'
#' @param uri url pointing to a resource
#' @param level data quality level (default = 2)
#'
#' @return a list of station meta-data
#' @export
#'
#' @examples
#' \dontrun{
#' products <- icos_products()
#' }

icos_products <- memoise::memoise(
  function(
    uri,
    level = 2
    ) {

  if (missing(uri)){
    message("No URI provided, returning NULL")
    return(invisible(NULL))
  }

  # define endpoint
  endpoint <- server()

  # set level strings
  if (tolower(level) == "all") {
    level <- ">0"
  } else if (level %in% c(1,2,3)) {
    level <- paste("=", tolower(level))
  } else {
    message("Please check your specified data level!")
    return(invisible(NULL))
  }

  # format uri string
  uristr <- sprintf("<%s>", paste(uri, collapse = " "))

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
    message("No data returned, check your station name")
    return(invisible(NULL))
  }

  # return results as a dataframe
  return(df)
})
