#' ICOS collections
#'
#' Returns icon collections. By default all collections are returned, if an id
#' is given only collection information for this partuicular DOI is provided.
#'
#' @param id an URI or DOI, default (missing)
#'
#' @return all ICOS collections (or a desired subset)
#' @export

icos_collections <- function(id) {

  # define endpoint
  endpoint <- server()

  # add station filter
  if(!missing(id)){
    flt <- sprintf("FILTER(?collection = '%s' || ?doi = '%s' ) . ",id, id)
  } else {
    flt <- ""
  }

  # define query
  query <- sprintf("
           prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
             prefix dcterms: <http://purl.org/dc/terms/>
             select * where{
               ?collection a cpmeta:Collection .
               %s
               OPTIONAL{?collection cpmeta:hasDoi ?doi} .
               ?collection dcterms:title ?title .
               OPTIONAL{?collection dcterms:description ?description}
               FILTER NOT EXISTS {[] cpmeta:isNextVersionOf ?collection}
             }
           order by ?title
            ", flt)

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
    stop("No data returned, check your id name")
  }

  # return results as a dataframe
  print(df)

}
