#' Get a digital object's citation
#'
#' Grabs the citation of the digital object from the ICOS server or
#' the CrossRef server if it exists. Both this internal ICOS citation
#' as well as the common 'academic' citation is provided if available.
#'
#' @param dobj a digital object URI or PID (persistent identifier)
#' @param doi doi of a manuscript or document (as listed by icos_collections())
#' @param style the sitation style (default = 'apa')
#' @param lang the language of the common citation (default = 'en-GB')
#'
#' @return a dataframe with an icos and common citation to be used in
#'  publications when using the referenced digital object
#' @export
#'
#' @examples
#' \dontrun{
#' dobj <- "https://meta.icos-cp.eu/objects/lNJPHqvsMuTAh-3DOvJejgYc"
#' print(icos_citation(dobj))
#' }

icos_citation <- memoise::memoise(
  function(
  dobj,
  doi,
  style = 'apa',
  lang = 'en-GB'
  ) {

  # catch errors in parameters
  if (missing(dobj) && missing(doi)) {
    message("Missing digital object (dobj) reference, returning NULL")
    return(NULL)
  } else if (!missing(dobj)) {
      # define endpoint
      endpoint <- server()

      # format string whatever way
      # you cut it
      dobj <- gsub("<||>", "", as.character(dobj))
      dobj <- basename(dobj)
      dobj <- sprintf("<https://meta.icos-cp.eu/objects/%s>", dobj)

      # define query
      query <- sprintf("
            prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
              select * where{
                optional{%s cpmeta:hasCitationString ?cit}}
            ", dobj)

      # retrieve sparql data
      icos_citation <- try(
        SPARQL::SPARQL(
          endpoint,
          query,
          format = "xml"
        )$results
      )

      # check results, if nothing is there
      # set to NA if missing
      if (inherits(icos_citation, "try-error") || nrow(icos_citation) == 0) {
        icos_citation <- NA
      } else {
        icos_citation <- icos_citation$cit
      }
  } else {
    icos_citation <- NA
  }

  # check conditions
  if (missing(doi) && !missing(dobj)) {
    # grab dobj info
    doi <- icos_dobj_info(dobj)$doi
  }

  # set citation server crossref url
  url = 'https://citation.crosscite.org/format?'

  query <- list(
    "doi" = doi,
    "style" = style,
    "lang" = lang)

  # try to download the data
  common_citation <- httr::GET(
    url = url,
    query = query)

  # trap errors on download, return a general error statement
  # with the most common causes
  if (httr::status_code(common_citation) == 400 ||
      httr::status_code(common_citation) > 400) {
    citation <- data.frame(
      icos_citation = icos_citation,
      common_citation = NA
      )
  } else {
    citation <- data.frame(
      icos_citation = icos_citation,
      common_citation = httr::content(common_citation)
    )
  }

  # return results as a dataframe
  return(citation)
})
