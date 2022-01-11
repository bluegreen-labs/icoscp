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
#' all_station_info <- icos_stations()
#' }

icos_station_data <- function(
  uri,
  level = 2
  ) {

  # https://github.com/ICOS-Carbon-Portal/pylib/blob/master/icoscp/sparql/sparqls.py

  # define endpoint
  endpoint <- server()

  # # add station filter
  # if(!missing(station)){
  #   # flt <- sprintf("FILTER(?id = '%s' ) . ",station)
  # } else {
  #   flt <- ""
  # }

  flt <- ""

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

#
# accepted_levels = [1,2,3]
# try:
#   if not isinstance(level,str):
#   return
# if level.lower() == 'all':
#   level = '>0'
# elif not int(level) in accepted_levels:
#   level=' >1'
# else:
#   level = ' = ' + level
# except:
#   return 'input parameters not valid'
#
# uristr = '<' + '> <'.join(uri) + '>'
# query = """
# 			prefix cpmeta: <http://meta.icos-cp.eu/ontologies/cpmeta/>
# 			prefix prov: <http://www.w3.org/ns/prov#>
# 			select *
# 			where {
# 				VALUES ?station {%s}
# 				?dobj cpmeta:hasObjectSpec ?spec .
# 				FILTER NOT EXISTS {?spec cpmeta:hasAssociatedProject/cpmeta:hasHideFromSearchPolicy "true"^^xsd:boolean}
# 				FILTER NOT EXISTS {[] cpmeta:isNextVersionOf ?dobj}
# 				?dobj cpmeta:wasAcquiredBy / prov:startedAtTime ?timeStart .
# 				?dobj cpmeta:wasAcquiredBy / prov:endedAtTime ?timeEnd .
# 				?dobj cpmeta:wasAcquiredBy/prov:wasAssociatedWith ?station .
#                 ?spec rdfs:label ?specLabel .
#                 OPTIONAL {?dobj cpmeta:wasAcquiredBy/cpmeta:hasSamplingHeight ?samplingheight} .
# 				?spec cpmeta:hasDataLevel ?datalevel .
#                 ?dobj cpmeta:hasSizeInBytes ?bytes .
# 				FILTER (?datalevel  %s)
#             }          """ % (uristr, level)
