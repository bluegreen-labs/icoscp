#' Grab digital object info
#'
#' Get additional information on a digital object.
#'
#' @param dobj digital object URI or PID
#'
#' @return a data frame with digital object information
#' @export
#'
#' @examples
#' \dontrun{
#' dobj <- "https://meta.icos-cp.eu/objects/lNJPHqvsMuTAh-3DOvJejgYc"
#' print(icos_dobj_info(dobj))
#' }

icos_dobj_info <- memoise::memoise(
  function(dobj) {

  # define endpoint
  endpoint <- server()

  # format string whatever way
  # you cut it
  dobj <- gsub("<||>", "", as.character(dobj))
  dobj <- basename(dobj)
  dobj <- sprintf("<https://meta.icos-cp.eu/objects/%s>", dobj)

  query <- sprintf("
            prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
            select * where {
                values ?dobj { %s }
                ?dobj cpmeta:hasObjectSpec ?objSpec ;
                cpmeta:hasNumberOfRows ?nRows ;
                cpmeta:hasName ?fileName .
                ?objSpec rdfs:label ?specLabel .
                OPTIONAL{?dobj cpmeta:hasActualColumnNames ?columnNames }
            }
            ", dobj)

  # runs sparql query
  df <- try(
    SPARQL::SPARQL(
      endpoint,
      query,
      format = "xml"
    )$results
  )

  # check results
  if(inherits(df, "try-error") || nrow(df) == 0 ) {
    message("No info found for the digital object")
    return(NULL)
  } else {
    return(df)
  }
})
