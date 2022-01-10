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

  # def collections(id=None):
  #   """
  #   Return Collections
  #   Parameters
  #   ----------
  #   id : STR, optional
  #       The default is None, which returns all know collections.
  #       You can provide a ICOS URI or DOI to filter for a specifict collection
  #   Returns
  #   -------
  #   query : STR
  #       A query, which can be run against the SPARQL endpoint.
  #   """
  #
  # if not id:
  #   coll = '' # create an empyt string insert into sparql query
  #   else:
  #     coll = ''.join(['FILTER(str(?collection) = "' + id+ '" || ?doi = "' + id + '") .'])
  #
  #     query = """
  #           prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
  #           prefix dcterms: <http://purl.org/dc/terms/>
  #           select * where{
  #           ?collection a cpmeta:Collection .
  #           %s
  #           OPTIONAL{?collection cpmeta:hasDoi ?doi} .
  #           ?collection dcterms:title ?title .
  #           OPTIONAL{?collection dcterms:description ?description}
  #           FILTER NOT EXISTS {[] cpmeta:isNextVersionOf ?collection}
  #           }
  #           order by ?title
  #           """ % coll
  #
  #     return query


}
