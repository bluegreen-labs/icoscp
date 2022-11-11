#' Download an ICOS digital object
#'
#' Download a digital object identified by a persistent identifier.
#'
#' @param dobj digital object identified by a persistent identifier (PID) URI
#' @param internal read in data and return an internal data frame to the
#'  current workspace
#' @param verbose verbose feeback on licensing, needs you to acknowledge
#'  the license agreement for a download - setting this to FALSE overrides
#'  this but by doing so you acknowledge the statement in bulk!
#' @param path where to save the downloaded data (default = tempdir())
#' @importFrom memoise memoise
#' @return a downloaded digital file on disk for further processing
#' @export
#'
#' @examples
#' \dontrun{
#' dobj <- "https://meta.icos-cp.eu/objects/lNJPHqvsMuTAh-3DOvJejgYc"
#' icos_download(dobj = dobj, verbose = FALSE)
#' }

icos_download <- function(
  dobj,
  path = tempdir(),
  internal = FALSE,
  verbose = TRUE
  ) {

  # trap parameter exception
  if (missing(dobj)){
    message("Digital object persistent identifier is missing, returning NULL!")
    return(invisible(NULL))
  }

  # format string whatever way
  # you cut it
  dobj <- gsub("<||>", "", as.character(dobj))
  dobj <- basename(dobj)

  # get dobj info to extract the proper filename
  info <- icos_dobj_info(dobj = dobj)

  if(verbose) {
    message(
      "
      I hereby confirm that I have taken notice of
      the information provided to inform me about
      the data and good practices of data usage.
      These guidelines do not define additional
      contractual conditions.

      Please validate with YES or NO!
      ")

    answer <- readline("Validate: ")

    if (tolower(answer) != "yes"){
      return(invisible(NULL))
    }
  }

  # set url
  url <- download_server()

  # format the download query
  url <- paste0(url,'ids=%5B%22', dobj,'%22%5D')

  # create filenames for the output files
  icos_file <- file.path(normalizePath(path), info$fileName)
  icos_tmp_file <- file.path(normalizePath(tempdir()), info$fileName)

  # try to download the data
  error <- httr::GET(
    url = url,
    #query = query,
    httr::write_disk(
      path = icos_tmp_file,
      overwrite = TRUE
      )
    )

  # trap errors on download, return a general error statement
  # with the most common causes
  if (httr::status_code(error) == 400){
    file.remove(icos_tmp_file)
    warning("Your requested data is outside DAYMET spatial coverage.\n
            Check the requested coordinates.")
    return(invisible(NULL))
  }

  if (httr::status_code(error) > 400){
    file.remove(icos_tmp_file)
    warning("The server is unreachable, check your connection.")
    return(invisible(NULL))
  }

  # if internal is FALSE just copy the temporary
  # file over to the destination path, if TRUE
  # return data to the R workspace
  if (internal) {

    message("
      Not yet functioning... come back later!
      Might be removed due to the various formats
      which are hard to parse...
      ")

  } else {

    # Copy data from temporary file to final location
    # and delete original, with an exception for tempdir() location.
    # The latter to facilitate package integration.
    if (!identical(icos_tmp_file, icos_file)) {
      file.copy(icos_tmp_file,
                icos_file,
                overwrite = TRUE,
                copy.mode = FALSE)
      invisible(file.remove(icos_tmp_file))
    } else {
      message("Output path == tempdir(), file not copied or removed!")
    }
  }
}

